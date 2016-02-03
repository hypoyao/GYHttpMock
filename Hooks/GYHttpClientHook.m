//
//  GYHttpClientHook.m
//  GYNetwork
//
//  Created by hypo on 16/1/13.
//  Copyright © 2016年 hypoyao. All rights reserved.
//

#import "GYHttpClientHook.h"

@implementation GYHttpClientHook

- (void)load {
    [NSException raise:NSInternalInconsistencyException
                format:@"Method '%@' not implemented. Subclass '%@' and override it", NSStringFromSelector(_cmd), NSStringFromClass([self class])];
}

- (void)unload {
    [NSException raise:NSInternalInconsistencyException
                format:@"Method '%@' not implemented. Subclass '%@' and override it", NSStringFromSelector(_cmd), NSStringFromClass([self class])];
}

@end
