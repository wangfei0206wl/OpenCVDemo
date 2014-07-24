//
//  BoundsViewController.h
//  OpenCVDemo
//
//  Created by wangfei on 14-7-24.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import "BaseViewController.h"

/*
 创建包围轮廓的矩形和圆形边界框
 1、boundingRect 计算包围轮廓的矩形框
 2、minEnclosingCircle 计算完全包围已有轮廓最小圆
 
 步骤:
 1、转换为灰度图
 2、对图像进行降噪
 3、对图像进行二值化
 4、寻找轮廓
 5、多边形逼近轮廓，获取矩形边界框 approxPolyDP, boundingRect
 6、获取圆形边界框 minEnclosingCircle
 7、绘制多边形轮廓、包围的矩形边框、圆形边框
 
 函数说明
 1、approxPolyDP 计算包围轮廓的多边形
    原型
    CV_EXPORTS_W void approxPolyDP( InputArray curve, OutputArray approxCurve, double epsilon, bool closed );
    curve: 轮廓矩阵
    approxCurve: 多边形矩阵
 2、boundingRect 计算包围多边形的矩形
    原型
    CV_EXPORTS_W Rect boundingRect( InputArray points );
    points: 输入的多边形
    返回: 包围的矩形
 3、minEnclosingCircle 计算最小包围多边形的圆形
    原型
    CV_EXPORTS_W void minEnclosingCircle( InputArray points, CV_OUT Point2f& center, CV_OUT float& radius );
    points: 多边形
    center: 圆的中心点
    radius: 圆的半径
 */
@interface BoundsViewController : BaseViewController

@end
