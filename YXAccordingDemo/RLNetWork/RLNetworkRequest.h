
#import <UIKit/UIKit.h>

/** 请求成功的正确码 */
#define kRequestSuccessCode 2000

/** 请求结果block */
typedef void (^YCRequestBlock) (NSDictionary *dic, BOOL isSuccess);
/** 结果返回block */
typedef void (^YXRequestFinishBlock) (id result, BOOL boolSuccess);

/** 请求成功block */
typedef void (^requestSuccessBlock)(id responseObj);
/** 请求失败block */
typedef void (^requestFailureBlock) (NSError *error);
/** 网络异常block */
typedef void (^requestNetworkUseBlock) (id networkObj);

@interface RLNetworkRequest : NSObject

/** POST请求 */
+ (void)postWithURL:(NSString *)url params:(id)params showText:(NSString *)text showSuccess:(BOOL)isShowSuccess showError:(BOOL)isShowError block:(YCRequestBlock)block;

+ (void)postRequest:(NSString *)url params:(NSDictionary *)params forHTTPHeaderField:(id)headerField success:(requestSuccessBlock)successHandler failure:(requestFailureBlock)failureHandler netWork:(requestNetworkUseBlock)netWorkHandler;

/** 单张上传图片请求 */
+ (void)uploadImagesUrl:(NSString *)url paramDic:(NSDictionary *)paramDic image:(UIImage *)image name:(NSString *)name forHTTPHeaderField:(id)headerField success:(requestSuccessBlock)successHandler failure:(requestFailureBlock)failureHandler netWork:(requestNetworkUseBlock)netWorkHandler;

/** 多张上传图片请求 */
+ (void)uploadImages:(NSString *)url params:(NSDictionary *)params imageArr:(NSArray *)imageArr name:(NSString *)name forHTTPHeaderField:(id)headerField success:(requestSuccessBlock)successHandler failure:(requestFailureBlock)failureHandler netWork:(requestNetworkUseBlock)netWorkHandler;

/** 上传录音请求 */
+ (void)uploadMusicUrl:(NSString *)url paramDic:(NSDictionary *)paramDic file:(NSURL *)fileUrl name:(NSString *)name forHTTPHeaderField:(id)headerField success:(requestSuccessBlock)successHandler failure:(requestFailureBlock)failureHandler netWork:(requestNetworkUseBlock)netWorkHandler;

/** 上传视频请求 */
+ (void)uploadVideoUrl:(NSString *)url paramDic:(NSDictionary *)paramDic file:(NSURL *)fileUrl name:(NSString *)name forHTTPHeaderField:(id)headerField success:(requestSuccessBlock)successHandler failure:(requestFailureBlock)failureHandler netWork:(requestNetworkUseBlock)netWorkHandler;

@end
