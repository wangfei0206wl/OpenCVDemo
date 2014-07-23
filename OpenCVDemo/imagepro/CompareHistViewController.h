//
//  CompareHistViewController.h
//  OpenCVDemo
//
//  Created by wangfei on 14-7-22.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import "BaseViewController.h"

/*
 直方图比较
 1、compareHist 直方图比较(四种比较方法)
 函数说明
 1、compareHist 直方图比较
    原型
    CV_EXPORTS_W double compareHist( InputArray H1, InputArray H2, int method);
    H1: 待比较的直方图1
    H2: 待比较的直方图2
    method: 比较方法
            0: Correlation 值越大越相似，范围[0, 1]
            1: Chi-square 值越小越相似
            2: Intersection 值越大越相似
            3: Bhattacharyya 值越小越相似
 */
@interface CompareHistViewController : BaseViewController

@end
