//
//  GYSubRequest.h
//  GYNetwork
//
//  Created by hypo on 16/1/13.
//  Copyright © 2016年 hypoyao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GYMockResponse;
@class GYMatcher;

@protocol GYHTTPRequest <NSObject>

@property (nonatomic, strong, readonly) NSURL *url;
@property (nonatomic, strong, readonly) NSString *method;
@property (nonatomic, strong, readonly) NSDictionary *headers;
@property (nonatomic, strong, readonly) NSData *body;

@end

@interface GYMockRequest : NSObject
@property (nonatomic, strong) NSString *method;
@property (nonatomic, strong) GYMatcher *urlMatcher;
@property (nonatomic, strong) NSDictionary *headers;
@property (nonatomic, strong, readwrite) GYMatcher *body;
@property (nonatomic, assign, readwrite) BOOL isUpdatePartResponseBody;

@property (nonatomic, strong) GYMockResponse *response;

- (instancetype)initWithMethod:(NSString *)method url:(NSString *)url;
- (instancetype)initWithMethod:(NSString *)method urlMatcher:(GYMatcher *)urlMatcher;

- (void)setHeader:(NSString *)header value:(NSString *)value;

- (BOOL)matchesRequest:(id<GYHTTPRequest>)request;
@end
