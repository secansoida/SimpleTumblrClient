//
//  JEDPost.m
//  SimpleTumblrClient
//
//  Created by Justyna Dolińska on 23/04/16.
//  Copyright © 2016 Justyna Dolińska. All rights reserved.
//

#import "JEDPost.h"

@implementation JEDPost

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"identifier" : @"id",
             @"timestamp" : @"unix-timestamp",
             };
}

+ (NSValueTransformer *)typeJSONTransformer
{
    NSDictionary *dictionary = @{
                                 @"text": @(JEDPostTypeText),
                                 @"photo": @(JEDPostTypePhoto),
                                 @"quote": @(JEDPostTypeQuote),
                                 @"link": @(JEDPostTypeLink),
                                 @"chat": @(JEDPostTypeChat),
                                 @"audio": @(JEDPostTypeAudio),
                                 @"video": @(JEDPostTypeVideo),
                                 @"answer": @(JEDPostTypeAnswer),
                                 };
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:dictionary
                                                            defaultValue:@(JEDPostTypeDefault)
                                                     reverseDefaultValue:@""];
}

@end
