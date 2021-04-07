//
//  ViewController.m
//  YXAccordingDemo
//
//  Created by ios on 2021/4/6.
//

#import "ViewController.h"
#import "YXSeparationVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *chooseBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    chooseBtn.frame = CGRectMake(10, [[UIScreen mainScreen] bounds].size.height - 100, 60, 30);
    [chooseBtn setTitle:@"相册" forState:UIControlStateNormal];
    [chooseBtn addTarget:self action:@selector(progressChooseBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:chooseBtn];
    
    UIButton *patBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    patBtn.frame = CGRectMake(chooseBtn.right, [[UIScreen mainScreen] bounds].size.height - 100, 60, 30);
    [patBtn setTitle:@"拍照" forState:UIControlStateNormal];
    [patBtn addTarget:self action:@selector(progressPatBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:patBtn];
}


#pragma mark - progress
#pragma mark - 相册选择
- (void)progressChooseBtn {
    
    [self presentAlbumOrTakePicByBoolAlbum:YES];
}

#pragma mark - 拍照
- (void)progressPatBtn {
    
    [self presentAlbumOrTakePicByBoolAlbum:NO];
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
