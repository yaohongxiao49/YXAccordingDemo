//
//  YXTakingPicUserMaskView.m
//  test
//
//  Created by ios on 2021/4/6.
//

#import "YXTakingPicUserMaskView.h"

@implementation YXTakingPicUserMaskView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self pointTransparentMethodByRect:CGRectMake(30, 50, CGRectGetWidth(self.maskBgView.bounds) - 60, CGRectGetHeight(self.maskBgView.bounds) - 100)];
}

#pragma mark - 指定透明
- (void)pointTransparentMethodByRect:(CGRect)rect {

    //指定透明坐标范围
    CGRect transparentRect = rect;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.maskBgView.frame cornerRadius:0];
    //镂空
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithRect:transparentRect];
    [path appendPath:circlePath];
    [path setUsesEvenOddFillRule:YES];
    
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.path = path.CGPath;
    fillLayer.fillRule = kCAFillRuleEvenOdd;
    fillLayer.fillColor = [UIColor blackColor].CGColor;
    fillLayer.opacity = 0.5;
    [self.maskBgView.layer addSublayer:fillLayer];
}

@end
