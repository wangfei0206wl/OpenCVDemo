//
//  MatchTempViewController.h
//  OpenCVDemo
//
//  Created by wangfei on 14-7-23.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import "BaseViewController.h"

/*
 模板匹配
    将模板图像按像素滑过原图像，计算每个位置对应的匹配值，得到一个匹配值矩阵.
 6种模板匹配方法(OpenCV目前支持的匹配方法)
    1、平方差匹配(CV_TM_SQDIFF): 模板图像与原图像像素的平方差计算，值越小匹配越好，反之匹配越差
    2、标准平方差匹配(CV_TM_SQDIFF_NORMED): 同上
    3、相关匹配(CV_TM_CCORR): 模板图像与原图像像素的乘法运算，值越大匹配越好，反之匹配越差
    4、标准相关切匹配(CV_TM_CCORR_NORMED): 同上
    5、相关匹配(CV_TM_CCOEFF): 模板对其均值的相对值与原图像对其均值的相关值进行匹配，1表示完美匹配，-1为最差匹配
    6、标准相关匹配(CV_TM_CCOEFF_NORMED): 同上
 函数说明
    1、matchTemplate 图像模板匹配
        原型
        CV_EXPORTS_W void matchTemplate( InputArray image, InputArray templ,
                                        OutputArray result, int method );
        image: 原图像矩阵
        templ: 匹配模板矩阵
        result: 匹配相似值矩阵
        method: 匹配方法(上面介绍的6种方法)
    2、minMaxLoc 确定矩阵中极值及极值的位置
        原型
        CV_EXPORTS_W void minMaxLoc(InputArray src, CV_OUT double* minVal, CV_OUT double* maxVal=0, 
                                    CV_OUT Point* minLoc=0, CV_OUT Point* maxLoc=0, InputArray mask=noArray());
        src: 原图像矩阵
        minVal: 矩阵最小值
        maxVal: 矩阵最大值
        minLoc: 矩阵最小值位置
        maxLoc: 矩阵最大值位置
        mask: 矩阵掩码
 */
@interface MatchTempViewController : BaseViewController

@end
