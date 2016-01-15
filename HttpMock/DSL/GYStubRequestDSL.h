//
//  GYStubRequestDSL.h
//  GYNetwork
//
//  Created by hypo on 16/1/13.
//  Copyright © 2016年 hypoyao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GYStubRequestDSL;
@class GYStubResponseDSL;
@class GYStubRequest;

@protocol GYHTTPBody;

typedef GYStubRequestDSL *(^WithHeaderMethod)(NSString *, NSString *);
typedef GYStubRequestDSL *(^WithHeadersMethod)(NSDictionary *);
typedef GYStubRequestDSL *(^isUpdatePartResponseBody)(BOOL);
typedef GYStubRequestDSL *(^AndBodyMethod)(id);
typedef GYStubResponseDSL *(^AndReturnMethod)(NSInteger);
typedef GYStubResponseDSL *(^AndReturnRawResponseMethod)(NSData *rawResponseData);
typedef void (^AndFailWithErrorMethod)(NSError *error);

@interface GYStubRequestDSL : NSObject
- (id)initWithRequest:(GYStubRequest *)request;

@property (nonatomic, strong) GYStubRequest *request;

@property (nonatomic, strong, readonly) WithHeaderMethod withHeader;
@property (nonatomic, strong, readonly) WithHeadersMethod withHeaders;
@property (nonatomic, strong, readonly) isUpdatePartResponseBody isUpdatePartResponseBody;
@property (nonatomic, strong, readonly) AndBodyMethod withBody;
@property (nonatomic, strong, readonly) AndReturnMethod andReturn;
@property (nonatomic, strong, readonly) AndReturnRawResponseMethod andReturnRawResponse;
@property (nonatomic, strong, readonly) AndFailWithErrorMethod andFailWithError;


@end

#ifdef __cplusplus
extern "C" {
#endif
    
    GYStubRequestDSL * stubRequest(NSString *method, id url);
    
#ifdef __cplusplus
}
#endif