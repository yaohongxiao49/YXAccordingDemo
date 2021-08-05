//
//  YXFaceRecognitionResultVC.m
//  YXAccordingDemo
//
//  Created by ios on 2021/7/23.
//

#import "YXFaceRecognitionResultVC.h"

@interface YXFaceRecognitionResultVC ()

@property (nonatomic, strong) UIImageView *imgV;
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UIButton *fullBtn;

@end

@implementation YXFaceRecognitionResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initView];
    [self tailoringImg];
}

#pragma mark - 分割头像
- (void)tailoringImg {
    
    __weak typeof(self) weakSelf = self;
    
    YXFaceRecognitionMsgModel *msgModel = self.model.faceList[0];
    YXFaceRecognitionMsgLocationModel *loactionModel = msgModel.location;
    [self tailoringImgByImg:self.model.originalImg boolFull:NO location:loactionModel finished:^(BOOL success, UIImage *img) {

        if (success) {
            weakSelf.model.interceptionImg = img;
            weakSelf.imgV.image = weakSelf.model.interceptionImg;
        }
    }];
}

#pragma mark - 裁剪图片
- (void)tailoringImgByImg:(UIImage *)img boolFull:(BOOL)boolFull location:(YXFaceRecognitionMsgLocationModel *)location finished:(void(^)(BOOL success, UIImage *img))finished {
    
    CGRect faceBounds = CGRectMake(location.left, location.top, location.width, location.height);
    //cgImage计算的尺寸是像素，需要与空间的尺寸做个计算
    //下面几句是为了获取到额头部位做的处理，如果只需要定位到五官可直接取faceBounds的值
    //屏幕尺寸换算原图元素尺寸比例（以宽高比为3：4设置）
    CGFloat faceProportionWidth = faceBounds.size.width * 1.4;
    CGFloat faceProportionHeight = faceProportionWidth / 3 * 4;
    if (boolFull) {
        faceProportionHeight = faceProportionWidth / [[UIScreen mainScreen] bounds].size.width * [[UIScreen mainScreen] bounds].size.height;
    }
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

#pragma mark - progress
- (void)progressBtn:(UIButton *)sender {
 
    __weak typeof(self) weakSelf = self;
    YXFaceRecognitionMsgModel *msgModel = self.model.faceList[0];
    YXFaceRecognitionMsgLocationModel *loactionModel = msgModel.location;
    NSString *title = sender.titleLabel.text;
    if ([title containsString:@"3:4"]) {
        [self tailoringImgByImg:self.model.originalImg boolFull:YES location:loactionModel finished:^(BOOL success, UIImage *img) {

            if (success) {
                weakSelf.model.interceptionImg = img;
                weakSelf.imgV.image = weakSelf.model.interceptionImg;
            }
        }];
        [sender setTitle:@"全屏" forState:UIControlStateNormal];
    }
    else if ([title containsString:@"全屏"]) {
        [self tailoringImgByImg:self.model.originalImg boolFull:NO location:loactionModel finished:^(BOOL success, UIImage *img) {

            if (success) {
                weakSelf.model.interceptionImg = img;
                weakSelf.imgV.image = weakSelf.model.interceptionImg;
            }
        }];
        [sender setTitle:@"3:4" forState:UIControlStateNormal];
    }
}
- (void)progressFullBtn:(UIButton *)sender {
    
    NSString *title = sender.titleLabel.text;
    if ([title containsString:@"比例"]) {
        self.imgV.contentMode = UIViewContentModeScaleAspectFill;
        [sender setTitle:@"铺满" forState:UIControlStateNormal];
    }
    else {
        self.imgV.contentMode = UIViewContentModeScaleAspectFit;
        [sender setTitle:@"比例" forState:UIControlStateNormal];
    }
}

#pragma mark - 初始化视图
- (void)initView {
    
    self.fullBtn.hidden = NO;
}

#pragma mark - 懒加载
- (UIImageView *)imgV {
    
    if (!_imgV) {
        _imgV = [[UIImageView alloc] init];
        _imgV.frame = self.view.bounds;
        _imgV.contentMode = UIViewContentModeScaleAspectFit;
        _imgV.userInteractionEnabled = YES;
        [self.view addSubview:_imgV];
    }
    return _imgV;
}
- (UIButton *)btn {
    
    if (!_btn) {
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn.frame = CGRectMake(0, 0, 100, 100);
        _btn.center = self.imgV.center;
        [_btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_btn setTitle:@"3:4" forState:UIControlStateNormal];
        [_btn addTarget:self action:@selector(progressBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.imgV addSubview:_btn];
    }
    return _btn;
}
- (UIButton *)fullBtn {
    
    if (!_fullBtn) {
        _fullBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _fullBtn.frame = CGRectMake(CGRectGetMaxX(self.btn.frame) + 20, CGRectGetMinY(self.btn.frame), 100, 100);
        [_fullBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [_fullBtn setTitle:@"比例" forState:UIControlStateNormal];
        [_fullBtn addTarget:self action:@selector(progressFullBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.imgV addSubview:_fullBtn];
    }
    return _fullBtn;
}

@end
