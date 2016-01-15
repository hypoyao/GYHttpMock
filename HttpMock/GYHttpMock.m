//
//  GYHttpMock.m
//  GYNetwork
//
//  Created by hypo on 16/1/13.
//  Copyright © 2016年 hypoyao. All rights reserved.
//

#import "GYHttpMock.h"
#import "GYNSURLHook.h"
#import "GYNSURLSessionHook.h"
#import "GYHttpClientHook.h"

static GYHttpMock *sharedInstance = nil;

@implementation GYHttpMock

+ (GYHttpMock *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        _stubbedRequests = [NSMutableArray array];
        _hooks = [NSMutableArray array];
        [self registerHook:[[GYNSURLHook alloc] init]];
        if (NSClassFromString(@"NSURLSession") != nil) {
            [self registerHook:[[GYNSURLSessionHook alloc] init]];
        }
    }
    return self;
}

- (void)start
{
    if (!self.isStarted){
        [self loadHooks];
        self.started = YES;
    }
}

- (void)stop
{
    [self unloadHooks];
    self.started = NO;
}
- (void)clearStubs
{
    [_stubbedRequests removeAllObjects];
}

- (void)addStubbedRequest:(GYStubRequest *)request {
    [self.stubbedRequests addObject:request];
}

- (void)registerHook:(GYHttpClientHook *)hook
{
    if (![self hookWasRegistered:hook]) {
        [[self hooks] addObject:hook];
    }
}

- (BOOL)hookWasRegistered:(GYHttpClientHook *)aHook {
    for (GYHttpClientHook *hook in self.hooks) {
        if ([hook isMemberOfClass: [aHook class]]) {
            return YES;
        }
    }
    return NO;
}

- (GYStubResponse *)responseForRequest:(id<GYHTTPRequest>)request
{
    NSArray* requests = [GYHttpMock sharedInstance].stubbedRequests;
    
    for(GYStubRequest *someStubbedRequest in requests) {
        if ([someStubbedRequest matchesRequest:request]) {
            someStubbedRequest.response.isUpdatePartResponseBody = someStubbedRequest.isUpdatePartResponseBody;
            return someStubbedRequest.response;
        }
    }
    
    return nil;
}

- (void)loadHooks {
    for (GYHttpClientHook *hook in self.hooks) {
        [hook load];
    }
}

- (void)unloadHooks {
    for (GYHttpClientHook *hook in self.hooks) {
        [hook unload];
    }
}
@end
