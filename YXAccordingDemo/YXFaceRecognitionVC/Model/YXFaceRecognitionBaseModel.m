//
//  YXFaceRecognitionBaseModel.m
//  YXAccordingDemo
//
//  Created by ios on 2021/7/21.
//

#import "YXFaceRecognitionBaseModel.h"

@implementation YXFaceRecognitionBaseModel

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    
    if (self) {
        _faceNum = [[dic objectForKey:@"face_num"] integerValue];
        _faceList = [YXFaceRecognitionMsgModel arrayOfModelsFromDictionaries:[dic objectForKey:@"face_list"]];
    }
    return self;
}

@end
