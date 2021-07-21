//
//  YXTakingPicVC.h
//  test
//
//  Created by ios on 2021/4/6.
//

#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^YXTakingPicVCReturnImgBlock)(UIImage *img);

@interface YXTakingPicVC : UIViewController

@property (nonatomic, copy) YXTakingPicVCReturnImgBlock yxTakingPicVCReturnImgBlock;

@end

NS_ASSUME_NONNULL_END
