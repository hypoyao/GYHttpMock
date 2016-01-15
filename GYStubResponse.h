//
//  GYStubResponse.h
//  GYNetwork
//
//  Created by hypo on 16/1/13.
//  Copyright © 2016年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYStubResponse : NSObject

@property (nonatomic, assign) NSInteger statusCode;
@property (nonatomic, strong) NSData *body;
@property (nonatomic, copy) NSDictionary *headers;

@property (nonatomic, assign) BOOL shouldFail;
@property (nonatomic, strong) NSError *error;

@property (nonatomic, assign) BOOL isUpdatePartResponseBody;

- (id)initWithError:(NSError *)error;
- (id)initWithStatusCode:(NSInteger)statusCode;
- (id)initWithRawResponse:(NSData *)rawResponseData;
- (id)initDefaultResponse;
- (void)setHeader:(NSString *)header value:(NSString *)value;

@end
