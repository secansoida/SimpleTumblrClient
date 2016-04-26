//
//  JEDPhotoTableViewCell.h
//  SimpleTumblrClient
//
//  Created by Justyna Dolińska on 26/04/16.
//  Copyright © 2016 Justyna Dolińska. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JEDPhotoTableViewCell : UITableViewCell

- (void)reset;
- (void)setupWithImage:(UIImage *)image;
+ (CGFloat)heightForCellWidth:(CGFloat)cellWidth imageSize:(CGSize)imageSize;

@end
