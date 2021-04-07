
#import "RLNetworkRequest.h"

@interface RLHttpRequest : RLNetworkRequest

#pragma mark - 单例
+ (RLHttpRequest *)sharedHttpRequest;

+ (void)getBaiduAIAPIFaceFromImg:(UIImage *)img showText:(NSString *)showText showSuccess:(BOOL)isShowSuccess showError:(BOOL)isShowError finishBlock:(YXRequestFinishBlock)finishBlock;

@end
