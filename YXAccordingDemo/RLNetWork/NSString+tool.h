//
//  NSString+tool.h
//  categoryTest
//
//  Created by 王文 on 16/6/22.
//  Copyright © 2016年 volientDuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (tool)

- (NSString *)URLEncodedString;
- (NSString *)URLDecodedString;
+ (NSString *)urlEncodeStr:(NSString *)input;

@end
