//
//  GYURLHook.m
//  GYNetwork
//
//  Created by hypo on 16/1/13.
//  Copyright © 2016年 hypoyao. All rights reserved.
//

#import "GYNSURLHook.h"
#import "GYStubURLProtocol.h"

@implementation GYNSURLHook

- (void)load {
    [NSURLProtocol registerClass:[GYStubURLProtocol class]];
}

- (void)unload {
    [NSURLProtocol unregisterClass:[GYStubURLProtocol class]];
}

@end
