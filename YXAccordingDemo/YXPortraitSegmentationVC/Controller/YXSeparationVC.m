//
//  YXSeparationVC.m
//  test
//
//  Created by ios on 2021/4/6.
//

#import "YXSeparationVC.h"
#import "YXTakingPicVC.h"

@interface YXSeparationVC ()

@property (nonatomic, strong) HXPhotoManager *photoManager;

@end

@implementation YXSeparationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self initView];
}

#pragma mark - 百度aiHTTP
- (void)baiduMethodByImgHTTP:(UIImage *)img {
    
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"处理中，请稍后..."];
    [RLHttpRequest getBaiduAIAPIFaceFromImg:img showText:nil showSuccess:NO showError:NO finishBlock:^(id result, BOOL boolSuccess) {
       
        UIImage *compositionImg = [UIImage new];
        if (boolSuccess) {
            NSString *resultImgUrl = [result objectForKey:@"foreground"];
            NSData *resultImgData = [[NSData alloc] initWithBase64EncodedString:resultImgUrl options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *segmentationImg = [UIImage imageWithData:resultImgData];
            
            //人像图原始宽度
            CGFloat segmentationOriginalWidth = segmentationImg.size.width;
            //人像图原始高度
            CGFloat segmentationOriginalHeight = segmentationImg.size.height;
            //人像图原始宽高比
            CGFloat segmentationOriginalProportion = segmentationOriginalWidth /segmentationOriginalHeight;
            
            //背景图宽度
            CGFloat colorImgWidth = 100;
            CGFloat colorImgHeight = colorImgWidth /segmentationOriginalProportion;
            UIImage *colorImg = [UIImage yxCreateImgByColorArr:@[[UIColor greenColor], [UIColor redColor]] imgSize:CGSizeMake(colorImgWidth, colorImgHeight) directionType:YXGradientDirectionTypeRight];
            
            compositionImg = [UIImage yxComposeImgWithBgImgValue:colorImg bgImgFrame:CGRectMake(0, 0, colorImg.size.width, colorImg.size.height) topImgValue:segmentationImg topImgFrame:CGRectMake(0, 0, colorImgWidth, colorImgHeight) saveToFileWithName:@"" boolByBgView:YES];
        }
        
        if (weakSelf.yxSeparationVCReturnImgBlock) {
            weakSelf.yxSeparationVCReturnImgBlock(compositionImg, weakSelf);
        }
        [SVProgressHUD dismiss];
    }];
}

#pragma mark - 自制的人像分割
- (void)homemadeMethod {
    
    UIImage *segmentationImg = [UIImage yxRemoveColorByColorType:NO segmentationImg:[UIImage imageNamed:@"YXSegmentationImg"]];
    UIImage *colorImg = [UIImage yxCreateImgByColorArr:@[[UIColor greenColor], [UIColor redColor]] imgSize:CGSizeMake(200, 200) directionType:YXGradientDirectionTypeTop];
    UIImage *compositionImg = [UIImage yxComposeImgWithBgImgValue:colorImg bgImgFrame:CGRectMake(0, 0, colorImg.size.width, colorImg.size.height) topImgValue:segmentationImg topImgFrame:CGRectMake((colorImg.size.width - segmentationImg.size.width) /2, (colorImg.size.height - segmentationImg.size.height) /2, segmentationImg.size.width, segmentationImg.size.height) saveToFileWithName:@"" boolByBgView:YES];
    
    UIImageView *imgV = [[UIImageView alloc] initWithImage:compositionImg];
    imgV.center = self.view.center;
    [self.view addSubview:imgV];
}

