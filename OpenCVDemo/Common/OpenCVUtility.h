//
//  OpenCVUtility.h
//  OpenCVDemo
//
//  Created by wangfei on 14-7-3.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <opencv2/highgui/cap_ios.h>

using namespace cv;

@interface OpenCVUtility : NSObject

// Mat转image
+ (UIImage *)MatToUIImage:(const cv::Mat&)m;
// image转Mat
+ (cv::Mat)UIImageToMat:(const UIImage *)image;

@end
