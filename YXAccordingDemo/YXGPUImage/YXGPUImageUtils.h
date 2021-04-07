//
//  YXGPUImageUtils.h
//  YXGPUImgTest
//
//  Created by ios on 2019/6/12.
//  Copyright © 2019 August. All rights reserved.
//
/// GPUImage使用

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <cge/cge.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

#define kMediaUrl @"mediaUrl"
#define kMediaMute @"MediaMute"

extern const char * _Nonnull g_effectConfig[];
extern int g_configNum;

UIImage *loadImageCallback(const char *name, void *arg);
void loadImageOKCallback(UIImage *img, void *arg);

@interface YXGPUImageUtils : NSObject

@end

NS_ASSUME_NONNULL_END
