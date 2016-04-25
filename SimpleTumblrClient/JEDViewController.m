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

@interface JEDViewController ()

@property (nonatomic, strong) JEDFeedFetcher *feedFetcher;

@end

@implementation JEDViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UILabel *helloLabel = [UILabel new];
    helloLabel.text = @"Hello world!";
    helloLabel.frame = self.view.bounds;
    helloLabel.textColor = [UIColor blueColor];
    helloLabel.numberOfLines = 0;
    [self.view addSubview:helloLabel];

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];

    self.feedFetcher = [[JEDFeedFetcher alloc] initWithSession:session];

    NSString *username = @"pixeloutput";

    [self.feedFetcher fetchFeedForUsername:username withCompletion:^(JEDFeedResponse *response, NSError *error) {
        if (response) {
            NSLog(@"%@", response);
        } else {
            NSLog(@"%@", error);
        }
    }];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
