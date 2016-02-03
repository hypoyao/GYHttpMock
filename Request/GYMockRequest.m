//
//  GYSubRequest.m
//  GYNetwork
//
//  Created by hypo on 16/1/13.
//  Copyright © 2016年 hypoyao. All rights reserved.
//

#import "GYMockRequest.h"
#import "GYMatcher.h"
#import "GYMockResponse.h"

@implementation GYMockRequest

- (instancetype)initWithMethod:(NSString *)method url:(NSString *)url {
    return [self initWithMethod:method urlMatcher:[[GYMatcher alloc] initWithString:url]];
}

- (instancetype)initWithMethod:(NSString *)method urlMatcher:(GYMatcher *)urlMatcher; {
    self = [super init];
    if (self) {
        self.method = method;
        self.urlMatcher = urlMatcher;
        self.headers = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)setHeader:(NSString *)header value:(NSString *)value {
    [self.headers setValue:value forKey:header];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"StubRequest:\nMethod: %@\nURL: %@\nHeaders: %@\nBody: %@\nResponse: %@",
            self.method,
            self.urlMatcher,
            self.headers,
            self.body,
            self.response];
}

- (GYMockResponse *)response {
    if (!_response) {
        _response = [[GYMockResponse alloc] initDefaultResponse];
    }
    return _response;
}

- (BOOL)matchesRequest:(id<GYHTTPRequest>)request {
    if ([self matchesMethod:request]
        && [self matchesURL:request]
        && [self matchesHeaders:request]
        && [self matchesBody:request]
        ) {
        return YES;
    }
    return NO;
}

- (BOOL)matchesMethod:(id<GYHTTPRequest>)request {
    if (!self.method || [self.method isEqualToString:request.method]) {
        return YES;
    }
    return NO;
}

- (BOOL)matchesURL:(id<GYHTTPRequest>)request {
    GYMatcher *matcher = [[GYMatcher alloc] initWithString:[request.url absoluteString]];
    return [self.urlMatcher match:matcher];
}

- (BOOL)matchesHeaders:(id<GYHTTPRequest>)request {
    for (NSString *header in self.headers) {
        if (![[request.headers objectForKey:header] isEqualToString:[self.headers objectForKey:header]]) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)matchesBody:(id<GYHTTPRequest>)request {
    NSData *reqBody = request.body;
    if (!reqBody) {
        return YES;
    }
    NSString *reqBodyString = [[NSString alloc] initWithData:reqBody encoding:NSUTF8StringEncoding];
    NSAssert(reqBodyString, @"request body is nil");
    
    GYMatcher *matcher = [[GYMatcher alloc] initWithString:reqBodyString];
    if (!self.body || [self.body match:matcher]) {
        return YES;
    }
    return NO;
}
@end
