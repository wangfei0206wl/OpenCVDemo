//
//  LaplacianViewController.h
//  OpenCVDemo
//
//  Created by wangfei on 14-7-16.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import "BaseViewController.h"

/*
 Laplace算子
 1、Laplace对图像进行二阶求导，找到值为0的地方(去掉无效点)，以此进行边缘检测
 函数: Laplacian
 */
@interface LaplacianViewController : BaseViewController

@end
