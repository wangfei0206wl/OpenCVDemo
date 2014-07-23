//
//  BackProjectViewController.h
//  OpenCVDemo
//
//  Created by wangfei on 14-7-23.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import "BaseViewController.h"

/*
 反向投影
 1、calcBackProject 计算反向投影
 2、mixChannels 组合图像的不同通道
 函数说明
 1、calcBackProject 计算反向投影
    原型
    CV_EXPORTS void calcBackProject( const Mat* images, int nimages, const int* channels, InputArray hist,
                                    OutputArray backProject, const float** ranges,double scale=1, bool uniform=true );
    images: 输入图像矩阵数组
    nimages: 输入图像矩阵数组中矩阵个数
    channels: 需要统计的通道索引(对于单通道的Mat, 此参数为0)
    hist: 直方图的矩阵
    backProject: 反向投影图像矩阵
    ranges: 每个维度的取值范围
    scale: 缩放尺寸
 2、mixChannels 抽取图像通道
    原型
    CV_EXPORTS void mixChannels(const Mat* src, size_t nsrcs, Mat* dst, size_t ndsts, const int* fromTo,
                                size_t npairs);
    src: 输入图像矩阵数组
    nsrcs: 输入图像矩阵数组中矩阵个数
    dst: 输出拷贝的通道数组
    ndsts: 输出通道数组中矩阵个数
    fromTo: 通道索引对的数组(如: {0, 0} 源矩阵0通道到输出矩阵0通道)
    npairs: 通道索引对的个数
 */
@interface BackProjectViewController : BaseViewController

@end
