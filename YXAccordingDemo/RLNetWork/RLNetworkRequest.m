
#import "RLNetworkRequest.h"
#import "RLShareHTTPManager.h"

@implementation RLNetworkRequest

#pragma mark - POST请求
+ (void)postWithURL:(NSString *)url params:(id)params showText:(NSString *)text showSuccess:(BOOL)isShowSuccess showError:(BOOL)isShowError block:(YCRequestBlock)block {
    
    [self postRequest:url params:params forHTTPHeaderField:nil success:^(id responseObj) {
        
        NSDictionary *dic = responseObj;
        NSInteger code = [[dic objectForKey:@"code"] integerValue];
        if (code == kRequestSuccessCode) {
            if (block) {
                block(dic, YES);
            }
        }
        else {
            if (block) {
                block(dic, NO);
            }
        }
    }
    failure:^(NSError *error) {
        
        if (block) {
            block(nil, NO);
        }
    }
    netWork:nil];
}
+ (void)postRequest:(NSString *)url params:(NSDictionary *)params forHTTPHeaderField:(id)headerField success:(requestSuccessBlock)successHandler failure:(requestFailureBlock)failureHandler netWork:(requestNetworkUseBlock)netWorkHandler {
    
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"#%^{}\"[]|\\<> "].invertedSet];
    
    AFHTTPSessionManager *manager = [self httpSessionManagerWithHeaderField:headerField];
    [manager POST:url parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self parseErrorInfo:responseObject errorType:1 errorUrl:url successHandler:successHandler failureHandler:failureHandler];
    }
    failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self parseErrorInfo:error errorType:2 errorUrl:url successHandler:successHandler failureHandler:failureHandler];
    }];
}

#pragma mark - HTTP头字段
+ (AFHTTPSessionManager *)httpSessionManagerWithHeaderField:(id)headerField {
    
    AFHTTPSessionManager *manager = [RLShareHTTPManager shareManager];
    [manager.requestSerializer setValue:headerField[@"platform-id"] forHTTPHeaderField:@"platform-id"];
    [manager.requestSerializer setValue:headerField[@"device-type"] forHTTPHeaderField:@"device-type"];
    [manager.requestSerializer setValue:headerField[@"device-name"] forHTTPHeaderField:@"device-name"];
    [manager.requestSerializer setValue:headerField[@"device-info"] forHTTPHeaderField:@"device-info"];
    [manager.requestSerializer setValue:headerField[@"version"] forHTTPHeaderField:@"version"];
    [manager.requestSerializer setValue:headerField[@"system-version"] forHTTPHeaderField:@"system-version"];
    [manager.requestSerializer setValue:headerField[@"nonce-str"] forHTTPHeaderField:@"nonce-str"];
    [manager.requestSerializer setValue:headerField[@"timestamp"] forHTTPHeaderField:@"timestamp"];
    [manager.requestSerializer setValue:headerField[@"user-token"] forHTTPHeaderField:@"user-token"];
    [manager.requestSerializer setValue:headerField[@"user-id"] forHTTPHeaderField:@"user-id"];
    [manager.requestSerializer setValue:headerField[@"area"] forHTTPHeaderField:@"area"];
    [manager.requestSerializer setValue:headerField[@"sign"] forHTTPHeaderField:@"sign"];
    
    return manager;
}

#pragma mark - 解析错误信息
/**
 *  解析错误信息封装处理
 *  @param errorInfo 错误的信息
 *  @param errorType 错误的类型: 1数据错误 2请求错误
 *  @param errorUrl 错误的Url
 *  @param successHandler 接口请求成功的回调
 *  @param failureHandler 接口请求失败的回调
 */
+ (void)parseErrorInfo:(id)errorInfo errorType:(NSInteger)errorType errorUrl:(NSString *)errorUrl successHandler:(requestSuccessBlock)successHandler failureHandler:(requestFailureBlock)failureHandler {
    
    if (errorType == 1) {
        if (![errorInfo isKindOfClass:[NSData class]]) {
            return;
        }
        
        id object = [NSJSONSerialization JSONObjectWithData:errorInfo options:NSJSONReadingMutableContainers error:nil];
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:object];
        successHandler(dic);
    }
    else if (errorType == 2) {
        NSError *error = errorInfo;
        failureHandler(error);
    }
}

@end
