//
//  YXTakingPicBottomView.h
//  test
//
//  Created by ios on 2021/4/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^YXTakingPicBottomViewTakePicBlock)(void);
typedef void(^YXTakingPicBottomViewChangeBlock)(BOOL boolFront);

@interface YXTakingPicBottomView : UIView

/** 背景视图 */
@property (weak, nonatomic) IBOutlet UIView *bgView;
/** 拍照按钮 */
@property (weak, nonatomic) IBOutlet UIButton *takingPicBtn;
/** 切换前后置按钮 */
@property (weak, nonatomic) IBOutlet UIButton *changeBtn;

@property (nonatomic, copy) YXTakingPicBottomViewTakePicBlock yxTakingPicBottomViewTakePicBlock;
@property (nonatomic, copy) YXTakingPicBottomViewChangeBlock yxTakingPicBottomViewChangeBlock;

@end

NS_ASSUME_NONNULL_END
