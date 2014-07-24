//
//  ConvexHullViewController.h
//  OpenCVDemo
//
//  Created by wangfei on 14-7-24.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import "BaseViewController.h"

/*
 计算物体的凸包
 1、转换为灰度图
 2、对图像进行降噪
 3、对图像进行二值化
 4、寻找轮廓
 5、对每个轮廓计算凸包
 6、绘制轮廓及凸包
 
 函数说明
 1、convexHull 轮廓计算凸包
    原型
    CV_EXPORTS_W void convexHull( InputArray points, OutputArray hull, 
                                    bool clockwise=false, bool returnPoints=true );
    points: 输入轮廓
    hull: 输出计算的凸包
 */
@interface ConvexHullViewController : BaseViewController

@end
