//
//  AreaRectViewController.h
//  OpenCVDemo
//
//  Created by wangfei on 14-7-25.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import "BaseViewController.h"

/*
 为轮廓创建可倾斜的边界框和椭圆
 步骤:
 1、转换为灰度图
 2、对图像进行降噪
 3、阈值化边界框
 4、寻找轮廓
 5、对每个找到的轮廓创建可倾斜的边界框 minAreaRect
 6、对每个找到的轮廓创建椭圆 fitEllipse
 7、绘制轮廓、可倾斜边界框、椭圆
 
 函数说明
 1、minAreaRect 根据已知轮廓找到最小合适的矩形边界框(可倾斜)
    原型
    CV_EXPORTS_W RotatedRect minAreaRect( InputArray points );
    points: 输入的已知轮廓
 2、fitEllipse 根据已知轮廓找到最小合适的椭圆
    原型
    CV_EXPORTS_W RotatedRect fitEllipse( InputArray points );
    points: 输入的已知轮廓
 */
@interface AreaRectViewController : BaseViewController

@end
