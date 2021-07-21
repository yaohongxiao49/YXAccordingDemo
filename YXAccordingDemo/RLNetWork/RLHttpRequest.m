
#import "RLHttpRequest.h"
#import <AFNetworking.h>
#import "NSString+tool.h"

@implementation RLHttpRequest

#pragma mark - 单例
+ (RLHttpRequest *)sharedHttpRequest {
    
    static  RLHttpRequest *request = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        request = [RLHttpRequest new];
    });
    return request;
}

#pragma mark - 人像分割
+ (void)getBaiduAIAPIFaceFromImg:(UIImage *)img showText:(NSString *)showText showSuccess:(BOOL)isShowSuccess showError:(BOOL)isShowError finishBlock:(YXRequestFinishBlock)finishBlock {
    
    NSString *tokenUrl = [[NSString alloc] initWithFormat:@"%@?grant_type=%@&client_id=%@&client_secret=%@", @"https://aip.baidubce.com/oauth/2.0/token", @"client_credentials", @"RB9B3iYS12lH4SQteBv0istK", @"ofeT2Pprf6adfS52cdNZyKLxdIyOYiIr"];
    [RLHttpRequest postWithURL:tokenUrl params:nil showText:showText showSuccess:isShowSuccess showError:isShowError block:^(NSDictionary *dic, BOOL isSuccess) {
        
        if (![[dic objectForKey:@"access_token"] isEqualToString:@""]) {
            NSString *httpUrl = [[NSString alloc] initWithFormat:@"%@?access_token=%@", @"https://aip.baidubce.com/rest/2.0/image-classify/v1/body_seg", [dic objectForKey:@"access_token"]];
            
            NSData *imgData = UIImageJPEGRepresentation(img, 0.5);
            NSString *imgEncodedStr = [NSString urlEncodeStr:[imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]];
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:httpUrl]];
            request.HTTPMethod = @"POST";
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            
            NSString *postStr = [NSString stringWithFormat:@"image=%@&type=%@", imgEncodedStr, @"foreground"];
            [request setHTTPBody:[postStr dataUsingEncoding:NSUTF8StringEncoding]];
            
            [[manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {

                if (error.description.length != 0) {
                    finishBlock(responseObject, NO);
                }
                else {
                    NSString *resultImgUrl = [responseObject objectForKey:@"foreground"];
                    if (![resultImgUrl isEqualToString:@""]) {
                        finishBlock(responseObject, YES);
                    }
                }
            }] resume];
        }
    }];
}

#pragma mark - 皮肤分析
+ (void)getBaiduAIAPISkinAnalysisFromImg:(UIImage *)img showText:(NSString *)showText showSuccess:(BOOL)isShowSuccess showError:(BOOL)isShowError finishBlock:(YXRequestFinishBlock)finishBlock {
    
    NSString *tokenUrl = [[NSString alloc] initWithFormat:@"%@?grant_type=%@&client_id=%@&client_secret=%@", @"https://aip.baidubce.com/oauth/2.0/token", @"client_credentials", @"RB9B3iYS12lH4SQteBv0istK", @"ofeT2Pprf6adfS52cdNZyKLxdIyOYiIr"];
    [RLHttpRequest postWithURL:tokenUrl params:nil showText:showText showSuccess:isShowSuccess showError:isShowError block:^(NSDictionary *dic, BOOL isSuccess) {
        
        if (![[dic objectForKey:@"access_token"] isEqualToString:@""]) {
            NSString *httpUrl = [[NSString alloc] initWithFormat:@"%@?access_token=%@", @"https://aip.baidubce.com/rest/2.0/face/v1/skin_analyze", [dic objectForKey:@"access_token"]];
            
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            NSData *imgData = UIImageJPEGRepresentation(img, 0.5);
            NSString *imgEncodedStr = [imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            [dic setObject:[NSString yxGetUUID] forKey:@"appid"];
            [dic setObject:imgEncodedStr forKey:@"image"];
            [dic setObject:@"BASE64" forKey:@"image_type"];
            [dic setObject:@"color,smooth,acnespotmole,wrinkle,eyesattr,blackheadpore,skinface" forKey:@"face_field"];
            [dic setObject:@"1" forKey:@"max_face_num"];
            
            NSData *postData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
            NSMutableDictionary *headerDic = [[NSMutableDictionary alloc] init];
            [headerDic setObject:@"application/json" forKey:@"Content-Type"];
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:httpUrl]];
            request.HTTPMethod = @"POST";
            [request setAllHTTPHeaderFields:headerDic];
            [request setHTTPBody:postData];
            
            [[manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {

                if ([[responseObject objectForKey:@"error_code"] integerValue] == 0) {
                    YXFaceRecognitionBaseModel *model = [[YXFaceRecognitionBaseModel alloc] initWithDic:[responseObject objectForKey:@"result"]];
                    finishBlock(model, YES);
                }
                else {
                    finishBlock(responseObject, NO);
                }
            }] resume];
        }
    }];
}

@end
