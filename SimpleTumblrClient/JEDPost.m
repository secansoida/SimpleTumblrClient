//
//  JEDPost.m
//  SimpleTumblrClient
//
//  Created by Justyna Dolińska on 23/04/16.
//  Copyright © 2016 Justyna Dolińska. All rights reserved.
//

#import "JEDPost.h"
#import "JEDPhotoPost.h"


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
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:[self stringToPostTypeMapping]
                                                            defaultValue:@(JEDPostTypeDefault)
                                                     reverseDefaultValue:@""];
}

+ (Class)classForParsingJSONDictionary:(NSDictionary *)JSONDictionary
{
    NSString *postTypeString = [JSONDictionary objectForKey:@"type"];
    NSNumber *postTypeNumber = [[self stringToPostTypeMapping] objectForKey:postTypeString];
    if (!postTypeNumber) {
        return [self class];
    }
    JEDPostType postType = [postTypeNumber unsignedIntegerValue];
    switch (postType) {
        case JEDPostTypePhoto:
            return [JEDPhotoPost class];
            break;
        default:
            return [self class];
            break;
    }
}

+ (NSDictionary *)stringToPostTypeMapping
{
    static NSDictionary *stringToPostTypeMapping;
    if (!stringToPostTypeMapping) {
        stringToPostTypeMapping = @{
                                    @"text": @(JEDPostTypeText),
                                    @"photo": @(JEDPostTypePhoto),
                                    @"quote": @(JEDPostTypeQuote),
                                    @"link": @(JEDPostTypeLink),
                                    @"chat": @(JEDPostTypeChat),
                                    @"audio": @(JEDPostTypeAudio),
                                    @"video": @(JEDPostTypeVideo),
                                    @"answer": @(JEDPostTypeAnswer),
                                    };
    }
    return stringToPostTypeMapping;
}

@end
