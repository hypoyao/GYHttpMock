//
//  GYMatcher.m
//  GYNetwork
//
//  Created by hypo on 16/1/13.
//  Copyright © 2016年 hypoyao. All rights reserved.
//

#import "GYMatcher.h"

@implementation GYMatcher

+ (instancetype)GYMatcherWithObject:(id)object
{
    if ([object isKindOfClass:[NSString class]]) {
        return [[GYMatcher alloc] initWithString:object];
    } else if ([object isKindOfClass:[NSData class]]) {
        return [[GYMatcher alloc] initWithData:object];
    } else if ([object isKindOfClass:[NSRegularExpression class]]) {
        return [[GYMatcher alloc] initWithRegex:object];
    } else {
        return nil;
    }
}

- (instancetype)initWithString:(NSString *)string
{
    if (self = [super init]) {
        _string = string;
        _matchType = GYMatcherTypeString;
    }
    return self;
}

- (instancetype)initWithData:(NSData *)data
{
    if (self = [super init]) {
        _data = data;
        _matchType = GYMatcherTypeData;
    }
    return self;
}
- (instancetype)initWithRegex:(NSRegularExpression *)regex
{
    if (self = [super init]) {
        _regex = regex;
        _matchType = GYMatcherTypeRegex;
    }
    return self;
}

- (BOOL)match:(GYMatcher *)matcher
{
    switch (self.matchType) {
        case GYMatcherTypeString:
            return [_string isEqualToString:matcher.string];
       case GYMatcherTypeData:
            return [_data isEqual:matcher.data];
        case GYMatcherTypeRegex:
            return [_regex numberOfMatchesInString:matcher.string options:0 range:NSMakeRange(0, matcher.string.length)] > 0;
        default:
            return NO;
    }
}

@end
