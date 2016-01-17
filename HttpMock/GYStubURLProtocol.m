//
//  GYNSURLProtocol.m
//  GYNetwork
//
//  Created by hypo on 16/1/13.
//  Copyright © 2016年 hypoyao. All rights reserved.
//

#import "GYStubURLProtocol.h"
#import "GYHttpMock.h"
#import "GYStubResponse.h"

@interface NSHTTPURLResponse(UndocumentedInitializer)
- (id)initWithURL:(NSURL*)URL statusCode:(NSInteger)statusCode headerFields:(NSDictionary*)headerFields requestTime:(double)requestTime;
@end

@implementation GYStubURLProtocol
+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    GYStubResponse* stubbedResponse = [[GYHttpMock sharedInstance] responseForRequest:(id<GYHTTPRequest>)request];
    if (stubbedResponse) {
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
    
    GYStubResponse* stubbedResponse = [[GYHttpMock sharedInstance] responseForRequest:(id<GYHTTPRequest>)request];
    
    [[GYHttpMock sharedInstance] stop];
    
    //    if (!stubbedResponse) {
    //        NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    //        [NSURLConnection sendAsynchronousRequest:request
    //                                           queue:queue
    //                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
    //                                   if (error) {
    //                                       NSLog(@"Httperror:%@%ld", error.localizedDescription,error.code);
    //                                       [client URLProtocol:self didFailWithError:[NSError errorWithDomain:NSCocoaErrorDomain code:NSUserCancelledError userInfo:nil]];
    //                                   }else{
    //
    //                                       [client URLProtocol:self didReceiveResponse:response
    //                                        cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    //                                       [client URLProtocol:self didLoadData:data];
    //                                       [client URLProtocolDidFinishLoading:self];
    //                                   }
    //                               }];
    //        [[GYHttpMock sharedInstance] start];
    //        return;
    //    }
    
    if (stubbedResponse.shouldFail) {
        [client URLProtocol:self didFailWithError:stubbedResponse.error];
    }
    else if (stubbedResponse.isUpdatePartResponseBody) {
        
        NSOperationQueue *queue = [[NSOperationQueue alloc]init];
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:queue
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                                   if (error) {
                                       NSLog(@"Httperror:%@%ld", error.localizedDescription,error.code);
                                       [client URLProtocol:self didFailWithError:[NSError errorWithDomain:NSCocoaErrorDomain code:NSUserCancelledError userInfo:nil]];
                                   }else{
                                       
                                       id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                                       NSDictionary *result = json;
                                       if (!error && json) {
                                           NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:stubbedResponse.body options:NSJSONReadingMutableContainers error:nil];
                                           
                                           result = [self addEntriesFromDictionary:dict to:result];
                                       }
                                       
                                       NSData *combinedData = [NSJSONSerialization dataWithJSONObject:result options:NSJSONWritingPrettyPrinted error:nil];
                                       
                                       
                                       [client URLProtocol:self didReceiveResponse:response
                                        cacheStoragePolicy:NSURLCacheStorageNotAllowed];
                                       [client URLProtocol:self didLoadData:combinedData];
                                       [client URLProtocolDidFinishLoading:self];
                                   }
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

- (NSDictionary *)addEntriesFromDictionary:(NSDictionary *)dict to:(NSDictionary *)targetDict
{
    NSMutableDictionary *resultDict = [NSMutableDictionary dictionaryWithDictionary:targetDict];
    for (NSString *key in dict) {
        if (!targetDict[key] || [dict[key] isKindOfClass:[NSString class]]) {
            [resultDict addEntriesFromDictionary:dict];
        } else if ([dict[key] isKindOfClass:[NSArray class]]) {
            NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:targetDict[key]];
            [mutableArray addObjectsFromArray:dict[key]];
            [resultDict setObject:mutableArray forKey:key];
        } else if ([dict[key] isKindOfClass:[NSDictionary class]]) {
            [self addEntriesFromDictionary:dict[key] to:targetDict[key]];
        }
    }
    return resultDict;
}

@end
