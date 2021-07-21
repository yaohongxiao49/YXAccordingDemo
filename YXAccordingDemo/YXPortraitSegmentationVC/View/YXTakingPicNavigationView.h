//
//  YXTakingPicNavigationView.h
//  test
//
//  Created by ios on 2021/4/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^YXTakingPicNavigationViewBackBlock)(void);
typedef void(^YXTakingPicNavigationViewChangeFlashBlock)(BOOL boolOpen);

@interface YXTakingPicNavigationView : UIView

/** 背景视图 */
@property (weak, nonatomic) IBOutlet UIView *bgView;
/** 返回按钮 */
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
/** 标题背景视图 */
@property (weak, nonatomic) IBOutlet UIView *titleBgV;
/** 拍照icon */
@property (weak, nonatomic) IBOutlet UIImageView *takePicIconImgV;
/** 标题 */
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
/** 闪光灯按钮 */
@property (weak, nonatomic) IBOutlet UIButton *flashBtn;

@property (nonatomic, copy) YXTakingPicNavigationViewBackBlock yxTakingPicNavigationViewBackBlock;
@property (nonatomic, copy) YXTakingPicNavigationViewChangeFlashBlock yxTakingPicNavigationViewChangeFlashBlock;

@end

NS_ASSUME_NONNULL_END
