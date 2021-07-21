//
//  YXFaceRecognitionMsgModel.m
//  YXAccordingDemo
//
//  Created by ios on 2021/7/21.
//

#import "YXFaceRecognitionMsgModel.h"

#pragma mark - 基础信息
@implementation YXFaceRecognitionMsgModel

+ (NSMutableArray *)arrayOfModelsFromDictionaries:(NSArray *)arr {
    
    NSMutableArray *dataAry = [NSMutableArray array];
    for (NSDictionary *dic in arr) {
        YXFaceRecognitionMsgModel *model = [[YXFaceRecognitionMsgModel alloc] initWithDic:dic];
        
        [dataAry addObject:model];
    }
    return dataAry;
}

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    
    if (self) {
        _faceToken = [dic objectForKey:@"face_token"];
        _location = [[YXFaceRecognitionMsgLocationModel alloc] initWithDic:[dic objectForKey:@"location"]];
        _skin = [[YXFaceRecognitionMsgSkinModel alloc] initWithDic:[dic objectForKey:@"skin"]];
        _acnespotmole = [[YXFaceRecognitionMsgAcnespotmoleModel alloc] initWithDic:[dic objectForKey:@"acnespotmole"]];
        _wrinkle = [[YXFaceRecognitionMsgWrinkleModel alloc] initWithDic:[dic objectForKey:@"wrinkle"]];
        _eyesattr = [[YXFaceRecognitionMsgEyesattrModel alloc] initWithDic:[dic objectForKey:@"eyesattr"]];
        _blackheadpore = [[YXFaceRecognitionMsgBlackheadporeModel alloc] initWithDic:[dic objectForKey:@"blackheadpore"]];
        _skinface = [[YXFaceRecognitionMsgSkinfaceModel alloc] initWithDic:[dic objectForKey:@"skinface"]];
    }
    return self;
}

@end

#pragma mark - 人脸在图片中的位置
@implementation YXFaceRecognitionMsgLocationModel

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    
    if (self) {
        _left = [[dic objectForKey:@"left"] floatValue];
        _top = [[dic objectForKey:@"top"] floatValue];
        _width = [[dic objectForKey:@"width"] floatValue];
        _height = [[dic objectForKey:@"height"] floatValue];
        _degree = [[dic objectForKey:@"degree"] integerValue];
    }
    return self;
}

@end

#pragma mark - 皮肤相关信息
@implementation YXFaceRecognitionMsgSkinModel

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    
    if (self) {
        _color = [[dic objectForKey:@"color"] integerValue];
        _smooth = [[dic objectForKey:@"smooth"] integerValue];
    }
    return self;
}

@end

#pragma mark - 痘斑痣相关信息
@implementation YXFaceRecognitionMsgAcnespotmoleModel

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    
    if (self) {
        _acneNum = [[dic objectForKey:@"acne_num"] integerValue];
        _acneList = [YXFaceRecognitionMsgAcnespotmoleDetailModel arrayOfModelsFromDictionaries:[dic objectForKey:@"acne_list"]];
        _speckleNum = [[dic objectForKey:@"speckle_num"] integerValue];
        _speckleList = [YXFaceRecognitionMsgAcnespotmoleDetailModel arrayOfModelsFromDictionaries:[dic objectForKey:@"speckle_list"]];
        _moleNum = [[dic objectForKey:@"mole_num"] integerValue];
        _moleList = [YXFaceRecognitionMsgAcnespotmoleDetailModel arrayOfModelsFromDictionaries:[dic objectForKey:@"mole_list"]];
    }
    return self;
}

@end

#pragma mark - 痘斑痣相关详细信息
@implementation YXFaceRecognitionMsgAcnespotmoleDetailModel

+ (NSMutableArray *)arrayOfModelsFromDictionaries:(NSArray *)arr {
    
    NSMutableArray *dataAry = [NSMutableArray array];
    for (NSDictionary *dic in arr) {
        YXFaceRecognitionMsgAcnespotmoleDetailModel *model = [[YXFaceRecognitionMsgAcnespotmoleDetailModel alloc] initWithDic:dic];
        
        [dataAry addObject:model];
    }
    return dataAry;
}

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    
    if (self) {
        _type = [[dic objectForKey:@"type"] integerValue];
        _score = [[dic objectForKey:@"score"] floatValue];
        _left = [[dic objectForKey:@"left"] floatValue];
        _top = [[dic objectForKey:@"top"] floatValue];
        _right = [[dic objectForKey:@"right"] floatValue];
        _bottom = [[dic objectForKey:@"bottom"] floatValue];
    }
    return self;
}

@end

#pragma mark - 皱纹信息
@implementation YXFaceRecognitionMsgWrinkleModel

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    
    if (self) {
        _wrinkleNum = [[dic objectForKey:@"wrinkle_num"] integerValue];
        _wrinkleTypes = [[NSArray alloc] initWithArray:[dic objectForKey:@"wrinkle_types"]];
        _wrinkleData = [YXFaceRecognitionMsgArrLoactionModel arrayOfModelsFromDictionaries:[dic objectForKey:@"wrinkle_data"]];
    }
    return self;
}

@end

