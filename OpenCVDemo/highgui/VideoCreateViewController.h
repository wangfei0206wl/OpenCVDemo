//
//  VideoCreateViewController.h
//  OpenCVDemo
//
//  Created by wangfei on 14-9-2.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import "BaseViewController.h"

/*
 opencv创建视频
 这里代码只做参考，因opencv对于视频的支持不是很好，只支持avi格式的视频，并且创建的视频大小不能超过2G
 不知道为什么，VideoCapture类能打开文件，但获取的视频信息都是无效。
 如果要做视频相关处理，请使用ffmpeg类似的开源库。
 opencv只是针对形态学处理的库，对于的视频的支持比较差。
 
 VideoCapture   用于打开一个视频
 VideoWriter    用于创建一个视频
 */
@interface VideoCreateViewController : BaseViewController

@end
