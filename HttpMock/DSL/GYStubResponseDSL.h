//
//  GYStubResponseDSL.h
//  GYNetwork
//
//  Created by hypo on 16/1/13.
//  Copyright © 2016年 hypoyao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GYStubResponse;
@class GYStubResponseDSL;

@protocol GYHTTPBody;

typedef GYStubResponseDSL *(^ResponseWithBodyMethod)(id);
typedef GYStubResponseDSL *(^ResponseWithHeaderMethod)(NSString *, NSString *);
typedef GYStubResponseDSL *(^ResponseWithHeadersMethod)(NSDictionary *);

@interface GYStubResponseDSL : NSObject
- (id)initWithResponse:(GYStubResponse *)response;

@property (nonatomic, strong) GYStubResponse *response;

@property (nonatomic, strong, readonly) ResponseWithHeaderMethod withHeader;
@property (nonatomic, strong, readonly) ResponseWithHeadersMethod withHeaders;
@property (nonatomic, strong, readonly) ResponseWithBodyMethod withBody;

@end