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
@property (nonatomic, strong) UILabel *captionLabel;

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

    self.captionLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMargin, kMargin, CGRectGetWidth(backgroudView.bounds) - 2 * kMargin, 32)];
    self.captionLabel.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
    self.captionLabel.textColor = [UIColor greenColor];
    self.captionLabel.font = [UIFont fontWithName:@"Courier New" size:18];
    self.captionLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight;
    self.captionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.captionLabel.numberOfLines = 0;
    [backgroudView addSubview:self.captionLabel];

    self.photoImageView = [UIImageView new];
    self.photoImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.photoImageView.backgroundColor = [UIColor blackColor];
    self.photoImageView.contentMode = UIViewContentModeScaleAspectFit;
    [backgroudView addSubview:self.photoImageView];

    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicator.hidesWhenStopped = YES;
    self.activityIndicator.color = [UIColor greenColor];
    self.activityIndicator.center = backgroudView.center;
    self.activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
    [backgroudView addSubview:self.activityIndicator];


    NSLayoutConstraint *activityIndicatorCenterXConstraint = [self.activityIndicator.centerXAnchor constraintEqualToAnchor:self.photoImageView.centerXAnchor];
    NSLayoutConstraint *activityIndicatorCenterYConstraint = [self.activityIndicator.centerYAnchor constraintEqualToAnchor:self.photoImageView.centerYAnchor];
    [NSLayoutConstraint activateConstraints:@[activityIndicatorCenterXConstraint,activityIndicatorCenterYConstraint]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGRect boundingRect = [self.captionLabel.attributedText boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.captionLabel.frame), CGFLOAT_MAX)
                                                                         options:NSStringDrawingUsesLineFragmentOrigin
                                                                         context:nil];
    self.captionLabel.frame = CGRectMake(kMargin, kMargin, CGRectGetWidth(self.captionLabel.frame), boundingRect.size.height);
    CGRect photoImageViewFrame = CGRectMake(kMargin,
                                            CGRectGetMaxY(self.captionLabel.frame) + kMargin,
                                            CGRectGetWidth(self.captionLabel.frame),
                                            CGRectGetHeight(self.contentView.bounds) - CGRectGetHeight(self.captionLabel.frame) - 5 * kMargin);
    self.photoImageView.frame = photoImageViewFrame;
}

- (void)reset
{
    [self.activityIndicator startAnimating];
    self.photoImageView.image = nil;
    self.captionLabel.attributedText = nil;
}

- (void)setupWithCaption:(NSString *)caption
{
    self.captionLabel.attributedText = [[self class] attributedStringForCaption:caption];
}

- (void)setupWithImage:(UIImage *)image
{
    [self.activityIndicator stopAnimating];
    self.photoImageView.image = image;
}

+ (NSAttributedString *)attributedStringForCaption:(NSString *)caption
{
    NSMutableAttributedString *attributedCaption = [[NSMutableAttributedString alloc] initWithData:[caption dataUsingEncoding:NSUTF8StringEncoding]
                                                                                           options:@{
                                                                                                     NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                                     NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding),
                                                                                                     }
                                                                                documentAttributes:nil
                                                                                             error:nil];

    NSDictionary *attributes = @{
                                 NSFontAttributeName : [UIFont fontWithName:@"Courier New" size:18],
                                 NSForegroundColorAttributeName : [UIColor greenColor],
                                 };
    [attributedCaption addAttributes:attributes range:NSMakeRange(0, attributedCaption.length)];
    NSString *trimCaption = [attributedCaption.string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSRange range = [attributedCaption.string rangeOfString:trimCaption];
    if (!attributedCaption.string || range.location == NSNotFound) {
        return attributedCaption;
    }
    return [attributedCaption attributedSubstringFromRange:range];
}

+ (CGFloat)heightForCellWidth:(CGFloat)cellWidth imageSize:(CGSize)imageSize caption:(NSString *)caption
{
    CGFloat imageWidth = cellWidth - 4 * kMargin;
    NSAttributedString *attributedCaption = [self attributedStringForCaption:caption];
    CGRect boundingRect = [attributedCaption boundingRectWithSize:CGSizeMake(imageWidth, CGFLOAT_MAX)
                                                          options:NSStringDrawingUsesLineFragmentOrigin
                                                          context:nil];
    CGFloat labelHeight = CGRectGetHeight(boundingRect);
    CGFloat imageHeight = imageSize.height;
    if (imageWidth < imageSize.width) {
        imageHeight = (imageSize.height / imageSize.width) * imageWidth;
    }
    return 5 * kMargin + labelHeight + imageHeight;
}

@end
