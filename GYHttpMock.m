//
//  GYHttpMock.m
//  GYNetwork
//
//  Created by hypo on 16/1/13.
//  Copyright © 2016年 hypoyao. All rights reserved.
//

#import "GYHttpMock.h"
#import "GYNSURLConnectionHook.h"
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
        [self registerHook:[[GYNSURLConnectionHook alloc] init]];
        if (NSClassFromString(@"NSURLSession") != nil) {
            [self registerHook:[[GYNSURLSessionHook alloc] init]];
        }
    }
    return self;
}

- (void)startMock
{
    if (!self.isStarted){
        [self loadHooks];
        self.started = YES;
    }
}

- (void)stopMock
{
    [self unloadHooks];
    self.started = NO;
    [self clearMocks];
}

- (void)clearMocks
{
    @synchronized(_stubbedRequests) {
        [_stubbedRequests removeAllObjects];
    }
}

- (void)addMockRequest:(GYMockRequest *)request {
    @synchronized(_stubbedRequests) {
        [self.stubbedRequests addObject:request];
    }
}

- (void)registerHook:(GYHttpClientHook *)hook
{
    if (![self hookWasRegistered:hook]) {
        @synchronized(_hooks) {
            [_hooks addObject:hook];
        }
    }
}

- (BOOL)hookWasRegistered:(GYHttpClientHook *)aHook {
    @synchronized(_hooks) {
        for (GYHttpClientHook *hook in _hooks) {
            if ([hook isMemberOfClass: [aHook class]]) {
                return YES;
            }
        }
        return NO;
    }
}

- (GYMockResponse *)responseForRequest:(id<GYHTTPRequest>)request
{
    @synchronized(_stubbedRequests) {
        
        for(GYMockRequest *someStubbedRequest in _stubbedRequests) {
            if ([someStubbedRequest matchesRequest:request]) {
                someStubbedRequest.response.isUpdatePartResponseBody = someStubbedRequest.isUpdatePartResponseBody;
                return someStubbedRequest.response;
            }
        }
        
        return nil;
    }
    
}

- (void)loadHooks {
    @synchronized(_hooks) {
        for (GYHttpClientHook *hook in _hooks) {
            [hook load];
        }
    }
}

- (void)unloadHooks {
    @synchronized(_hooks) {
        for (GYHttpClientHook *hook in _hooks) {
            [hook unload];
        }
    }
}
@end
