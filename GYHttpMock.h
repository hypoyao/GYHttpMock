//
//  GYHttpMock.h
//  GYNetwork
//
//  Created by hypo on 16/1/13.
//  Copyright © 2016年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GYStubRequest.h"
#import "GYHttpClientHook.h"
#import "GYStubResponse.h"

@interface GYHttpMock : NSObject

@property (nonatomic, strong) NSMutableArray *stubbedRequests;
@property (nonatomic, strong) NSMutableArray *hooks;
@property (nonatomic, assign, getter = isStarted) BOOL started;

+ (GYHttpMock *)sharedInstance;

- (void)start;
- (void)stop;
- (void)clearStubs;

- (GYStubResponse *)responseForRequest:(id<GYHTTPRequest>)request;
- (void)addStubbedRequest:(GYStubRequest *)request;
@end
