//
//  YXFaceRecognitionBaseModel.m
//  YXAccordingDemo
//
//  Created by ios on 2021/7/21.
//

#import "YXFaceRecognitionBaseModel.h"
//#import "NSString+YXCategory.h"

@implementation YXFaceRecognitionBaseModel

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    
    if (self) {
        _faceNum = [[dic objectForKey:@"face_num"] integerValue];
        _faceList = [YXFaceRecognitionMsgModel arrayOfModelsFromDictionaries:[dic objectForKey:@"face_list"]];
        _jsonStr = [NSString yxConvertToJsonDataByData:dic];
    }
    return self;
}

@end
