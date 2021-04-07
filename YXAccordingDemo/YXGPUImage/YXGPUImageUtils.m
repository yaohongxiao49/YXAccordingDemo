//
//  YXGPUImageUtils.m
//  YXGPUImgTest
//
//  Created by ios on 2019/6/12.
//  Copyright © 2019 August. All rights reserved.
//

#import "YXGPUImageUtils.h"

const char *g_effectConfig[] = {
    nil,
    "@curve RGB(0, 255)(255, 0) @style cm mapping0.jpg 80 80 8 3", // ASCII art (字符画效果)
    "@dynamic motionflow 12 0",
    "@dynamic soulstuff 240 320",
    "@adjust lut filmstock.png",
    "@adjust lut soft_warming.png",
    "@adjust lut wildbird.png",
    "@beautify bilateral 10 4 1 @style haze -0.5 -0.5 1 1 1 @curve RGB(0, 0)(94, 20)(160, 168)(255, 255) @curve R(0, 0)(129, 119)(255, 255)B(0, 0)(135, 151)(255, 255)RGB(0, 0)(146, 116)(255, 255)",
    "#unpack @style sketch 0.9",
    "@adjust brightness 0.18 @adjust contrast 1.44 @adjust hsl 0 -0.4 0 @adjust contrast 1.4 @style edge 0.07 0 @style sketch 0.7 @krblend colorburn test1.jpg 70 ",
    "@style edge 1 2 ",
    "@adjust level 0.31 0.54 0.13 ",
    "@adjust exposure 0.98 ",
    "@adjust sharpen 10 1.5 ",
    "@curve R(0, 0)(71, 74)(164, 165)(255, 255) @pixblend screen 0.94118 0.29 0.29 1 20",
    "@curve G(0, 0)(144, 166)(255, 255) @pixblend screen 0.94118 0.29 0.29 1 20",
    "@curve B(0, 0)(68, 72)(149, 184)(255, 255) @pixblend screen 0.94118 0.29 0.29 1 20",
    "@curve R(0, 0)(152, 183)(255, 255)G(0, 0)(161, 133)(255, 255) @pixblend overlay 0.357 0.863 0.882 1 40",
    "@curve G(0, 0)(101, 127)(255, 255) @pixblend colordodge 0.937 0.482 0.835 1 20",
    "@curve R(0, 0)(53, 28)(172, 203)(255, 255)",
    "@adjust saturation 0.7 @pixblend screen 0.8112 0.243 1 1 40",
    "@curve G(0, 0)(101, 127)(255, 255) @pixblend colordodge 0.937 0.482 0.835 1 20",
    "@curve B(0, 0)(70, 87)(140, 191)(255, 255) @pixblend pinlight 0.247 0.49 0.894 1 20",
    "@curve R(0, 0)(53, 28)(172, 203)(255, 255)",
    "@curve R(0, 0)(43, 77)(56, 104)(100, 166)(255, 255)G(0, 0)(35, 53)(255, 255)B(0, 0)(110, 123)(255, 212)",
    "@curve R(48, 56)(82, 129)(130, 206)(214, 255)G(7, 37)(64, 111)(140, 190)(232, 220)B(2, 97)(114, 153)(229, 172)",
    "@adjust hsv -0.8 0 -0.8 -0.8 0.5 -0.8 @pixblend ol 0.78036 0.70978 0.09018 1 28",
    
    "@special 21",
    "@adjust hsv -0.4 -0.64 -1.0 -0.4 -0.88 -0.88 @curve R(0, 0)(119, 160)(255, 255)G(0, 0)(83, 65)(163, 170)(255, 255)B(0, 0)(147, 131)(255, 255)",
    "@curve R(5, 8)(36, 51)(115, 145)(201, 220)(255, 255)G(6, 9)(67, 83)(169, 190)(255, 255)B(3, 3)(55, 60)(177, 190)(255, 255)",
};

int g_configNum = sizeof(g_effectConfig) /sizeof(*g_effectConfig);

UIImage *loadImageCallback(const char *name, void *arg) {
    
    NSString *filename = [NSString stringWithUTF8String:name];
    return [UIImage imageNamed:filename];
}

void loadImageOKCallback(UIImage *img, void *arg) {
    
}

@implementation YXGPUImageUtils

@end
