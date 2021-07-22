//
//  YXFaceRecognitionAnimationView.h
//  YXAccordingDemo
//
//  Created by ios on 2021/7/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXFaceRecognitionAnimationView : UIView

/** 皮肤分析 */
@property (weak, nonatomic) IBOutlet UILabel *skinLab;
@property (weak, nonatomic) IBOutlet UILabel *skinPointLab;
/** 痘痘分析 */
@property (weak, nonatomic) IBOutlet UILabel *acneLab;
@property (weak, nonatomic) IBOutlet UILabel *acnePointLab;
/** 斑印分析 */
@property (weak, nonatomic) IBOutlet UILabel *spotsLab;
@property (weak, nonatomic) IBOutlet UILabel *spotsPointLab;
/** 皱纹分析 */
@property (weak, nonatomic) IBOutlet UILabel *wrinklesLab;
@property (weak, nonatomic) IBOutlet UILabel *wrinklesPointLab;
/** 眼袋分析 */
@property (weak, nonatomic) IBOutlet UILabel *bagsLab;
@property (weak, nonatomic) IBOutlet UILabel *bagsPointLab;
/** 眼睛分析 */
@property (weak, nonatomic) IBOutlet UILabel *eyesLab;
@property (weak, nonatomic) IBOutlet UILabel *eyesPointLab;
/** 黑头分析 */
@property (weak, nonatomic) IBOutlet UILabel *blackheadsLab;
@property (weak, nonatomic) IBOutlet UILabel *blackheadsPointLab;
/** 毛孔分析 */
@property (weak, nonatomic) IBOutlet UILabel *poresLab;
@property (weak, nonatomic) IBOutlet UILabel *poresPointLab;

@end

NS_ASSUME_NONNULL_END
