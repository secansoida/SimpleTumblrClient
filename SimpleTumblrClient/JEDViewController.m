//
//  JEDViewController.m
//  SimpleTumblrClient
//
//  Created by Justyna Dolińska on 21/04/16.
//  Copyright © 2016 Justyna Dolińska. All rights reserved.
//

#import "JEDViewController.h"
#import "JEDFeedFetcher.h"
#import "JEDPost.h"
#import "JEDPhotoTableViewCell.h"
#import "JEDPhotoPost.h"

@import JavaScriptCore;


static NSString * const kDefaultCellReuseIdentifier = @"Cell";
static NSString * const kPhotoCellReuseIdentifier = @"PhotoCell";


@interface JEDViewController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) JEDFeedFetcher *feedFetcher;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) JEDFeedResponse *currentResponse;
@property (nonatomic, strong) NSMutableDictionary *simpleImageCache;

@end

@implementation JEDViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.simpleImageCache = [NSMutableDictionary new];

    [self setupSearchBar];

    [self setupTableView];

    [self.tableView registerClass:[JEDPhotoTableViewCell class]
           forCellReuseIdentifier:kPhotoCellReuseIdentifier];
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:kDefaultCellReuseIdentifier];

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];

    self.feedFetcher = [[JEDFeedFetcher alloc] initWithSession:session];

    NSString *username = @"pixeloutput";

    self.searchBar.text = username;

    ((UITextField *)self.searchBar.subviews[0].subviews[1]).backgroundColor = [UIColor blackColor];

    [self showFeedForUsername:username];
    
}

- (void)setupSearchBar
{
    UISearchBar *searchBarAppearance = [UISearchBar appearance];
    [searchBarAppearance setBarTintColor:[UIColor whiteColor]];
    [searchBarAppearance setTintColor:[UIColor greenColor]];
    UITextField *textFieldAppearance = [UITextField appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]];
    UIFont *font = [UIFont fontWithName:@"Courier New" size:14];
    [textFieldAppearance setDefaultTextAttributes:@{
                                                    NSFontAttributeName : font,
                                                    NSForegroundColorAttributeName : [UIColor greenColor],
                                                    }];
    [textFieldAppearance setBackgroundColor:[UIColor blackColor]];
    [textFieldAppearance setBorderStyle:UITextBorderStyleNone];

    self.searchBar = [UISearchBar new];

    self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.searchBar.frame = CGRectMake(0,
                                 CGRectGetHeight([UIApplication sharedApplication].statusBarFrame),
                                 CGRectGetWidth(self.view.bounds),
                                 32);
    self.searchBar.delegate = self;
    self.searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:self.searchBar];
}

- (void)setupTableView
{
    CGFloat searchBarMaxY = CGRectGetMaxY(self.searchBar.frame);
    CGRect tableViewFrame = CGRectMake(0,
                                       searchBarMaxY,
                                       CGRectGetWidth(self.view.bounds),
                                       CGRectGetHeight(self.view.bounds) - searchBarMaxY);
    self.tableView = [[UITableView alloc] initWithFrame:tableViewFrame];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor blackColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self.simpleImageCache removeAllObjects];
}


#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self showFeedForUsername:searchBar.text];
}


#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JEDPost *post = self.currentResponse.posts[indexPath.row];
    switch (post.type) {
        case JEDPostTypePhoto:
        {
            JEDPhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPhotoCellReuseIdentifier
                                                                          forIndexPath:indexPath];
            [self setupCell:cell atIndexPath:indexPath withPhotoPost:(JEDPhotoPost *)post];
            return cell;
        }
            break;
        default:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDefaultCellReuseIdentifier
                                                                    forIndexPath:indexPath];
            cell.textLabel.text = [[NSDate dateWithTimeIntervalSince1970:[post.timestamp doubleValue]] description];
            return cell;
        }
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.currentResponse) {
        return self.currentResponse.posts.count;
    }
    return 0;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JEDPost *post = self.currentResponse.posts[indexPath.row];
    switch (post.type) {
        case JEDPostTypePhoto:
        {
            JEDPhotoPost *photoPost = (JEDPhotoPost *)post;
            return [JEDPhotoTableViewCell heightForCellWidth:CGRectGetWidth(tableView.bounds)
                                                   imageSize:CGSizeMake([photoPost.width doubleValue], [photoPost.height doubleValue])
                                                     caption:photoPost.caption];
        }
            break;
        default:
            return 40;
            break;
    }
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}


#pragma mark - Private

- (void)setupCell:(JEDPhotoTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withPhotoPost:(JEDPhotoPost *)photoPost
{
    [cell reset];
    [cell setupWithCaption:photoPost.caption];
    UIImage *image = self.simpleImageCache[photoPost.fullSizeURL];
    if (image) {
        [cell setupWithImage:image];
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *imageData = [[NSData alloc] initWithContentsOfURL:photoPost.fullSizeURL];
        UIImage *image = [[UIImage alloc] initWithData:imageData];
        self.simpleImageCache[photoPost.fullSizeURL] = image;
        dispatch_async(dispatch_get_main_queue(), ^{
            JEDPhotoTableViewCell *photoCell = [self.tableView cellForRowAtIndexPath:indexPath];
            [photoCell setupWithImage:image];
        });
    });
}


- (void)showFeedForUsername:(NSString *)username
{
    [self.feedFetcher fetchFeedForUsername:username withCompletion:^(JEDFeedResponse *response, NSError *error) {
        if (response) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.currentResponse = response;
                [self.tableView reloadData];
            });
        } else {
            NSLog(@"%@", error);
        }
    }];
}

@end
