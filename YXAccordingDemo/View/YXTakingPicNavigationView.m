//
//  YXTakingPicNavigationView.m
//  test
//
//  Created by ios on 2021/4/6.
//

#import "YXTakingPicNavigationView.h"

@implementation YXTakingPicNavigationView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleBgV.layer.masksToBounds = YES;
    self.titleBgV.layer.cornerRadius = 5;
    
    [self judgeFlashShowByBoolOpen:NO];
}

#pragma mark - method
#pragma mark - 判断闪光灯按钮显示
- (void)judgeFlashShowByBoolOpen:(BOOL)boolOpen {
    
    [self.flashBtn setImage:[UIImage imageNamed:boolOpen ? @"YXTakingPicFlashOnImg" : @"YXTakingPicFlashOffImg"] forState:UIControlStateNormal];
}

#pragma mark - progress
#pragma mark - 返回按钮
- (IBAction)progressBackBtn:(UIButton *)sender {
    
    if (self.yxTakingPicNavigationViewBackBlock) {
        self.yxTakingPicNavigationViewBackBlock();
    }
}

#pragma mark - 闪光灯按钮
- (IBAction)progressFlashBtn:(UIButton *)sender {
    
    sender.selected =! sender.selected;
    [self judgeFlashShowByBoolOpen:sender.selected];
}

@end
