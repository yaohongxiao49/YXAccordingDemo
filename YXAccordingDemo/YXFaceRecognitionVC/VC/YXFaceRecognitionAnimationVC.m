//
//  YXFaceRecognitionAnimationVC.m
//  YXAccordingDemo
//
//  Created by ios on 2021/7/22.
//

#import "YXFaceRecognitionAnimationVC.h"
#import "YXFaceRecognitionAnimationView.h"

@interface YXFaceRecognitionAnimationVC ()

@property (nonatomic, strong) UIImageView *imgV;
@property (nonatomic, strong) UIButton *proportionBtn;
@property (nonatomic, strong) YXFaceRecognitionAnimationView *animationView;
@property (nonatomic, strong) YXFaceRecognitionMsgModel *msgModel;

@end

@implementation YXFaceRecognitionAnimationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _msgModel = self.model.faceList[0];
    self.imgV.image = _msgModel.originalImg;
    
    self.proportionBtn.hidden = NO;
    self.animationView.hidden = NO;
}

#pragma mark - progress
- (void)progressProportionBtn:(UIButton *)sender {
    
    sender.selected =! sender.selected;
    if (sender.selected) {
        self.imgV.contentMode = UIViewContentModeScaleAspectFit;
        self.imgV.image = _msgModel.interceptionImg;
    }
    else {
        self.imgV.contentMode = UIViewContentModeScaleAspectFill;
        self.imgV.image = _msgModel.originalImg;
    }
}

#pragma mark - 懒加载
- (UIImageView *)imgV {
    
    if (!_imgV) {
        _imgV = [[UIImageView alloc] init];
        _imgV.frame = self.view.bounds;
        _imgV.contentMode = UIViewContentModeScaleAspectFill;
        [self.view addSubview:_imgV];
    }
    return _imgV;
}
- (UIButton *)proportionBtn {
    
    if (!_proportionBtn) {
        _proportionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _proportionBtn.frame = CGRectMake(100, self.view.height - 200, 100, 100);
        _proportionBtn.centerX = self.view.centerX;
        [_proportionBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_proportionBtn setTitle:@"切换" forState:UIControlStateNormal];
        [_proportionBtn addTarget:self action:@selector(progressProportionBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_proportionBtn];
    }
    return _proportionBtn;
}
- (YXFaceRecognitionAnimationView *)animationView {
    
    if (!_animationView) {
        _animationView = [[YXFaceRecognitionAnimationView alloc] initWithFrame:CGRectMake(0, 120, [[UIScreen mainScreen] bounds].size.width, 400)];
        [self.imgV addSubview:_animationView];
    }
    return _animationView;
}

@end
