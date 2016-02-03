//
//  NSURLRequest+GYURLRequestProtocol.m
//  GYNetwork
//
//  Created by hypo on 16/1/13.
//  Copyright © 2016年 hypoyao. All rights reserved.
//

#import "NSURLRequest+GYURLRequestProtocol.h"

@implementation NSURLRequest (GYURLRequestProtocol)

- (NSURL*)url {
    return self.URL;
}

- (NSString *)method {
    return self.HTTPMethod;
}

- (NSDictionary *)headers {
    return self.allHTTPHeaderFields;
}

- (NSData *)body {
    if (self.HTTPBodyStream) {
        NSInputStream *stream = self.HTTPBodyStream;
        NSMutableData *data = [NSMutableData data];
        [stream open];
        size_t bufferSize = 4096;
        uint8_t *buffer = malloc(bufferSize);
        if (buffer == NULL) {
            [NSException raise:@"MallocFailure" format:@"Could not allocate %zu bytes to read HTTPBodyStream", bufferSize];
        }
        while ([stream hasBytesAvailable]) {
            NSInteger bytesRead = [stream read:buffer maxLength:bufferSize];
            if (bytesRead > 0) {
                NSData *readData = [NSData dataWithBytes:buffer length:bytesRead];
                [data appendData:readData];
            } else if (bytesRead < 0) {
                [NSException raise:@"StreamReadError" format:@"An error occurred while reading HTTPBodyStream (%ld)", (long)bytesRead];
            } else if (bytesRead == 0) {
                break;
            }
        }
        free(buffer);
        [stream close];
        
        return data;
    }
    
    return self.HTTPBody;
}

@end
