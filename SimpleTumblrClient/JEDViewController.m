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

@import JavaScriptCore;

@interface JEDViewController () <UISearchBarDelegate, UITableViewDataSource>

@property (nonatomic, strong) JEDFeedFetcher *feedFetcher;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) JEDFeedResponse *currentResponse;

@end

@implementation JEDViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupSearchBar];

    [self setupTableView];

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];

    self.feedFetcher = [[JEDFeedFetcher alloc] initWithSession:session];

    NSString *username = @"pixeloutput";

    [self showFeedForUsername:username];
    
}

- (void)setupSearchBar
{
    UISearchBar *searchBarAppearance = [UISearchBar appearance];
    [searchBarAppearance setBarTintColor:[UIColor whiteColor]];
    [searchBarAppearance setTintColor:[UIColor greenColor]];
    UITextField *textFieldAppearance = [UITextField appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]];
    UIFont *font = [UIFont fontWithName:@"Courier New" size:14] ?: [UIFont systemFontOfSize:14];
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
    [self.view addSubview:self.tableView];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self showFeedForUsername:searchBar.text];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    JEDPost *post = self.currentResponse.posts[indexPath.row];
    cell.textLabel.text = [[NSDate dateWithTimeIntervalSince1970:[post.timestamp doubleValue]] description];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.currentResponse) {
        return self.currentResponse.posts.count;
    }
    return 0;
}

@end
