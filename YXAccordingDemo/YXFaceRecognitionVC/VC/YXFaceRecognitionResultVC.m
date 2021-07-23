//
//  YXFaceRecognitionResultVC.m
//  YXAccordingDemo
//
//  Created by ios on 2021/7/23.
//

#import "YXFaceRecognitionResultVC.h"

@interface YXFaceRecognitionResultVC ()

@property (nonatomic, strong) UIImageView *imgV;

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
    [self tailoringImgByImg:self.model.originalImg location:loactionModel finished:^(BOOL success, UIImage *img) {

        if (success) {
            weakSelf.model.interceptionImg = img;
            weakSelf.imgV.image = weakSelf.model.interceptionImg;
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


#pragma mark - 初始化视图
- (void)initView {
    
    
}

#pragma mark - 懒加载
- (UIImageView *)imgV {
    
    if (!_imgV) {
        _imgV = [[UIImageView alloc] init];
        _imgV.frame = self.view.bounds;
        _imgV.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:_imgV];
    }
    return _imgV;
}

@end
