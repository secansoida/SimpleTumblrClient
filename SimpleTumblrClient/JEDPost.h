//
//  JEDPost.h
//  SimpleTumblrClient
//
//  Created by Justyna Dolińska on 23/04/16.
//  Copyright © 2016 Justyna Dolińska. All rights reserved.
//

#import <Mantle/Mantle.h>

typedef NS_ENUM(NSUInteger, JEDPostType) {
    JEDPostTypeText,
    JEDPostTypeQuote,
    JEDPostTypePhoto,
    JEDPostTypeLink,
    JEDPostTypeChat,
    JEDPostTypeVideo,
    JEDPostTypeAudio,
    JEDPostTypeAnswer,
    JEDPostTypeDefault
};

@interface JEDPost : MTLModel <MTLJSONSerializing>

@property (nonatomic, assign, readonly) JEDPostType type;
@property (nonatomic, assign, readonly) NSNumber *identifier;
@property (nonatomic, assign, readonly) NSNumber *timestamp;

@end
