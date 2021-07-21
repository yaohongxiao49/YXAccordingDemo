
#import "RLNetworkRequest.h"
#import "YXFaceRecognitionBaseModel.h"

@interface RLHttpRequest : RLNetworkRequest

#pragma mark - 单例
+ (RLHttpRequest *)sharedHttpRequest;

/** 人像分割 */
+ (void)getBaiduAIAPIFaceFromImg:(UIImage *)img showText:(NSString *)showText showSuccess:(BOOL)isShowSuccess showError:(BOOL)isShowError finishBlock:(YXRequestFinishBlock)finishBlock;

/** 皮肤分析 */
+ (void)getBaiduAIAPISkinAnalysisFromImg:(UIImage *)img showText:(NSString *)showText showSuccess:(BOOL)isShowSuccess showError:(BOOL)isShowError finishBlock:(YXRequestFinishBlock)finishBlock;

@end
