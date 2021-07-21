//
//  YXTakingPicBottomView.m
//  test
//
//  Created by ios on 2021/4/6.
//

#import "YXTakingPicBottomView.h"

@implementation YXTakingPicBottomView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self judgeChangeShowByBoolFront:YES];
}

#pragma mark - method
#pragma mark - 判断切换按钮显示
- (void)judgeChangeShowByBoolFront:(BOOL)boolFront {
    
    [self.changeBtn setImage:[UIImage imageNamed:boolFront ? @"YXTakingPicChangeImg" : @"YXTakingPicChangeImg"] forState:UIControlStateNormal];
}

#pragma mark - progress
#pragma mark - 拍照
- (IBAction)progressTakingPicBtn:(UIButton *)sender {
    
    if (self.yxTakingPicBottomViewTakePicBlock) {
        self.yxTakingPicBottomViewTakePicBlock();
    }
}

#pragma mark - 切换前后置
- (IBAction)progressChangeBtn:(UIButton *)sender {
    
    sender.selected =! sender.selected;
    [self judgeChangeShowByBoolFront:sender.selected];
    if (self.yxTakingPicBottomViewChangeBlock) {
        self.yxTakingPicBottomViewChangeBlock(sender.selected);
    }
}

@end
