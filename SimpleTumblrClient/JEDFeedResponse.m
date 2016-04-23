//
//  JEDFeedResponse.m
//  SimpleTumblrClient
//
//  Created by Justyna Dolińska on 23/04/16.
//  Copyright © 2016 Justyna Dolińska. All rights reserved.
//

#import "JEDFeedResponse.h"
#import "JEDPost.h"

@implementation JEDFeedResponse

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             };
}

+ (NSValueTransformer *)postsJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[JEDPost class]];
}

@end
