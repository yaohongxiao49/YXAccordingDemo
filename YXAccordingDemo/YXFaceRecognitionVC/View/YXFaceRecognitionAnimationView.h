//
//  YXFaceRecognitionAnimationView.h
//  YXAccordingDemo
//
//  Created by ios on 2021/7/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/** 动画完结回调 */
typedef void(^YXFaceRecognitionAVBlock)(BOOL boolFinished);

@interface YXFaceRecognitionAnimationView : UIView

@property (nonatomic, copy) YXFaceRecognitionAVBlock yxFaceRecognitionAVBlock;
@property (nonatomic, assign) BOOL boolEndAnimation;

/** 开启动画 */
- (void)begainAnimation;
- (void)begainNewAnimation;

@end

NS_ASSUME_NONNULL_END
