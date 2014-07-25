//
//  ContoursAreaViewController.h
//  OpenCVDemo
//
//  Created by wangfei on 14-7-25.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import "BaseViewController.h"

/*
 轮廓矩
 步骤:
 1、图像转换为灰度图
 2、对图像进行降噪
 3、使用canny进行边缘检测
 4、寻找轮廓
 5、计算矩
 6、计算中心矩
 7、绘制轮廓及中心矩
 8、计算轮廓面积和轮廓周长
 
 函数说明
 1、moments 根据轮廓获取对应的矩
    原型
    CV_EXPORTS_W Moments moments( InputArray array, bool binaryImage=false );
    array: 输入轮廓
    返回: 矩
 2、contourArea 计算轮廓面积
    原型
    CV_EXPORTS_W double contourArea( InputArray contour, bool oriented=false );
    contour: 输入轮廓
    返回: 轮廓面积
 3、arcLength 计算轮廓周长
    原型
    CV_EXPORTS_W double arcLength( InputArray curve, bool closed );
    curve: 输入轮廓
    返回: 轮廓周长
 */
@interface ContoursAreaViewController : BaseViewController

@end
