//
//  YXFaceRecognitionAnimationView.m
//  YXAccordingDemo
//
//  Created by ios on 2021/7/22.
//

#import "YXFaceRecognitionAnimationView.h"

#define kFaceAnimationTime 4

@interface YXFaceRecognitionAnimationView ()

@property (nonatomic, copy) NSArray *valueArr;
@property (nonatomic, strong) NSMutableArray *valueLabArr;
@property (nonatomic, strong) NSMutableArray *animationLabArr;
@property (nonatomic, assign) NSInteger animationTag;

@end

@implementation YXFaceRecognitionAnimationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initView];
    }
    return self;
}

#pragma mark - 开始动画
- (void)begainAnimation {
    
    __weak typeof(self) weakSelf = self;
    CGFloat time = kFaceAnimationTime /(CGFloat)_animationLabArr.count;
    [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        
        UILabel *valueLab = (UILabel *)weakSelf.valueLabArr[weakSelf.animationTag];
        UILabel *animationLab = (UILabel *)weakSelf.animationLabArr[weakSelf.animationTag];
        valueLab.alpha = 1;
        [animationLab sizeToFit];
    } completion:^(BOOL finished) {
        
        if (weakSelf.animationTag < weakSelf.animationLabArr.count - 1) {
            weakSelf.animationTag++;
            [weakSelf begainAnimation];
        }
        else {
            [weakSelf endViewAnimation];
            if (weakSelf.yxFaceRecognitionAVBlock) {
                weakSelf.yxFaceRecognitionAVBlock(YES);
            }
        }
    }];
}

#pragma mark - 末尾动画持续
- (void)endViewAnimation {
    
    UILabel *animationLab = (UILabel *)[_animationLabArr lastObject];
    
    __weak typeof(self) weakSelf = self;
    CGFloat time = kFaceAnimationTime /(CGFloat)_animationLabArr.count;
    [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        
        [animationLab sizeToFit];
    } completion:^(BOOL finished) {
        
        animationLab.width = 0;
        if (!weakSelf.boolEndAnimation) [weakSelf endViewAnimation];
    }];
}

#pragma mark - 初始化视图
- (void)initView {
    
    _valueLabArr = [[NSMutableArray alloc] init];
    _animationLabArr = [[NSMutableArray alloc] init];
    NSInteger i = 0;
    for (NSString *value in self.valueArr) {
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 15 + i *(30 + 15), 100, 30)];
        titleLab.textColor = [UIColor greenColor];
        titleLab.textAlignment = NSTextAlignmentLeft;
        titleLab.font = [UIFont systemFontOfSize:14];
        titleLab.alpha = 0;
        titleLab.text = value;
        [titleLab sizeToFit];
        [self addSubview:titleLab];
        
        UILabel *pointLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleLab.frame) + 5, CGRectGetMinY(titleLab.frame), 0, CGRectGetHeight(titleLab.frame))];
        pointLab.textColor = [UIColor greenColor];
        pointLab.textAlignment = NSTextAlignmentLeft;
        pointLab.font = [UIFont systemFontOfSize:14];
        pointLab.text = @". . .";
        [self addSubview:pointLab];
        
        [_valueLabArr addObject:titleLab];
        [_animationLabArr addObject:pointLab];
        
        i++;
    }
}

#pragma mark - 懒加载
- (NSArray *)valueArr {
    
    if (!_valueArr) {
        _valueArr = @[@"皮肤分析", @"痘痘分析", @"斑印分析", @"皱纹分析", @"眼袋分析", @"眼睛分析", @"黑头分析", @"毛孔分析"];
    }
    return _valueArr;
}

@end
