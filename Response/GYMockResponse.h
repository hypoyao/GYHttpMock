//
//  GYMockResponse.h
//  GYNetwork
//
//  Created by hypo on 16/1/13.
//  Copyright © 2016年 hypoyao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYMockResponse : NSObject

@property (nonatomic, assign) NSInteger statusCode;
@property (nonatomic, strong) NSData *body;
@property (nonatomic, strong) NSMutableDictionary *headers;

@property (nonatomic, assign) BOOL shouldFail;
@property (nonatomic, strong) NSError *error;

@property (nonatomic, assign) BOOL isUpdatePartResponseBody;

@property (nonatomic, assign) BOOL shouldNotMockAgain;

- (id)initWithError:(NSError *)error;
- (id)initWithStatusCode:(NSInteger)statusCode;
- (id)initDefaultResponse;
- (void)setHeader:(NSString *)header value:(NSString *)value;

@end
