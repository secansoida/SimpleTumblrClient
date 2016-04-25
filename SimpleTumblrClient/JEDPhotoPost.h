//
//  JEDPhotoPost.h
//  SimpleTumblrClient
//
//  Created by Justyna Dolińska on 25/04/16.
//  Copyright © 2016 Justyna Dolińska. All rights reserved.
//

#import "JEDPost.h"

@interface JEDPhotoPost : JEDPost

@property (nonatomic, copy, readonly) NSString *caption;
@property (nonatomic, copy, readonly) NSNumber *width;
@property (nonatomic, copy, readonly) NSNumber *height;
@property (nonatomic, copy, readonly) NSURL *smallSizeURL;
@property (nonatomic, copy, readonly) NSURL *fullSizeURL;

@end
