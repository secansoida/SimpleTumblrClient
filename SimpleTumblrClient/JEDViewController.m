//
//  JEDViewController.m
//  SimpleTumblrClient
//
//  Created by Justyna Dolińska on 21/04/16.
//  Copyright © 2016 Justyna Dolińska. All rights reserved.
//

#import "JEDViewController.h"
#import "JEDFeedFetcher.h"

@import JavaScriptCore;

@interface JEDViewController () <UISearchBarDelegate>

@property (nonatomic, strong) JEDFeedFetcher *feedFetcher;

@end

@implementation JEDViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupSearchBar];

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

    UISearchBar *searchBar = [UISearchBar new];

    searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    searchBar.frame = CGRectMake(0,
                                 CGRectGetHeight([UIApplication sharedApplication].statusBarFrame),
                                 CGRectGetWidth(self.view.bounds),
                                 32);
    searchBar.delegate = self;
    searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:searchBar];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)showFeedForUsername:(NSString *)username
{
    [self.feedFetcher fetchFeedForUsername:username withCompletion:^(JEDFeedResponse *response, NSError *error) {
        if (response) {
            NSLog(@"%@", response);
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

@end
