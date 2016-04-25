//
//  JEDFeedFetcher.h
//  SimpleTumblrClient
//
//  Created by Justyna Dolińska on 25/04/16.
//  Copyright © 2016 Justyna Dolińska. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JEDFeedResponse.h"


@interface JEDFeedFetcher : NSObject

- (instancetype)initWithSession:(NSURLSession *)session;
- (void)fetchFeedForUsername:(NSString *)username
              withCompletion:(void (^)(JEDFeedResponse *response, NSError *error))completion;

@end
