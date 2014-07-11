//
//  MorphoViewController.h
//  OpenCVDemo
//
//  Created by wangfei on 14-7-11.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import "BaseViewController.h"

/*
 更多形态学
 1、开运算 (先腐蚀再膨胀 --- 去除亮块)
 2、闭运算 (先膨胀再腐蚀 --- 去除暗块)
 3、形态梯度 (膨胀图与腐蚀图之差 --- 寻找物体边缘)
 4、顶帽 (原图像与开运算之差)
 5、黑帽 (闭运算与原图像之差)
 */
@interface MorphoViewController : BaseViewController

@end
