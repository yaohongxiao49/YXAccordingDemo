//
//  NSString+tool.m
//  categoryTest
//
//  Created by 王文 on 16/6/22.
//  Copyright © 2016年 volientDuan. All rights reserved.
//

#import "NSString+tool.h"

@implementation NSString (tool)

- (NSString *)URLEncodedString {
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}
- (NSString *)URLDecodedString {
    return [self stringByRemovingPercentEncoding];
}
+ (NSString *)urlEncodeStr:(NSString *)input {
    
    return [input stringByAddingPercentEncodingWithAllowedCharacters:[[NSCharacterSet characterSetWithCharactersInString:@"?!@#$^&%*+,:;='\"`<>()[]{}/\\| "] invertedSet]];
}

@end
