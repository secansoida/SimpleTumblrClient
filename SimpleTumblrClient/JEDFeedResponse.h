//
//  JEDFeedResponse.h
//  SimpleTumblrClient
//
//  Created by Justyna Dolińska on 23/04/16.
//  Copyright © 2016 Justyna Dolińska. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface JEDFeedResponse : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong, readonly) NSArray *posts; // JEDPost

@end
