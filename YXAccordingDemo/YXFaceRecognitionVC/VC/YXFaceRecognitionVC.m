//
//  YXFaceRecognitionVC.m
//  YXAccordingDemo
//
//  Created by ios on 2021/7/21.
//

#import "YXFaceRecognitionVC.h"
#import "YXFaceRecognitionAnimationVC.h"

@interface YXFaceRecognitionVC () <AVCapturePhotoCaptureDelegate>

@property (nonatomic, retain) AVCaptureSession *session;
@property (nonatomic, retain) AVCaptureDeviceInput *input;
@property (nonatomic, retain) AVCaptureDevice *device;
@property (nonatomic, retain) AVCapturePhotoOutput *imageOutput;
@property (nonatomic, retain) AVCaptureVideoPreviewLayer *preview;
@property (nonatomic, retain) AVCapturePhotoSettings *outputSettings;
@property (nonatomic, copy) NSArray *devices;

@property (nonatomic, strong) UIButton *takingPicBtn;

@end

@implementation YXFaceRecognitionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initView];
}

#pragma mark - 使用百度还是CIDetector
- (void)useMethodByOriginalImg:(UIImage *)originalImg {
    
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"分析中，请稍后..."];
    [RLHttpRequest getBaiduAIAPISkinAnalysisFromImg:originalImg showText:nil showSuccess:NO showError:NO finishBlock:^(YXFaceRecognitionBaseModel *model, BOOL boolSuccess) {
        
        if (boolSuccess) {
            YXFaceRecognitionMsgModel *msgModel = model.faceList[0];
            YXFaceRecognitionMsgLocationModel *loactionModel = msgModel.location;
            
            [weakSelf tailoringImgByImg:originalImg location:loactionModel finished:^(BOOL success, UIImage *img) {
            
                msgModel.originalImg = originalImg;
                msgModel.interceptionImg = img;
                if (success) {
                    [weakSelf pushToAnimationVCByModel:model];
                }
                [SVProgressHUD dismiss];
            }];
        }
        else {
            [SVProgressHUD dismiss];
        }
    }];
}

#pragma mark - 裁剪图片
- (void)tailoringImgByImg:(UIImage *)img location:(YXFaceRecognitionMsgLocationModel *)location finished:(void(^)(BOOL success, UIImage *img))finished {
    
    CGRect faceBounds = CGRectMake(location.left, location.top, location.width, location.height);
    //cgImage计算的尺寸是像素，需要与空间的尺寸做个计算
    //下面几句是为了获取到额头部位做的处理，如果只需要定位到五官可直接取faceBounds的值
    //屏幕尺寸换算原图元素尺寸比例（以宽高比为3：4设置）
    CGFloat faceProportionWidth = faceBounds.size.width * 1.4;
    CGFloat faceProportionHeight = faceProportionWidth / 3 * 4;
    CGFloat faceOffsetX = faceBounds.origin.x - (faceProportionWidth / 6);
    CGFloat faceOffsetY = faceBounds.origin.y - (faceProportionHeight / 3);
    faceBounds.origin.x = faceOffsetX;
    faceBounds.origin.y = faceOffsetY;
    faceBounds.size.width = faceProportionWidth;
    faceBounds.size.height = faceProportionHeight;
    
    CGImageRef cgImage = CGImageCreateWithImageInRect(img.CGImage, faceBounds);
    UIImage *resultImg = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    finished(YES, resultImg);
}

#pragma mark - 跳转至动画页
- (void)pushToAnimationVCByModel:(YXFaceRecognitionBaseModel *)model {
    
    YXFaceRecognitionAnimationVC *vc = [[YXFaceRecognitionAnimationVC alloc] init];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 开启
- (void)startRunning {
    
    [_session startRunning];
}

#pragma mark - 关闭
- (void)stopRunning {
    
    [_session stopRunning];
}

#pragma mark - 切换
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position {
    
    for (AVCaptureDevice *device in _devices) {
        if (device.position == position) {
            return device;
        }
    }
    return nil;
}

#pragma mark - 拍照
- (void)progressTakingPic {
    
    AVCapturePhotoSettings *outputSettings = [AVCapturePhotoSettings photoSettingsWithFormat:@{AVVideoCodecKey:AVVideoCodecJPEG}];
    [_imageOutput capturePhotoWithSettings:outputSettings delegate:self];
}

#pragma mark - 取消
- (void)progressCancel {
    
    [self stopRunning];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - <AVCapturePhotoCaptureDelegate>
- (void)captureOutput:(AVCapturePhotoOutput *)captureOutput didFinishProcessingPhotoSampleBuffer:(nullable CMSampleBufferRef)photoSampleBuffer previewPhotoSampleBuffer:(nullable CMSampleBufferRef)previewPhotoSampleBuffer resolvedSettings:(AVCaptureResolvedPhotoSettings *)resolvedSettings bracketSettings:(nullable AVCaptureBracketedStillImageSettings *)bracketSettings error:(nullable NSError *)error {
    
    NSData *data = [AVCapturePhotoOutput JPEGPhotoDataRepresentationForJPEGSampleBuffer:photoSampleBuffer previewPhotoSampleBuffer:previewPhotoSampleBuffer];
    UIImage *img = _device.position == AVCaptureDevicePositionBack ? [UIImage imageWithData:data] : [[UIImage imageWithData:data] fixOrientation:UIImageOrientationLeftMirrored];
    
    [self useMethodByOriginalImg:img];
}

#pragma mark - 初始化视图
- (void)initView {
    
    _session = [AVCaptureSession new];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];

    NSArray<AVCaptureDeviceType> *deviceType;
    if (@available(iOS 10.2, *)) {
        deviceType = @[AVCaptureDeviceTypeBuiltInWideAngleCamera, AVCaptureDeviceTypeBuiltInDualCamera];
    }
    else {
        deviceType = @[AVCaptureDeviceTypeBuiltInWideAngleCamera, AVCaptureDeviceTypeBuiltInDuoCamera];
    }
    
    AVCaptureDeviceDiscoverySession *deviceSession = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:deviceType mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionUnspecified];
    _devices = deviceSession.devices;
    
    for (AVCaptureDevice *device in _devices) {
        if (device.position == AVCaptureDevicePositionFront) {
            _device = device;
        }
    }
    
    NSError *error;
    _input = [[AVCaptureDeviceInput alloc] initWithDevice:_device error:&error];
    if ([_session canAddInput:_input]) {
        [_session addInput:_input];
    }
    
    _imageOutput = [[AVCapturePhotoOutput alloc] init];
    _outputSettings = [AVCapturePhotoSettings photoSettingsWithFormat:@{AVVideoCodecKey:AVVideoCodecJPEG}];
    [_imageOutput setPhotoSettingsForSceneMonitoring:_outputSettings];
    [_session addOutput:_imageOutput];
    
    _preview = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];
    [_preview setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_preview setFrame:self.view.bounds];
    [self.view.layer addSublayer:_preview];
    
    [_session startRunning];
    
    self.takingPicBtn.hidden = NO;
}

#pragma mark - 懒加载
- (UIButton *)takingPicBtn {
    
    if (!_takingPicBtn) {
        _takingPicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _takingPicBtn.frame = CGRectMake(100, self.view.height - 200, 100, 100);
        _takingPicBtn.centerX = self.view.centerX;
        [_takingPicBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_takingPicBtn setTitle:@"拍照" forState:UIControlStateNormal];
        [_takingPicBtn addTarget:self action:@selector(progressTakingPic) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_takingPicBtn];
    }
    return _takingPicBtn;
}

@end
