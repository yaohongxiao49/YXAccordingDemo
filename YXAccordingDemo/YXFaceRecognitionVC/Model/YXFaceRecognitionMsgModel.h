//
//  YXFaceRecognitionMsgModel.h
//  YXAccordingDemo
//
//  Created by ios on 2021/7/21.
//
/// 人脸信息

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 基础信息
@class YXFaceRecognitionMsgLocationModel, YXFaceRecognitionMsgSkinModel, YXFaceRecognitionMsgAcnespotmoleModel, YXFaceRecognitionMsgAcnespotmoleDetailModel, YXFaceRecognitionMsgWrinkleModel, YXFaceRecognitionMsgEyesattrModel, YXFaceRecognitionMsgBlackheadporeModel, YXFaceRecognitionMsgPolyModel, YXFaceRecognitionMsgCirclesModel, YXFaceRecognitionMsgSkinfaceModel, YXFaceRecognitionMsgArrLoactionModel;

@interface YXFaceRecognitionMsgModel : NSObject

/** 人脸标志 */
@property (nonatomic, copy) NSString *faceToken;
/** 人脸在图片中的位置 */
@property (nonatomic, copy) YXFaceRecognitionMsgLocationModel *location;
/** 皮肤相关信息 */
@property (nonatomic, copy) YXFaceRecognitionMsgSkinModel *skin;
/** 痘斑痣相关信息 */
@property (nonatomic, copy) YXFaceRecognitionMsgAcnespotmoleModel *acnespotmole;
/** 皱纹信息 */
@property (nonatomic, copy) YXFaceRecognitionMsgWrinkleModel *wrinkle;
/** 眼睛属性信息 */
@property (nonatomic, copy) YXFaceRecognitionMsgEyesattrModel *eyesattr;
/** 黑头毛孔信息 */
@property (nonatomic, copy) YXFaceRecognitionMsgBlackheadporeModel *blackheadpore;
/** 皮肤健康检测 */
@property (nonatomic, copy) YXFaceRecognitionMsgSkinfaceModel *skinface;

+ (NSMutableArray *)arrayOfModelsFromDictionaries:(NSArray *)arr;
- (instancetype)initWithDic:(NSDictionary *)dic;

@end

#pragma mark - 人脸在图片中的位置
@interface YXFaceRecognitionMsgLocationModel : NSObject

/** 人脸区域离左边界的距离 */
@property (nonatomic, assign) CGFloat left;
/** 人脸区域离上边界的距离 */
@property (nonatomic, assign) CGFloat top;
/** 人脸区域的宽度 */
@property (nonatomic, assign) CGFloat width;
/** 人脸区域的高度 */
@property (nonatomic, assign) CGFloat height;
/** 人脸框相对于竖直方向的顺时针旋转角，[-180,180] */
@property (nonatomic, assign) NSInteger degree;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end

#pragma mark - 皮肤相关信息
@interface YXFaceRecognitionMsgSkinModel : NSObject

/** 肤色分级，1~6，越小肤色越浅 */
@property (nonatomic, assign) NSInteger color;
/** 皮肤光滑度分级，1~4，越小越光滑 */
@property (nonatomic, assign) NSInteger smooth;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end

#pragma mark - 痘斑痣相关信息
@interface YXFaceRecognitionMsgAcnespotmoleModel : NSObject

/** 检测到的痘痘数量 */
@property (nonatomic, assign) NSInteger acneNum;
/** 痘痘列表 */
@property (nonatomic, copy) NSArray <YXFaceRecognitionMsgAcnespotmoleDetailModel *>*acneList;
/** 斑数量 */
@property (nonatomic, assign) NSInteger speckleNum;
/** 斑信息列表 */
@property (nonatomic, copy) NSArray <YXFaceRecognitionMsgAcnespotmoleDetailModel *>*speckleList;
/** 痣数量 */
@property (nonatomic, assign) NSInteger moleNum;
/** 痣信息列表 */
@property (nonatomic, copy) NSArray <YXFaceRecognitionMsgAcnespotmoleDetailModel *>*moleList;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end

#pragma mark - 痘斑痣相关详细信息
@interface YXFaceRecognitionMsgAcnespotmoleDetailModel : NSObject

/** 痘类型，取值范围0-3。【0：粉刺 Whitehead；1：痘印 Acne mark；2：脓包 Pustules；3：结节 Nodules】
    斑类型，取值范围0-3。【0：黄褐斑 chloasma；1：雀斑 freckle；2：晒斑 sunburn；3：老年斑 agespot】
 */
@property (nonatomic, assign) NSInteger type;
/** 此区域为痘/斑/痣的置信度 范围 0~1 */
@property (nonatomic, assign) CGFloat score;
/** 痘/斑/痣区域左边框离图片左边界的距离 */
@property (nonatomic, assign) CGFloat left;
/** 痘/斑/痣区域上边框离图片上边界的距离 */
@property (nonatomic, assign) CGFloat top;
/** 痘/斑/痣区域右边框离图片左边界的距离 */
@property (nonatomic, assign) CGFloat right;
/** 痘/斑/痣区域下边框离图片上边界的距离 */
@property (nonatomic, assign) CGFloat bottom;

