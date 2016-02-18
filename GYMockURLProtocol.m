//
//  GYNSURLProtocol.m
//  GYNetwork
//
//  Created by hypo on 16/1/13.
//  Copyright © 2016年 hypoyao. All rights reserved.
//

#import "GYMockURLProtocol.h"
#import "GYHttpMock.h"
#import "GYMockResponse.h"

@interface NSHTTPURLResponse(UndocumentedInitializer)
- (id)initWithURL:(NSURL*)URL statusCode:(NSInteger)statusCode headerFields:(NSDictionary*)headerFields requestTime:(double)requestTime;
@end

@implementation GYMockURLProtocol
+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    GYMockResponse* stubbedResponse = [[GYHttpMock sharedInstance] responseForRequest:(id<GYHTTPRequest>)request];
    if (stubbedResponse && !stubbedResponse.shouldNotMockAgain) {
        return YES;
    }
    return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}
+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b {
    return NO;
}

- (void)startLoading {
    NSURLRequest* request = [self request];
    id<NSURLProtocolClient> client = [self client];
    
    GYMockResponse* stubbedResponse = [[GYHttpMock sharedInstance] responseForRequest:(id<GYHTTPRequest>)request];
    
    if (stubbedResponse.shouldFail) {
        [client URLProtocol:self didFailWithError:stubbedResponse.error];
    }
    else if (stubbedResponse.isUpdatePartResponseBody) {
        stubbedResponse.shouldNotMockAgain = YES;
        NSOperationQueue *queue = [[NSOperationQueue alloc]init];
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:queue
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                                   if (error) {
                                       NSLog(@"Httperror:%@%@", error.localizedDescription,@(error.code));
                                       [client URLProtocol:self didFailWithError:[NSError errorWithDomain:NSCocoaErrorDomain code:NSUserCancelledError userInfo:nil]];
                                   }else{
                                       
                                       id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                                       NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:json];
                                       if (!error && json) {
                                           NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:stubbedResponse.body options:NSJSONReadingMutableContainers error:nil];
                                           
                                           [self addEntriesFromDictionary:dict to:result];
                                       }
                                       
                                       NSData *combinedData = [NSJSONSerialization dataWithJSONObject:result options:NSJSONWritingPrettyPrinted error:nil];
                                       
                                       
                                       [client URLProtocol:self didReceiveResponse:response
                                        cacheStoragePolicy:NSURLCacheStorageNotAllowed];
                                       [client URLProtocol:self didLoadData:combinedData];
                                       [client URLProtocolDidFinishLoading:self];
                                   }
                                   stubbedResponse.shouldNotMockAgain = NO;
                               }];
        
    }
    else {
        NSHTTPURLResponse* urlResponse = [[NSHTTPURLResponse alloc] initWithURL:request.URL statusCode:stubbedResponse.statusCode HTTPVersion:@"1.1" headerFields:stubbedResponse.headers];
        
        if (stubbedResponse.statusCode < 300 || stubbedResponse.statusCode > 399
            || stubbedResponse.statusCode == 304 || stubbedResponse.statusCode == 305 ) {
            NSData *body = stubbedResponse.body;
            
            [client URLProtocol:self didReceiveResponse:urlResponse
             cacheStoragePolicy:NSURLCacheStorageNotAllowed];
            [client URLProtocol:self didLoadData:body];
            [client URLProtocolDidFinishLoading:self];
        } else {
            NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            [cookieStorage setCookies:[NSHTTPCookie cookiesWithResponseHeaderFields:stubbedResponse.headers forURL:request.URL]
                               forURL:request.URL mainDocumentURL:request.URL];
            
            NSURL *newURL = [NSURL URLWithString:[stubbedResponse.headers objectForKey:@"Location"] relativeToURL:request.URL];
            NSMutableURLRequest *redirectRequest = [NSMutableURLRequest requestWithURL:newURL];
            
            [redirectRequest setAllHTTPHeaderFields:[NSHTTPCookie requestHeaderFieldsWithCookies:[cookieStorage cookiesForURL:newURL]]];
            
            [client URLProtocol:self
         wasRedirectedToRequest:redirectRequest
               redirectResponse:urlResponse];
            // According to: https://developer.apple.com/library/ios/samplecode/CustomHTTPProtocol/Listings/CustomHTTPProtocol_Core_Code_CustomHTTPProtocol_m.html
            // needs to abort the original request
            [client URLProtocol:self didFailWithError:[NSError errorWithDomain:NSCocoaErrorDomain code:NSUserCancelledError userInfo:nil]];
            
        }
    }
}

- (void)stopLoading {
}

- (void)addEntriesFromDictionary:(NSDictionary *)dict to:(NSMutableDictionary *)targetDict
{
    for (NSString *key in dict) {
        if (!targetDict[key] || [dict[key] isKindOfClass:[NSString class]]) {
            [targetDict addEntriesFromDictionary:dict];
        } else if ([dict[key] isKindOfClass:[NSArray class]]) {
            NSMutableArray *mutableArray = [NSMutableArray array];
            for (NSDictionary *targetArrayDict in targetDict[key]) {
                NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:targetArrayDict];
                for (NSDictionary *arrayDict in dict[key]) {
                    [self addEntriesFromDictionary:arrayDict to:mutableDict];
                }
                [mutableArray addObject:mutableDict];
            }
            [targetDict setObject:mutableArray forKey:key];
        } else if ([dict[key] isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:targetDict[key]];
            [self addEntriesFromDictionary:dict[key] to:mutableDict];
            [targetDict setObject:mutableDict forKey:key];
        }
    }
}

@end
