//
//  GYStubRequestDSL.m
//  GYNetwork
//
//  Created by hypo on 16/1/13.
//  Copyright © 2016年 tencent. All rights reserved.
//

#import "GYStubRequestDSL.h"
#import "GYStubRequest.h"
#import "GYStubResponse.h"
#import "GYMatcher.h"
#import "GYStubResponseDSL.h"
#import "GYHttpMock.h"

@implementation GYStubRequestDSL

- (id)initWithRequest:(GYStubRequest *)request {
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
    return ^(NSString *body) {
        self.request.body = [GYMatcher GYMatcherWithObject:body];
        return self;
    };
}

- (AndReturnMethod)andReturn {
    return ^(NSInteger statusCode) {
        self.request.response = [[GYStubResponse alloc] initWithStatusCode:statusCode];
        GYStubResponseDSL *responseDSL = [[GYStubResponseDSL alloc] initWithResponse:self.request.response];
        return responseDSL;
    };
}

- (AndReturnRawResponseMethod)andReturnRawResponse {
    return ^(NSData *rawResponseData) {
        self.request.response = [[GYStubResponse alloc] initWithRawResponse:rawResponseData];
        GYStubResponseDSL *responseDSL = [[GYStubResponseDSL alloc] initWithResponse:self.request.response];
        return responseDSL;
    };
}

- (AndFailWithErrorMethod)andFailWithError {
    return ^(NSError *error) {
        self.request.response = [[GYStubResponse alloc] initWithError:error];
    };
}



@end

GYStubRequestDSL * stubRequest(NSString *method, id url) {
    
    GYStubRequest *request = [[GYStubRequest alloc] initWithMethod:method urlMatcher:[GYMatcher GYMatcherWithObject:url]];
    GYStubRequestDSL *dsl = [[GYStubRequestDSL alloc] initWithRequest:request];
    [[GYHttpMock sharedInstance] addStubbedRequest:request];
    return dsl;
}