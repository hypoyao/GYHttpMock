//
//  NSString+mock.m
//  GYNetwork
//
//  Created by hypo on 16/1/13.
//  Copyright © 2016年 hypoyao. All rights reserved.
//

#import "NSString+mock.h"

@implementation NSString(mock)

- (NSRegularExpression *)regex {
    NSError *error = nil;
    NSRegularExpression *regex =  [[NSRegularExpression alloc] initWithPattern:self options:0 error:&error];
    if (error) {
        [NSException raise:NSInvalidArgumentException format:@"Invalid regex pattern: %@\nError: %@", self, error];
    }
    return regex;
}

- (NSData *)data {
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}

@end
