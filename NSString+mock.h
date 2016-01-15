//
//  NSString+mock.h
//  GYNetwork
//
//  Created by hypo on 16/1/13.
//  Copyright © 2016年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(mock)

- (NSRegularExpression *)regex;

- (NSData *)data;
@end
