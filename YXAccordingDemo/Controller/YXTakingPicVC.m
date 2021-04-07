//
//  YXTakingPicVC.m
//  test
//
//  Created by ios on 2021/4/6.
//

#import "YXTakingPicVC.h"
#import <Masonry.h>
#import "YXGPUImageUtils.h"
#import "YXTakingPicNavigationView.h"
#import "YXTakingPicUserMaskView.h"
#import "YXTakingPicBottomView.h"

#define RECORD_WIDTH 720
#define RECORD_HEIGHT 1280
#define _MYAVCaptureSessionPreset(w, h) AVCaptureSessionPreset ## w ## x ## h
#define MYAVCaptureSessionPreset(w, h) _MYAVCaptureSessionPreset(w, h)

@interface YXTakingPicVC ()

@property (nonatomic, strong) YXTakingPicNavigationView *navigationView;
@property (nonatomic, strong) YXTakingPicUserMaskView *userMaskView;
@property (nonatomic, strong) YXTakingPicBottomView *bottomView;

@property CGECameraViewHandler *myCameraViewHandler;
@property (nonatomic) GLKView *glkView; //视频流显示

@end

@implementation YXTakingPicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.hidden = YES;
    [self initView];
}

#pragma mark - 初始化视图
- (void)initView {
    
    _glkView = [[GLKView alloc] initWithFrame:self.view.bounds];
        
    _myCameraViewHandler = [[CGECameraViewHandler alloc] initWithGLKView:_glkView];
    
    if ([_myCameraViewHandler setupCamera:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionFront isFrontCameraMirrored:YES authorizationFailed:^{}]) {
        
        [[_myCameraViewHandler cameraDevice] stopCameraCapture];
    }
    [[_myCameraViewHandler cameraDevice] removeAudioInputsAndOutputs];
    
    [self.view insertSubview:_glkView atIndex:0];
    
    [CGESharedGLContext globalSyncProcessingQueue:^{
        
        [CGESharedGLContext useGlobalGLContext];
        void cgePrintGLInfo(void);
        cgePrintGLInfo();
    }];
    
    [_myCameraViewHandler fitViewSizeKeepRatio:YES];
    //开启美颜（美颜与闪光灯互斥）
    [_myCameraViewHandler enableFaceBeautify:YES];
    //开启闪光灯
    [_myCameraViewHandler setCameraFlashMode:AVCaptureFlashModeOff];
    
    [[_myCameraViewHandler cameraRecorder] setPictureHighResolution:YES];
    cgeSetLoadImageCallback(loadImageCallback, loadImageOKCallback, nil);
    [[_myCameraViewHandler cameraDevice] startCameraCapture];
    
    self.userMaskView.hidden = NO;
}

#pragma mark - 更改锚点、对焦
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    __weak typeof(self) weakSelf = self;
    [touches enumerateObjectsUsingBlock:^(UITouch *touch, BOOL *stop) {
        
        CGPoint touchPoint = [touch locationInView:weakSelf.glkView];
        CGSize sz = [weakSelf.glkView frame].size;
        CGPoint transPoint = CGPointMake(touchPoint.x /sz.width, touchPoint.y /sz.height);
        
        [weakSelf.myCameraViewHandler focusPoint:transPoint];
    }];
}

#pragma mark - 跳转到照片结果
- (void)pushToPicResultVC:(UIImage *)img {
    
    if (self.yxTakingPicVCReturnImgBlock) {
        self.yxTakingPicVCReturnImgBlock(img);
    }
}

#pragma mark - 拍照
- (void)progressTakePicBtn {
    
    __weak typeof(self) weakSelf = self;
    [self progressFlashBtn];
    if ([_myCameraViewHandler isGlobalFilterEnabled]) {
        [_myCameraViewHandler takeShot:^(UIImage *image) {
            
            if(image != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [weakSelf pushToPicResultVC:image];
                });
            }
        }];
    }
    else {
        [_myCameraViewHandler takePicture:^(UIImage *image) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakSelf pushToPicResultVC:image];
            });
        } filterConfig:g_effectConfig[0] filterIntensity:1.0f isFrontCameraMirrored:YES];
    }
}

#pragma mark - 闪光灯
- (void)progressFlashBtn {
    
    static AVCaptureFlashMode flashLightList[] = {
        AVCaptureFlashModeOff,
        AVCaptureFlashModeOn,
        AVCaptureFlashModeAuto
    };
    static int flashLightIndex = 0;
    
    ++flashLightIndex;
    flashLightIndex %= sizeof(flashLightList) /sizeof(*flashLightList);
    
    [_myCameraViewHandler setCameraFlashMode:flashLightList[flashLightIndex]];
}

#pragma mark - 还原设置
- (void)reductionCamera {
    
    [[[_myCameraViewHandler cameraRecorder] cameraDevice] stopCameraCapture];
    
    [_myCameraViewHandler clear];
    _myCameraViewHandler = nil;
    [CGESharedGLContext clearGlobalGLContext];
}

#pragma mark - 懒加载
- (YXTakingPicNavigationView *)navigationView {
    
    if (!_navigationView) {
        _navigationView = [[[NSBundle mainBundle] loadNibNamed:[YXTakingPicNavigationView.class description] owner:nil options:nil] lastObject];
        [_glkView addSubview:_navigationView];
        
        __weak typeof(self) weakSelf = self;
        _navigationView.yxTakingPicNavigationViewBackBlock = ^{
          
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        
        [_navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.and.top.and.right.equalTo(_glkView);
            make.height.mas_equalTo(self.yxNaviHeight);
        }];
    }
    return _navigationView;
}
- (YXTakingPicUserMaskView *)userMaskView {
    
    if (!_userMaskView) {
        _userMaskView = [[[NSBundle mainBundle] loadNibNamed:[YXTakingPicUserMaskView.class description] owner:nil options:nil] lastObject];
        [_glkView addSubview: _userMaskView];
        
        [_userMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.and.right.equalTo(_glkView);
            make.top.equalTo(self.navigationView.mas_bottom);
            make.bottom.equalTo(self.bottomView.mas_top);
        }];
    }
    return _userMaskView;
}
- (YXTakingPicBottomView *)bottomView {
    
    if (!_bottomView) {
        _bottomView = [[[NSBundle mainBundle] loadNibNamed:[YXTakingPicBottomView.class description] owner:nil options:nil] lastObject];
        [_glkView addSubview:_bottomView];
        
        __weak typeof(self) weakSelf = self;
        _bottomView.yxTakingPicBottomViewTakePicBlock = ^{
          
            [weakSelf progressTakePicBtn];
        };
        _bottomView.yxTakingPicBottomViewChangeBlock = ^(BOOL boolFront) {
            
            [weakSelf.myCameraViewHandler switchCamera:YES];
        };
        
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.and.right.and.bottom.equalTo(_glkView);
            make.height.mas_equalTo(self.yxBottomSafeHeight + 140);
        }];
    }
    return _bottomView;
}

@end
