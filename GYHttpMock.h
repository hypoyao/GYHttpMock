//
//  GYHttpMock.h
//  GYNetwork
//
//  Created by hypo on 16/1/13.
//  Copyright © 2016年 hypoyao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GYMockRequest.h"
#import "GYHttpClientHook.h"
#import "GYMockResponse.h"

#import "GYMockRequestDSL.h"
#import "GYMockResponseDSL.h"
#import "NSString+mock.h"

@interface GYHttpMock : NSObject

@property (nonatomic, strong) NSMutableArray *stubbedRequests;
@property (nonatomic, strong) NSMutableArray *hooks;
@property (nonatomic, assign, getter = isStarted) BOOL started;

+ (GYHttpMock *)sharedInstance;

- (void)startMock;
- (void)stopMock;

- (GYMockResponse *)responseForRequest:(id<GYHTTPRequest>)request;
- (void)addMockRequest:(GYMockRequest *)request;
@end