- (instancetype)initWithDic:(NSDictionary *)dic;
+ (NSMutableArray *)arrayOfModelsFromDictionaries:(NSArray *)arr;

@end

#pragma mark - 皱纹信息
@interface YXFaceRecognitionMsgWrinkleModel : NSObject

/** 皱纹个数 */
@property (nonatomic, assign) NSInteger wrinkleNum;
/** 皱纹类型：1 抬头纹，2 川字纹，3 眼周细纹，4 鱼尾纹，5 法令纹，6 口周纹 */
@property (nonatomic, copy) NSArray *wrinkleTypes;
@property (nonatomic, copy) NSArray <YXFaceRecognitionMsgArrLoactionModel *>*wrinkleData;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end

#pragma mark - 眼睛属性信息
@interface YXFaceRecognitionMsgEyesattrModel : NSObject

/** 左眼黑眼圈类型：0 色素型，1 阴影型，2血管型 */
@property (nonatomic, assign) NSInteger darkCircleLeftType;
/** 右眼黑眼圈类型：0 色素型，1 阴影型，2血管型 */
@property (nonatomic, assign) NSInteger darkCircleRightType;
/** 左眼黑眼圈 */
@property (nonatomic, copy) NSArray <YXFaceRecognitionMsgArrLoactionModel *>*darkCircleLeft;
/** 右眼黑眼圈 */
@property (nonatomic, copy) NSArray <YXFaceRecognitionMsgArrLoactionModel *>*darkCircleRight;
/** 左眼眼袋 */
@property (nonatomic, copy) NSArray <YXFaceRecognitionMsgArrLoactionModel *>*eyeBagsLeft;
/** 右眼眼袋 */
@property (nonatomic, copy) NSArray <YXFaceRecognitionMsgArrLoactionModel *>*eyeBagsRight;


- (instancetype)initWithDic:(NSDictionary *)dic;

@end

#pragma mark - 黑头毛孔信息
@interface YXFaceRecognitionMsgBlackheadporeModel : NSObject

/** 检测到黑头毛孔的区域 */
@property (nonatomic, copy) NSArray <YXFaceRecognitionMsgPolyModel *>*poly;
/** 毛孔或黑头圆心点及半径 */
@property (nonatomic, copy) NSArray <YXFaceRecognitionMsgCirclesModel *>*circles;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end

#pragma mark - 检测到黑头毛孔的区域
@interface YXFaceRecognitionMsgPolyModel : NSObject

/** 黑头或毛孔标识（0 表示黑头，1表示毛孔） */
@property (nonatomic, assign) NSInteger classId;
/** 概率（0-1） */
@property (nonatomic, assign) CGFloat score;
/** 区域左边界的位置 */
@property (nonatomic, assign) CGFloat left;
/** 区域右边界的位置 */
@property (nonatomic, assign) CGFloat top;
/** 区域上边界的位置 */
@property (nonatomic, assign) CGFloat right;
/** 区域下边界的位置 */
@property (nonatomic, assign) CGFloat bottom;
/** 毛孔或黑头最外层轮廓点 */
@property (nonatomic, copy) NSArray <YXFaceRecognitionMsgArrLoactionModel *>*point;

- (instancetype)initWithDic:(NSDictionary *)dic;
+ (NSMutableArray *)arrayOfModelsFromDictionaries:(NSArray *)arr;

@end

#pragma mark - 毛孔或黑头圆心点及半径
@interface YXFaceRecognitionMsgCirclesModel : NSObject

/** 所有黑头圆心点及半径 */
@property (nonatomic, copy) NSArray <YXFaceRecognitionMsgArrLoactionModel *>*blackhead;
/** 所有毛孔圆心点及半径 */
@property (nonatomic, copy) NSArray <YXFaceRecognitionMsgArrLoactionModel *>*pore;

- (instancetype)initWithDic:(NSDictionary *)dic;
+ (NSMutableArray *)arrayOfModelsFromDictionaries:(NSArray *)arr;

@end

#pragma mark - 皮肤健康检测
@interface YXFaceRecognitionMsgSkinfaceModel : NSObject

/** 皮肤健康检测人脸visia图数组，base64数组 */
@property (nonatomic, copy) NSString *skinHealthCheckImages;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end

#pragma mark - 坐标数组信息
@interface YXFaceRecognitionMsgArrLoactionModel : NSObject

/** 左边界的距离 */
@property (nonatomic, assign) CGFloat x;
/** 上边界的距离 */
@property (nonatomic, assign) CGFloat y;
/** 半径 */
@property (nonatomic, assign) CGFloat r;

- (instancetype)initWithDic:(NSDictionary *)dic;
+ (NSMutableArray *)ournerArrayOfModelsFromDictionaries:(NSArray *)arr;
+ (NSMutableArray *)arrayOfModelsFromDictionaries:(NSArray *)arr;

@end

NS_ASSUME_NONNULL_END
