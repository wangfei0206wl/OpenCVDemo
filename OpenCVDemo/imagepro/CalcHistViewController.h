//
//  CalcHistViewController.h
//  OpenCVDemo
//
//  Created by wangfei on 14-7-22.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import "BaseViewController.h"

/*
 直方图计算
 1、split 多通道分割
 2、calcHist 直方图计算
 3、normalize 归一化数组
 函数说明
 1、split 用于分享多通道图像为多个单通道矩阵
     原型
     CV_EXPORTS void split(const Mat& m, vector<Mat>& mv);
     m: 输入图像矩阵
     mv: 分隔出单通道图像矩阵
 2、calcHist 直方图计算
     原型
     CV_EXPORTS void calcHist( const Mat* images, int nimages, const int* channels, InputArray mask,
                                OutputArray hist, int dims, const int* histSize,
                                const float** ranges, bool uniform=true, bool accumulate=false);
     images: 输入图像矩阵数组
     nimages: 输入图像矩阵数组中矩阵个数
     channels: 需要统计的通道索引(对于单通道的Mat, 此参数为0)
     mask: 掩码(0表示忽略此像素), 如未定义，则不使用掩码
     hist: 储存直方图的矩阵
     dims: 直方图维数
     histSize: 每个维度的bin数目
     ranges: 每个维度的取值范围
 3、normalize 归一化数组
    原型
    CV_EXPORTS_W void normalize( InputArray src, OutputArray dst, double alpha=1, double beta=0,
                                int norm_type=NORM_L2, int dtype=-1, InputArray mask=noArray());
    src: 输入数组
    dst: 输出数组
    alpha: 归一化后的最小值
    beta: 归一化后的最大值
    norm_type: 归一化方法(NORM_MINMAX 将数值缩放到以上指定范围)
    dtype: 指示归一化后的输出数组与输入数组同类型(-1)
    mask: 掩码
 */
@interface CalcHistViewController : BaseViewController

@end
