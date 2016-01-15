//
//  GYStubResponseDSL.m
//  GYNetwork
//
//  Created by hypo on 16/1/13.
//  Copyright © 2016年 hypoyao. All rights reserved.
//

#import "GYStubResponseDSL.h"
#import "GYStubResponse.h"
#import "NSString+mock.h"

@implementation GYStubResponseDSL

- (id)initWithResponse:(GYStubResponse *)response {
    self = [super init];
    if (self) {
        _response = response;
    }
    return self;
}
- (ResponseWithHeaderMethod)withHeader {
    return ^(NSString * header, NSString * value) {
        [self.response setHeader:header value:value];
        return self;
    };
}

- (ResponseWithHeadersMethod)withHeaders; {
    return ^(NSDictionary *headers) {
        for (NSString *header in headers) {
            NSString *value = [headers objectForKey:header];
            [self.response setHeader:header value:value];
        }
        return self;
    };
}

- (ResponseWithBodyMethod)withBody {
    return ^(NSString *body) {
        NSString *bodyString = body;
        
        if ([body hasSuffix:@".json"]) {
            NSString *name = [body substringToIndex:body.length-5];
            NSBundle *bundle = [NSBundle bundleForClass:[self class]];
            NSString *path = [bundle pathForResource:name ofType:@"json"];
            NSAssert(path.length, @"file:%@ not exist",body);
            bodyString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        }
        
        self.response.body = [bodyString data];
        return self;
    };
}

@end
