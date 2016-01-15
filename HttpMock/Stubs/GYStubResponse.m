//
//  GYStubResponse.m
//  GYNetwork
//
//  Created by hypo on 16/1/13.
//  Copyright © 2016年 hypoyao. All rights reserved.
//

#import "GYStubResponse.h"

@implementation GYStubResponse
#pragma Initializers
- (id)initDefaultResponse {
    self = [super init];
    if (self) {
        self.shouldFail = NO;
        
        self.statusCode = 200;
        self.headers = [NSMutableDictionary dictionary];
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
    self = [super init];
    if (self) {
        self.shouldFail = NO;
        self.statusCode = statusCode;
        self.headers = [NSMutableDictionary dictionary];
        self.body = [@"" dataUsingEncoding:NSUTF8StringEncoding];
    }
    return self;
}

- (id)initWithRawResponse:(NSData *)rawResponseData {
    self = [self initDefaultResponse];
    if (self) {
        CFHTTPMessageRef httpMessage = CFHTTPMessageCreateEmpty(kCFAllocatorDefault, FALSE);
        if (httpMessage) {
            CFHTTPMessageAppendBytes(httpMessage, [rawResponseData bytes], [rawResponseData length]);
            
            self.body = rawResponseData; // By default
            
            if (CFHTTPMessageIsHeaderComplete(httpMessage)) {
                self.statusCode = (NSInteger)CFHTTPMessageGetResponseStatusCode(httpMessage);
                self.headers = [NSMutableDictionary dictionaryWithDictionary:(__bridge_transfer NSDictionary *)CFHTTPMessageCopyAllHeaderFields(httpMessage)];
                self.body = (__bridge_transfer NSData *)CFHTTPMessageCopyBody(httpMessage);
            }
            CFRelease(httpMessage);
        }
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
