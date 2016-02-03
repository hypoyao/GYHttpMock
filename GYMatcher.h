//
//  GYMatcher.h
//  GYNetwork
//
//  Created by hypo on 16/1/13.
//  Copyright © 2016年 hypoyao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, GYMatcherType) {
    GYMatcherTypeString,
    GYMatcherTypeData,
    GYMatcherTypeRegex
};

@interface GYMatcher : NSObject

@property (nonatomic, assign) GYMatcherType matchType;
@property (nonatomic, copy, readonly) NSString *string;
@property (nonatomic, strong, readonly) NSData *data;
@property (nonatomic, strong, readonly) NSRegularExpression *regex;

+ (instancetype)GYMatcherWithObject:(id)object;

- (instancetype)initWithString:(NSString *)string;
- (instancetype)initWithData:(NSData *)data;
- (instancetype)initWithRegex:(NSRegularExpression *)regex;

- (BOOL)match:(GYMatcher *)matcher;
@end
