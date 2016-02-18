//
//  GYMockRequestDSL.m
//  GYNetwork
//
//  Created by hypo on 16/1/13.
//  Copyright © 2016年 hypoyao. All rights reserved.
//

#import "GYMockRequestDSL.h"
#import "GYMockRequest.h"
#import "GYMockResponse.h"
#import "GYMatcher.h"
#import "GYMockResponseDSL.h"
#import "GYHttpMock.h"

@implementation GYMockRequestDSL

- (id)initWithRequest:(GYMockRequest *)request {
    self = [super init];
    if (self) {
        _request = request;
    }
    return self;
}
- (WithHeadersMethod)withHeaders {
    return ^(NSDictionary *headers) {
        for (NSString *header in headers) {
            NSString *value = [headers objectForKey:header];
            [self.request setHeader:header value:value];
        }
        return self;
    };
}

- (WithHeaderMethod)withHeader {
    return ^(NSString * header, NSString * value) {
        [self.request setHeader:header value:value];
        return self;
    };
}

- (isUpdatePartResponseBody)isUpdatePartResponseBody {
    return ^(BOOL isUpdate) {
        self.request.isUpdatePartResponseBody = isUpdate;
        return self;
    };
}

- (AndBodyMethod)withBody {
    return ^(id body) {
        self.request.body = [GYMatcher GYMatcherWithObject:body];
        return self;
    };
}

- (AndReturnMethod)andReturn {
    return ^(NSInteger statusCode) {
        self.request.response = [[GYMockResponse alloc] initWithStatusCode:statusCode];
        GYMockResponseDSL *responseDSL = [[GYMockResponseDSL alloc] initWithResponse:self.request.response];
        return responseDSL;
    };
}


- (AndFailWithErrorMethod)andFailWithError {
    return ^(NSError *error) {
        self.request.response = [[GYMockResponse alloc] initWithError:error];
    };
}



@end

GYMockRequestDSL *mockRequest(NSString *method, id url) {
    GYMockRequest *request = [[GYMockRequest alloc] initWithMethod:method urlMatcher:[GYMatcher GYMatcherWithObject:url]];
    GYMockRequestDSL *dsl = [[GYMockRequestDSL alloc] initWithRequest:request];
    [[GYHttpMock sharedInstance] addMockRequest:request];
    [[GYHttpMock sharedInstance] startMock];
    return dsl;
}