//
//  JEDPhotoPost.m
//  SimpleTumblrClient
//
//  Created by Justyna Dolińska on 25/04/16.
//  Copyright © 2016 Justyna Dolińska. All rights reserved.
//

#import "JEDPhotoPost.h"

@implementation JEDPhotoPost

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSDictionary *dict = @{
                           @"caption" : @"photo-caption",
                           @"fullSizeURL" : @"photo-url-1280",
                           @"smallSizeURL" : @"photo-url-100",
                           };
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:dict];
}

+ (NSValueTransformer *)fullSizeURLJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)smallSizeURLJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

@end
