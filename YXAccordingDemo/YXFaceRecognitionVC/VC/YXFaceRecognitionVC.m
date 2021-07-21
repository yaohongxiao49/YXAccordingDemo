//
//  YXFaceRecognitionVC.m
//  YXAccordingDemo
//
//  Created by ios on 2021/7/21.
//

#import "YXFaceRecognitionVC.h"

@interface YXFaceRecognitionVC () <AVCapturePhotoCaptureDelegate>

@property (nonatomic, retain) AVCaptureSession *session;
@property (nonatomic, retain) AVCaptureDeviceInput *input;
@property (nonatomic, retain) AVCaptureDevice *device;
@property (nonatomic, retain) AVCapturePhotoOutput *imageOutput;
@property (nonatomic, retain) AVCaptureVideoPreviewLayer *preview;
@property (nonatomic, retain) AVCapturePhotoSettings *outputSettings;
@property (nonatomic, copy) NSArray *devices;

@property (nonatomic, strong) UIButton *takingPicBtn;
@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, assign) BOOL boolBaidu;

@end

@implementation YXFaceRecognitionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _boolBaidu = YES;
    
    [self initView];
}

#pragma mark - 使用百度还是CIDetector
- (void)useMethodByImg:(UIImage *)img {
    
    if (_boolBaidu) {
        __weak typeof(self) weakSelf = self;
        [RLHttpRequest getBaiduAIAPISkinAnalysisFromImg:img showText:nil showSuccess:NO showError:NO finishBlock:^(YXFaceRecognitionBaseModel *model, BOOL boolSuccess) {
            
            if (boolSuccess) {
                YXFaceRecognitionMsgModel *msgModel = model.faceList[0];
                YXFaceRecognitionMsgLocationModel *loactionModel = msgModel.location;
                
                [weakSelf tailoringImgByImg:img location:loactionModel finished:^(BOOL success, UIImage *img) {
                    
                    if (success) {
                        weakSelf.imgView.image = img;
                        weakSelf.imgView.hidden = NO;
                    }
                }];
                NSLog(@"baidu成功了！");
            }
            else {
                NSLog(@"baidu失败了！");
            }
        }];
    }
    else {
        [UIImage yxDetectingAndCuttingFaceByImg:img boolAccurate:NO finished:^(BOOL success, UIImage * _Nonnull img) {
          
            if (success) {
                self.imgView.image = img;
                self.imgView.hidden = NO;
                NSLog(@"成功了！");
            }
            else {
                NSLog(@"失败了！");
            }
        }];
    }
}

#pragma mark - 裁剪图片
- (void)tailoringImgByImg:(UIImage *)img location:(YXFaceRecognitionMsgLocationModel *)location finished:(void(^)(BOOL success, UIImage *img))finished {
    
    CGRect faceBounds = CGRectMake(location.left, location.top, location.width, location.height);
    //cgImage计算的尺寸是像素，需要与空间的尺寸做个计算
    //下面几句是为了获取到额头部位做的处理，如果只需要定位到五官可直接取faceBounds的值
    //屏幕尺寸换算原图元素尺寸比例（以宽高比为3：5设置）
    CGFloat faceProportionWidth = faceBounds.size.width * 1.4;
    CGFloat faceProportionHeight = faceProportionWidth / 3 * 5;
    CGFloat faceOffsetX = faceBounds.origin.x - faceProportionWidth / 10;
    CGFloat faceOffsetY = faceBounds.origin.y - faceProportionHeight / 3;
    faceBounds.origin.x = faceOffsetX;
    faceBounds.origin.y = faceOffsetY;
    faceBounds.size.width = faceProportionWidth;
    faceBounds.size.height = faceProportionHeight;
    
    //这种裁剪方法在低头时和抬头时会截取不到完整的脸部，但是可以定位全脸位置更精确
    CGImageRef cgImage = CGImageCreateWithImageInRect(img.CGImage, faceBounds);
    UIImage *resultImg = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
//    //这种裁剪方法不会出现脸部裁剪不到的情况，但是会裁剪到脖子的位置
//    CIImage *cgImg = [[CIImage alloc] initWithImage:img];
//    CIContext *context = [CIContext contextWithOptions:nil];
//    CIImage *faceImg = [cgImg imageByCroppingToRect:faceBounds];
//    UIImage *resultImg = [UIImage imageWithCGImage:[context createCGImage:faceImg fromRect:faceImg.extent]];
    
    finished(YES, resultImg);
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

#pragma mark - progress
- (void)progressImgView {
    
    self.imgView.hidden = YES;
}

#pragma mark - <AVCapturePhotoCaptureDelegate>
- (void)captureOutput:(AVCapturePhotoOutput *)captureOutput didFinishProcessingPhotoSampleBuffer:(nullable CMSampleBufferRef)photoSampleBuffer previewPhotoSampleBuffer:(nullable CMSampleBufferRef)previewPhotoSampleBuffer resolvedSettings:(AVCaptureResolvedPhotoSettings *)resolvedSettings bracketSettings:(nullable AVCaptureBracketedStillImageSettings *)bracketSettings error:(nullable NSError *)error {
    
    NSData *data = [AVCapturePhotoOutput JPEGPhotoDataRepresentationForJPEGSampleBuffer:photoSampleBuffer previewPhotoSampleBuffer:previewPhotoSampleBuffer];
    UIImage *img = _device.position == AVCaptureDevicePositionBack ? [UIImage imageWithData:data] : [[UIImage imageWithData:data] fixOrientation:UIImageOrientationLeftMirrored];
    
    [self useMethodByImg:img];
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
    self.imgView.hidden = YES;
}

#pragma mark - 懒加载
- (UIButton *)takingPicBtn {
    
    if (!_takingPicBtn) {
        _takingPicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _takingPicBtn.frame = CGRectMake(100, 400, 100, 100);
        [_takingPicBtn setTitle:@"拍照" forState:UIControlStateNormal];
        [_takingPicBtn addTarget:self action:@selector(progressTakingPic) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_takingPicBtn];
    }
    return _takingPicBtn;
}
- (UIImageView *)imgView {
    
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.frame = self.view.bounds;
        _imgView.userInteractionEnabled = YES;
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:_imgView];
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(progressImgView)];
        [_imgView addGestureRecognizer:gesture];
    }
    return _imgView;
}

@end
