//
//  YXFaceRecognitionAnimationVC.m
//  YXAccordingDemo
//
//  Created by ios on 2021/7/22.
//

#import "YXFaceRecognitionAnimationVC.h"
#import "YXFaceRecognitionAnimationView.h"
#import "YXFaceRecognitionResultVC.h"

@interface YXFaceRecognitionAnimationVC ()

@property (nonatomic, strong) UIImageView *imgV;
@property (nonatomic, strong) YXFaceRecognitionAnimationView *animationView;

@property (nonatomic, strong) YXFaceRecognitionBaseModel *model;
@property (nonatomic, strong) YXFaceRecognitionMsgModel *msgModel;

@end

@implementation YXFaceRecognitionAnimationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initView];
    [self getBaiduAIFaceHTTP];
}

#pragma mark - 开启动画、获取百度ai面容皮肤分析
- (void)getBaiduAIFaceHTTP {
    
    [self.animationView begainAnimation];
    __weak typeof(self) weakSelf = self;
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_async(group, queue, ^{
        
        [weakSelf beginAnimationByGroup:group];
    });
    dispatch_group_async(group, queue, ^{
    
        [weakSelf beginBaiduAISkinAnalysisByGroup:group];
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        weakSelf.animationView.boolEndAnimation = YES;
        [weakSelf pushToResultVC];
    });
}

#pragma mark - 开启动画
- (void)beginAnimationByGroup:(dispatch_group_t)group {
    
    dispatch_group_enter(group);
    self.animationView.yxFaceRecognitionAVBlock = ^(BOOL boolFinished) {
        
        dispatch_group_leave(group);
    };
}

#pragma mark - 开启百度皮肤分析
- (void)beginBaiduAISkinAnalysisByGroup:(dispatch_group_t)group {
    
    __weak typeof(self) weakSelf = self;
    dispatch_group_enter(group);
    [RLHttpRequest getBaiduAIAPISkinAnalysisFromImg:self.originalImg showText:nil showSuccess:NO showError:NO finishBlock:^(YXFaceRecognitionBaseModel *model, BOOL boolSuccess) {
        
        weakSelf.model = model;
        weakSelf.model.originalImg = weakSelf.originalImg;
        dispatch_group_leave(group);
    }];
}

#pragma mark - 跳转至结果页
- (void)pushToResultVC {
    
    if (_model == nil) {
        [SVProgressHUD showErrorWithStatus:@"分析失败，请重新拍照！"];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        YXFaceRecognitionResultVC *vc = [[YXFaceRecognitionResultVC alloc] init];
        vc.model = _model;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 初始化视图
- (void)initView {
    
    self.imgV.image = self.originalImg;
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
- (YXFaceRecognitionAnimationView *)animationView {
    
    if (!_animationView) {
        _animationView = [[YXFaceRecognitionAnimationView alloc] initWithFrame:CGRectMake(0, 120, [[UIScreen mainScreen] bounds].size.width, 400)];
        [self.imgV addSubview:_animationView];
    }
    return _animationView;
}

@end
