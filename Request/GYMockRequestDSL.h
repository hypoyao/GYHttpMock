//
//  GYMockRequestDSL.h
//  GYNetwork
//
//  Created by hypo on 16/1/13.
//  Copyright © 2016年 hypoyao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GYMockRequestDSL;
@class GYMockResponseDSL;
@class GYMockRequest;

@protocol GYHTTPBody;

typedef GYMockRequestDSL *(^WithHeaderMethod)(NSString *, NSString *);
typedef GYMockRequestDSL *(^WithHeadersMethod)(NSDictionary *);
typedef GYMockRequestDSL *(^isUpdatePartResponseBody)(BOOL);
typedef GYMockRequestDSL *(^AndBodyMethod)(id);
typedef GYMockResponseDSL *(^AndReturnMethod)(NSInteger);
typedef void (^AndFailWithErrorMethod)(NSError *error);

@interface GYMockRequestDSL : NSObject
- (id)initWithRequest:(GYMockRequest *)request;

@property (nonatomic, strong) GYMockRequest *request;

@property (nonatomic, strong, readonly) WithHeaderMethod withHeader;
@property (nonatomic, strong, readonly) WithHeadersMethod withHeaders;
@property (nonatomic, strong, readonly) isUpdatePartResponseBody isUpdatePartResponseBody;
@property (nonatomic, strong, readonly) AndBodyMethod withBody;
@property (nonatomic, strong, readonly) AndReturnMethod andReturn;
@property (nonatomic, strong, readonly) AndFailWithErrorMethod andFailWithError;


@end

#ifdef __cplusplus
extern "C" {
#endif
    
    GYMockRequestDSL * mockRequest(NSString *method, id url);
    
#ifdef __cplusplus
}
#endif