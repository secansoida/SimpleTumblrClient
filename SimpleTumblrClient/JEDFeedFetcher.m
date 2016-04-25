//
//  JEDFeedFetcher.m
//  SimpleTumblrClient
//
//  Created by Justyna Dolińska on 25/04/16.
//  Copyright © 2016 Justyna Dolińska. All rights reserved.
//

#import "JEDFeedFetcher.h"

@import JavaScriptCore;

static NSString * const kFeedURLFormat = @"https://%@.tumblr.com/api/read/json";
static NSString * const kFeedVariableName = @"tumblr_api_read";


@interface JEDFeedFetcher ()

@property (nonatomic, strong) NSURLSession *session;

@end

@implementation JEDFeedFetcher

- (instancetype)initWithSession:(NSURLSession *)session
{
    self = [super init];
    if (self) {
        _session = session;
    }
    return self;
}

- (void)fetchFeedForUsername:(NSString *)username
              withCompletion:(void (^)(JEDFeedResponse *, NSError *))completion
{
    NSParameterAssert(username);
    NSString *stringURL = [NSString stringWithFormat:kFeedURLFormat, username];
    NSURL *url = [NSURL URLWithString:stringURL];

    void (^completionHandler)(NSData *, NSURLResponse *, NSError *) = ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        JEDFeedResponse *newResponse;
        NSError *newError;
        if (data) {
            //TODO: get encoding from response
            NSString *stringData = [[NSString alloc] initWithData:data encoding:4];
            JSContext *context = [JSContext new];
            [context evaluateScript:stringData];
            NSDictionary *JSONdictionary = [context[@"tumblr_api_read"] toDictionary];
            if (!JSONdictionary) {
                newError = [NSError errorWithDomain:[NSBundle mainBundle].bundleIdentifier
                                               code:4001
                                           userInfo:@{
                                                      NSLocalizedDescriptionKey : @"Error fetching data",
                                                      }];
            } else {
                NSError *parsingError;
                newResponse = [MTLJSONAdapter modelOfClass:[JEDFeedResponse class]
                                        fromJSONDictionary:JSONdictionary
                                                     error:&parsingError];
                if (!newResponse) {
                    newError = [NSError errorWithDomain:[NSBundle mainBundle].bundleIdentifier
                                                   code:4002
                                               userInfo:@{
                                                          NSLocalizedDescriptionKey : @"Error parsing data",
                                                          NSUnderlyingErrorKey : parsingError,
                                                          }];
                }

            }

        } else {
            newError = [NSError errorWithDomain:[NSBundle mainBundle].bundleIdentifier
                                           code:4001
                                       userInfo:@{
                                                  NSLocalizedDescriptionKey : @"Error fetching data",
                                                  NSUnderlyingErrorKey : error,
                                                  }];
        }
        if (completion) {
            completion(newResponse, newError);
        }
    };

    NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:url
                                                 completionHandler:completionHandler];
    [dataTask resume];
}

@end
