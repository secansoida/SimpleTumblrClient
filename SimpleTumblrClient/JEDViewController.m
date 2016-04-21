//
//  ViewController.m
//  SimpleTumblrClient
//
//  Created by Justyna Dolińska on 21/04/16.
//  Copyright © 2016 Justyna Dolińska. All rights reserved.
//

#import "JEDViewController.h"

@interface JEDViewController ()

@end

@implementation JEDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UILabel *helloLabel = [UILabel new];
    helloLabel.text = @"Hello world!";
    [helloLabel sizeToFit];
    helloLabel.center = self.view.center;
    helloLabel.textColor = [UIColor blueColor];
    [self.view addSubview:helloLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
