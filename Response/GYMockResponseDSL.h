//
//  GYMockResponseDSL.h
//  GYNetwork
//
//  Created by hypo on 16/1/13.
//  Copyright © 2016年 hypoyao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GYMockResponse;
@class GYMockResponseDSL;

@protocol GYHTTPBody;

typedef GYMockResponseDSL *(^ResponseWithBodyMethod)(id);
typedef GYMockResponseDSL *(^ResponseWithHeaderMethod)(NSString *, NSString *);
typedef GYMockResponseDSL *(^ResponseWithHeadersMethod)(NSDictionary *);

@interface GYMockResponseDSL : NSObject
- (id)initWithResponse:(GYMockResponse *)response;

@property (nonatomic, strong) GYMockResponse *response;

@property (nonatomic, strong, readonly) ResponseWithHeaderMethod withHeader;
@property (nonatomic, strong, readonly) ResponseWithHeadersMethod withHeaders;
@property (nonatomic, strong, readonly) ResponseWithBodyMethod withBody;

@end