#pragma mark - 跳转相册选择/图片编辑
- (void)pushToPhotoEditOrAlbumByImg:(UIImage *)img {
    
    __weak typeof(self) weakSelf = self;
    if (self.type == YXSeparationVCTypeAlbum) { //相册
        [self hx_presentSelectPhotoControllerWithManager:self.photoManager didDone:^(NSArray<HXPhotoModel *> *allList, NSArray<HXPhotoModel *> *photoList, NSArray<HXPhotoModel *> *videoList, BOOL isOriginal, UIViewController *viewController, HXPhotoManager *manager) {
            
            //选择的图片
            if (photoList.count > 0) {
                [photoList hx_requestImageWithOriginal:YES completion:^(NSArray<UIImage *> *imageArray, NSArray<HXPhotoModel *> *errorArray) {
                    
                    [weakSelf baiduMethodByImgHTTP:[imageArray lastObject]];
                }];
            }
        }
        cancel:^(UIViewController *viewController, HXPhotoManager *manager) {
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
    }
    else {
        [self hx_presentWxPhotoEditViewControllerWithConfiguration:self.photoManager.configuration.photoEditConfigur editImage:img photoEdit:nil finish:^(HXPhotoEdit * _Nullable photoEdit, HXPhotoModel * _Nonnull photoModel, HX_PhotoEditViewController * _Nonnull viewController) {
            
            if (photoEdit) { //有编辑过
                [weakSelf baiduMethodByImgHTTP:photoEdit.editPreviewImage];
            }
            else { //为空则未进行编辑
                [weakSelf baiduMethodByImgHTTP:photoEdit.editImage];
            }
        } cancel:^(HX_PhotoEditViewController * _Nonnull viewController) {
            
        }];
    }
}

#pragma mark - 初始化视图
- (void)initView {
    
    __weak typeof(self) weakSelf = self;
    if (self.type == YXSeparationVCTypeAlbum) { //相册
        self.photoManager.configuration.singleSelected = YES;
        self.photoManager.configuration.photoMaxNum = 1;
        self.photoManager.configuration.maxNum = 0;
        [weakSelf pushToPhotoEditOrAlbumByImg:nil];
    }
    else { //拍摄
        YXTakingPicVC *vc = [[YXTakingPicVC alloc] init];
        vc.yxTakingPicVCReturnImgBlock = ^(UIImage * _Nonnull img) {
          
            [weakSelf pushToPhotoEditOrAlbumByImg:img];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 懒加载
#pragma mark - 相册选择相关
- (HXPhotoManager *)photoManager {
    
    if (!_photoManager) {
        _photoManager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _photoManager.configuration.clarityScale = 3.0;
        _photoManager.configuration.replaceCameraViewController = YES;
        _photoManager.configuration.replacePhotoEditViewController = NO;
        _photoManager.configuration.openCamera = NO;
        _photoManager.configuration.cameraPhotoJumpEdit = YES;
        _photoManager.configuration.defaultFrontCamera = NO;
        _photoManager.configuration.saveSystemAblum = NO;
        _photoManager.configuration.reverseDate = NO;
        _photoManager.configuration.lookGifPhoto = NO;
        _photoManager.configuration.lookLivePhoto = NO;
        _photoManager.configuration.hideOriginalBtn = NO;
        _photoManager.configuration.singleJumpEdit = YES;
        _photoManager.configuration.photoCanEdit = YES;
        _photoManager.configuration.photoEditConfigur.onlyCliping = YES;
        _photoManager.configuration.photoEditConfigur.aspectRatio = HXPhotoEditAspectRatioType_Custom;
        _photoManager.configuration.photoEditConfigur.customAspectRatio = CGSizeMake(100, 100);
        
        _photoManager.configuration.navBarTranslucent = NO;
        _photoManager.configuration.navBarBackgroudColor = [UIColor whiteColor];
        _photoManager.configuration.navigationTitleColor = [UIColor blackColor];
        _photoManager.configuration.bottomViewTranslucent = NO;
        _photoManager.configuration.bottomViewBgColor = [UIColor whiteColor];
        _photoManager.configuration.cameraFocusBoxColor = [UIColor yxColorByHexString:@"#000000"];
        _photoManager.configuration.selectedTitleColor = [UIColor whiteColor];
        _photoManager.configuration.cellSelectedBgColor = [UIColor yxColorByHexString:@"#000000"];
        _photoManager.configuration.cellSelectedTitleColor = [UIColor whiteColor];
        _photoManager.configuration.previewSelectedBtnBgColor = [UIColor yxColorByHexString:@"#BABABA"];
        _photoManager.configuration.photoEditConfigur.themeColor = [UIColor yxColorByHexString:@"#BABABA"];
        _photoManager.configuration.themeColor = [UIColor yxColorByHexString:@"#000000"];
    }
    return _photoManager;
}

@end
