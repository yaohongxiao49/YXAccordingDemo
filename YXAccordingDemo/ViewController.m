//
//  ViewController.m
//  YXAccordingDemo
//
//  Created by ios on 2021/4/6.
//

#import "ViewController.h"
#import "YXSeparationVC.h"
#import "YXFaceRecognitionVC.h"
#import "YXFaceRecognitionAnimationView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *chooseBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    chooseBtn.frame = CGRectMake(10, [[UIScreen mainScreen] bounds].size.height - 100, 100, 30);
    [chooseBtn setTitle:@"人像分割-相册" forState:UIControlStateNormal];
    [chooseBtn addTarget:self action:@selector(progressChooseBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:chooseBtn];
    
    UIButton *patBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    patBtn.frame = CGRectMake(chooseBtn.right + 20, [[UIScreen mainScreen] bounds].size.height - 100, 100, 30);
    [patBtn setTitle:@"人像分割-拍照" forState:UIControlStateNormal];
    [patBtn addTarget:self action:@selector(progressPatBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:patBtn];
    
    UIButton *identBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    identBtn.frame = CGRectMake(chooseBtn.x, chooseBtn.bottom + 20, 100, 30);
    [identBtn setTitle:@"人脸识别-拍照" forState:UIControlStateNormal];
    [identBtn addTarget:self action:@selector(progressIdentBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:identBtn];
    
    YXFaceRecognitionAnimationView *animationView = [[YXFaceRecognitionAnimationView alloc] initWithFrame:CGRectMake(0, 120, [[UIScreen mainScreen] bounds].size.width, 400)];
    [self.view addSubview:animationView];
    [animationView begainNewAnimation];
}


#pragma mark - progress
#pragma mark - 人像分割-相册选择
- (void)progressChooseBtn {
    
    [self presentAlbumOrTakePicByBoolAlbum:YES];
}

#pragma mark - 人像分割-拍照
- (void)progressPatBtn {
    
    [self presentAlbumOrTakePicByBoolAlbum:NO];
}

#pragma mark - 人脸识别-拍照
- (void)progressIdentBtn {
    
    YXFaceRecognitionVC *vc = [[YXFaceRecognitionVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 选中照片
- (void)presentAlbumOrTakePicByBoolAlbum:(BOOL)boolAlbum {
    
    __weak typeof(self) weakSelf = self;
    
    YXSeparationVC *vc = [[YXSeparationVC alloc] init];
    if (boolAlbum) { //相册
        vc.type = YXSeparationVCTypeAlbum;
    }
    else { //拍照
        vc.type = YXSeparationVCTypeTaking;
    }
    vc.yxSeparationVCReturnImgBlock = ^(UIImage * _Nonnull img, UIViewController * _Nonnull vc) {
        
        UIViewController *lastVC = [[YXCategoryBaseManager instanceManager] yxRemoveVCByVCNameArr:@[@"YXSeparationVC"] currentVC:vc animated:NO];
        [lastVC.navigationController popViewControllerAnimated:YES];
        
        UIImageView *imgV = [[UIImageView alloc] initWithImage:img];
        imgV.center = weakSelf.view.center;
        [weakSelf.view addSubview:imgV];
    };
    [self.navigationController pushViewController:vc animated:NO];
}


@end
