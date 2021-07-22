//
//  YXFaceRecognitionBaseModel.h
//  YXAccordingDemo
//
//  Created by ios on 2021/7/21.
//
/// 人像图片基础信息

#import <Foundation/Foundation.h>
#import "YXFaceRecognitionMsgModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXFaceRecognitionBaseModel : NSObject

/** 图片中的人脸数量 */
@property (nonatomic, assign) NSInteger faceNum;
/** 人脸信息列表 */
@property (nonatomic, copy) NSArray <YXFaceRecognitionMsgModel *>*faceList;
/** json字符串 */
@property (nonatomic, copy) NSString *jsonStr;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
