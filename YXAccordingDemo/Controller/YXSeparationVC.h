//
//  YXSeparationVC.h
//  test
//
//  Created by ios on 2021/4/6.
//

#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, YXSeparationVCType) {
    /** 相册 */
    YXSeparationVCTypeAlbum,
    /** 拍摄 */
    YXSeparationVCTypeTaking,
};

typedef void(^YXSeparationVCReturnImgBlock)(UIImage *img, UIViewController *vc);

@interface YXSeparationVC : UIViewController

/** 类型 */
@property (nonatomic, assign) YXSeparationVCType type;
@property (nonatomic, copy) YXSeparationVCReturnImgBlock yxSeparationVCReturnImgBlock;

@end

NS_ASSUME_NONNULL_END