#pragma mark - 眼睛属性信息
@implementation YXFaceRecognitionMsgEyesattrModel

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    
    if (self) {
        _darkCircleLeftType = [[dic objectForKey:@"dark_circle_left_type"] count] != 0 ? [[dic objectForKey:@"dark_circle_left_type"][0] integerValue] : -1;
        _darkCircleRightType =  [[dic objectForKey:@"dark_circle_right_type"] count] != 0 ? [[dic objectForKey:@"dark_circle_right_type"][0] integerValue] : -1;
        _darkCircleLeft = [YXFaceRecognitionMsgArrLoactionModel arrayOfModelsFromDictionaries:[dic objectForKey:@"dark_circle_left"]];
        _darkCircleRight = [YXFaceRecognitionMsgArrLoactionModel arrayOfModelsFromDictionaries:[dic objectForKey:@"dark_circle_right"]];
        _eyeBagsLeft = [YXFaceRecognitionMsgArrLoactionModel arrayOfModelsFromDictionaries:[dic objectForKey:@"eye_bags_left"]];
        _eyeBagsRight = [YXFaceRecognitionMsgArrLoactionModel arrayOfModelsFromDictionaries:[dic objectForKey:@"eye_bags_right"]];
    }
    return self;
}

@end

#pragma mark - 黑头毛孔信息
@implementation YXFaceRecognitionMsgBlackheadporeModel

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    
    if (self) {
        _poly = [YXFaceRecognitionMsgPolyModel arrayOfModelsFromDictionaries:[dic objectForKey:@"poly"]];
        _circles = [YXFaceRecognitionMsgCirclesModel arrayOfModelsFromDictionaries:[dic objectForKey:@"circles"]];
    }
    return self;
}

@end

#pragma mark - 检测到黑头毛孔的区域
@implementation YXFaceRecognitionMsgPolyModel

+ (NSMutableArray *)arrayOfModelsFromDictionaries:(NSArray *)arr {
    
    NSMutableArray *dataAry = [NSMutableArray array];
    for (NSDictionary *dic in arr) {
        YXFaceRecognitionMsgPolyModel *model = [[YXFaceRecognitionMsgPolyModel alloc] initWithDic:dic];
        
        [dataAry addObject:model];
    }
    return dataAry;
}

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    
    if (self) {
        _classId = [[dic objectForKey:@"class_id"] integerValue];
        _score = [[dic objectForKey:@"score"] floatValue];
        _left = [[dic objectForKey:@"left"] floatValue];
        _top = [[dic objectForKey:@"top"] floatValue];
        _right = [[dic objectForKey:@"right"] floatValue];
        _bottom = [[dic objectForKey:@"bottom"] floatValue];
        _point = [YXFaceRecognitionMsgArrLoactionModel ournerArrayOfModelsFromDictionaries:[dic objectForKey:@"point"]];
    }
    return self;
}

@end

#pragma mark - 毛孔或黑头圆心点及半径
@implementation YXFaceRecognitionMsgCirclesModel

+ (NSMutableArray *)arrayOfModelsFromDictionaries:(NSArray *)arr {
    
    NSMutableArray *dataAry = [NSMutableArray array];
    for (NSDictionary *dic in arr) {
        YXFaceRecognitionMsgCirclesModel *model = [[YXFaceRecognitionMsgCirclesModel alloc] initWithDic:dic];
        
        [dataAry addObject:model];
    }
    return dataAry;
}

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    
    if (self) {
        _blackhead = [YXFaceRecognitionMsgArrLoactionModel ournerArrayOfModelsFromDictionaries:[dic objectForKey:@"blackhead"]];
        _pore = [YXFaceRecognitionMsgArrLoactionModel ournerArrayOfModelsFromDictionaries:[dic objectForKey:@"pore"]];
    }
    return self;
}

@end

#pragma mark - 皮肤健康检测
@implementation YXFaceRecognitionMsgSkinfaceModel

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    
    if (self) {
        _skinHealthCheckImages = [[dic objectForKey:@"skin_health_check_images"] objectForKey:@"brown_pic"];
    }
    return self;
}

@end

#pragma mark - 坐标数组信息
@implementation YXFaceRecognitionMsgArrLoactionModel

+ (NSMutableArray *)arrayOfModelsFromDictionaries:(NSArray *)arr {
    
    NSMutableArray *dataAry = [NSMutableArray array];
    for (NSArray *arrs in arr) {
        NSArray *endArr = [YXFaceRecognitionMsgArrLoactionModel ournerArrayOfModelsFromDictionaries:arrs];
        
        [dataAry addObject:endArr];
    }
    return dataAry;
}

+ (NSMutableArray *)ournerArrayOfModelsFromDictionaries:(NSArray *)arr {
    
    NSMutableArray *dataAry = [NSMutableArray array];
    for (NSDictionary *dic in arr) {
        YXFaceRecognitionMsgArrLoactionModel *model = [[YXFaceRecognitionMsgArrLoactionModel alloc] initWithDic:dic];
        
        [dataAry addObject:model];
    }
    return dataAry;
}

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    
    if (self) {
        _x = [[dic objectForKey:@"x"] floatValue];
        _y = [[dic objectForKey:@"y"] floatValue];
        _r = [[dic objectForKey:@"r"] floatValue];
    }
    return self;
}

@end
