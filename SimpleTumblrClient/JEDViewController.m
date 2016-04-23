//
//  JEDViewController.m
//  SimpleTumblrClient
//
//  Created by Justyna Dolińska on 21/04/16.
//  Copyright © 2016 Justyna Dolińska. All rights reserved.
//

#import "JEDViewController.h"
@import JavaScriptCore;

@interface JEDViewController ()

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
    NSURL *url = [NSURL URLWithString:@"https://pixeloutput.tumblr.com/api/read/json"];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];

    void (^completion)(NSData *, NSURLResponse *, NSError *) = ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *text;
        if (data) {
            text = [[NSString alloc] initWithData:data encoding:4];
            JSContext *context = [JSContext new];
            [context evaluateScript:text];
            NSLog(@"%@", [context[@"tumblr_api_read"] toDictionary]);
        } else {
            text = [NSString stringWithFormat:@"%@", error];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            helloLabel.text = text;
        });
    };
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url
                                            completionHandler:completion];
    [dataTask resume];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
