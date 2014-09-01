//
//  VideoCmpViewController.h
//  OpenCVDemo
//
//  Created by wangfei on 14-8-14.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import "BaseViewController.h"

/*
 视频相似度测量 ---- 图像比较
 检查压缩视频带来的细微差异，构建一个能逐帧比较视频差异的系统
 1、PSNR
    最常用的比较算法
    使用局部均值误差来判断差异
 2、SSIM
    能产生更优秀的数据
    但由于高斯模糊很花时间，不太常用
 
 */
@interface VideoCmpViewController : BaseViewController

@end
