//
//  JEDPhotoTableViewCell.m
//  SimpleTumblrClient
//
//  Created by Justyna Dolińska on 26/04/16.
//  Copyright © 2016 Justyna Dolińska. All rights reserved.
//

#import "JEDPhotoTableViewCell.h"


static CGFloat const kMargin = 5;


@interface JEDPhotoTableViewCell ()

@property (nonatomic, strong) UIImageView *photoImageView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation JEDPhotoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];

    UIView *backgroudView = [[UIView alloc] initWithFrame:CGRectInset(self.contentView.bounds, kMargin, kMargin)];
    backgroudView.backgroundColor = [UIColor whiteColor];
    backgroudView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.contentView addSubview:backgroudView];

    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicator.hidesWhenStopped = YES;
    self.activityIndicator.color = [UIColor greenColor];
    self.activityIndicator.center = backgroudView.center;
    self.activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
    [backgroudView addSubview:self.activityIndicator];
    NSLayoutConstraint *activityIndicatorCenterXConstraint = [self.activityIndicator.centerXAnchor constraintEqualToAnchor:backgroudView.centerXAnchor];
    NSLayoutConstraint *activityIndicatorCenterYConstraint = [self.activityIndicator.centerYAnchor constraintEqualToAnchor:backgroudView.centerYAnchor];
    [NSLayoutConstraint activateConstraints:@[activityIndicatorCenterXConstraint,activityIndicatorCenterYConstraint]];

    self.photoImageView = [[UIImageView alloc] initWithFrame:CGRectInset(backgroudView.bounds, kMargin, kMargin)];
    self.photoImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.photoImageView.backgroundColor = [UIColor clearColor];
    self.photoImageView.contentMode = UIViewContentModeScaleAspectFit;
    [backgroudView addSubview:self.photoImageView];
}

- (void)reset
{
    [self.activityIndicator startAnimating];
    self.photoImageView.image = nil;
}

- (void)setupWithImage:(UIImage *)image
{
    [self.activityIndicator stopAnimating];
    self.photoImageView.image = image;
}

+ (CGFloat)heightForCellWidth:(CGFloat)cellWidth imageSize:(CGSize)imageSize
{
    CGFloat imageWidth = cellWidth - 4 * kMargin;
    if (imageWidth >= imageSize.width) {
        return imageSize.height + 4 * kMargin;
    }
    return (imageSize.height / imageSize.width) * imageWidth + 4 * kMargin;
}

@end
