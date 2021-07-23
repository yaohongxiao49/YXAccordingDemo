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
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initView];
}

#pragma mark - 使用CIDetector
- (void)useMethodByOriginalImg:(UIImage *)originalImg {
    
    __weak typeof(self) weakSelf = self;
    [self yxDetectingFaceByImg:originalImg finished:^(BOOL boolSuccess) {
        
        if (boolSuccess) {
            [weakSelf pushToAnimationVCByImg:originalImg];
        }
        else {
            [SVProgressHUD showErrorWithStatus:@"请包涵面容"];
        }
    }];
}

#pragma mark - 人脸位置检测
- (void)yxDetectingFaceByImg:(UIImage *)img finished:(void(^)(BOOL boolSuccess))finished {
    
    if (img) {
        CIImage *cgImg = [[CIImage alloc] initWithImage:img];
        CIContext *context = [CIContext contextWithOptions:nil];
        CIDetector *faceDetector = [CIDetector detectorOfType:CIDetectorTypeFace context:context options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
        //检测到的人脸数组
        NSArray *faceArr = [faceDetector featuresInImage:cgImg];
        finished(faceArr.count > 0);
    }
    else {
        finished(NO);
    }
}

#pragma mark - 跳转至动画页
- (void)pushToAnimationVCByImg:(UIImage *)img {
    
    YXFaceRecognitionAnimationVC *vc = [[YXFaceRecognitionAnimationVC alloc] init];
    vc.originalImg = img;
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
