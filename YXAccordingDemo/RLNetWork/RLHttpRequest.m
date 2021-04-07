
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

+ (void)getBaiduAIAPIFaceFromImg:(UIImage *)img showText:(NSString *)showText showSuccess:(BOOL)isShowSuccess showError:(BOOL)isShowError finishBlock:(YXRequestFinishBlock)finishBlock {
    
    NSString *tokenUrl = [[NSString alloc] initWithFormat:@"%@?grant_type=%@&client_id=%@&client_secret=%@", @"https://aip.baidubce.com/oauth/2.0/token", @"client_credentials", @"GFugeN2SRPokYw36ivGRQwsO", @"2ZBZq4dF7rKAwfRGSH3SwKsTZoodbfwR"];
    [RLHttpRequest postWithURL:tokenUrl params:nil showText:showText showSuccess:isShowSuccess showError:isShowError block:^(NSDictionary *dic, BOOL isSuccess) {
        
        if (![[dic objectForKey:@"access_token"] isEqualToString:@""]) {
            NSString *httpUrl = [[NSString alloc] initWithFormat:@"%@?access_token=%@", @"https://aip.baidubce.com/rest/2.0/image-classify/v1/body_seg", [dic objectForKey:@"access_token"]];
            
            NSData *imgData = UIImageJPEGRepresentation(img, 0.5);
            NSString *imgEncodedStr = [[imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength] urlEncodeStr:[imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]];
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:httpUrl]];
            request.HTTPMethod = @"POST";
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            
            NSString *postStr = [NSString stringWithFormat:@"image=%@&type=%@", imgEncodedStr, @"foreground"];
            [request setHTTPBody:[postStr dataUsingEncoding:NSUTF8StringEncoding]];
            
            [[manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {

                NSString *resultImgUrl = [responseObject objectForKey:@"foreground"];
                if (![resultImgUrl isEqualToString:@""]) {
                    finishBlock(responseObject, YES);
                }
            }] resume];
        }
    }];
}

@end
