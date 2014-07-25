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
 */
@interface ContoursAreaViewController : BaseViewController

@end
