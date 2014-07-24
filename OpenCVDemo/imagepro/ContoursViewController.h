//
//  ContoursViewController.h
//  OpenCVDemo
//
//  Created by wangfei on 14-7-24.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import "BaseViewController.h"

/*
 在图像中寻找轮廓
 1、对图像降噪
 2、转换图像为灰度图
 3、对图像进行边缘检测
 4、使用findContours查找轮廓
 5、使用drawContours绘制轮廓
 
 函数说明
 1、Canny 对灰度图做边缘检测
    原型
    CV_EXPORTS_W void Canny( InputArray image, OutputArray edges, double threshold1, double threshold2,
                            int apertureSize=3, bool L2gradient=false);
    image: 源图像(灰度图)
    edges: 边缘检测结果图像
    threshold1: 最低阈值
    threshold2: 最大阈值
    apertureSize: sobel算子矩阵尺寸
 2、findContours 寻找轮廓
    原型
    CV_EXPORTS_W void findContours( InputOutputArray image, OutputArrayOfArrays contours,
                                    OutputArray hierarchy, int mode, int method, Point offset=Point());
    image: 源图像(边缘检测后的灰度图)
    contours: 轮廓矩阵
    hierarchy: 
    mode: 
    method: 方法
 3、drawContours 绘制轮廓
    原型
    CV_EXPORTS_W void drawContours( InputOutputArray image, InputArrayOfArrays contours, int contourIdx,            
                                    const Scalar& color, int thickness=1, int lineType=8, 
                                    InputArray hierarchy=noArray(),
                                    int maxLevel=INT_MAX, Point offset=Point() );
    image: 画布的图像矩阵
    contours: 轮廓矩阵
    contourIdx: 矩阵索引
    color: 绘制颜色
    thickness: 线粗线
    lineType: 线的类型
    hierarchy:
 */
@interface ContoursViewController : BaseViewController

@end
