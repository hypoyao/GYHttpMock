//
//  GYURLHook.m
//  GYNetwork
//
//  Created by hypo on 16/1/13.
//  Copyright © 2016年 hypoyao. All rights reserved.
//

#import "GYNSURLHook.h"
#import "GYMockURLProtocol.h"

@implementation GYNSURLHook

- (void)load {
    [NSURLProtocol registerClass:[GYMockURLProtocol class]];
}

- (void)unload {
    [NSURLProtocol unregisterClass:[GYMockURLProtocol class]];
}

@end
