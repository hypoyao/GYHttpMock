//
//  GYMockResponse.m
//  GYNetwork
//
//  Created by hypo on 16/1/13.
//  Copyright © 2016年 hypoyao. All rights reserved.
//

#import "GYMockResponse.h"

@implementation GYMockResponse
#pragma Initializers
- (id)initDefaultResponse {
    self = [super init];
    if (self) {
        self.shouldFail = NO;
        
        self.statusCode = 200;
        self.headers = [NSMutableDictionary dictionary];
        [self.headers addEntriesFromDictionary:@{@"Content-Type":@"application/json;charset=utf-8"}];
        self.body = [@"" dataUsingEncoding:NSUTF8StringEncoding];
    }
    return self;
}


- (id)initWithError:(NSError *)error {
    self = [super init];
    if (self) {
        self.shouldFail = YES;
        self.error = error;
    }
    return self;
}

-(id)initWithStatusCode:(NSInteger)statusCode {
    self  = [self initDefaultResponse];
    if (self) {
        self.statusCode = statusCode;
    }
    return self;
}

- (void)setHeader:(NSString *)header value:(NSString *)value {
    [self.headers setValue:value forKey:header];
}


- (NSString *)description {
    return [NSString stringWithFormat:@"StubRequest:\nStatus Code: %ld\nHeaders: %@\nBody: %@",
            (long)self.statusCode,
            self.headers,
            self.body];
}
@end
