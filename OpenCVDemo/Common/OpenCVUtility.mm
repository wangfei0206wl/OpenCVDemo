//
//  OpenCVUtility.m
//  OpenCVDemo
//
//  Created by wangfei on 14-7-3.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import "OpenCVUtility.h"

@implementation OpenCVUtility

+ (UIImage *)MatToUIImage:(const cv::Mat&)m {
//    CV_Assert(m.depth() == CV_8U);
    NSData *data = [NSData dataWithBytes:m.data length:m.step * m.rows];
    CGColorSpaceRef colorSpace = m.channels() == 1?CGColorSpaceCreateDeviceGray():CGColorSpaceCreateDeviceRGB();
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(m.cols, m.rows, m.elemSize1() * 8, m.elemSize() * 8,
                                        m.step[0], colorSpace, kCGImageAlphaNoneSkipLast | kCGBitmapByteOrderDefault,
                                        provider, NULL, false, kCGRenderingIntentDefault);
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    return finalImage;
}

+ (cv::Mat)UIImageToMat:(const UIImage *)image {
    cv::Mat m;
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    m.create(rows, cols, CV_8UC4); // 8 bits per component, 4 channels
    CGContextRef contextRef = CGBitmapContextCreate(m.data, m.cols, m.rows, 8,
                                                    m.step[0], colorSpace, kCGImageAlphaNoneSkipLast | kCGBitmapByteOrderDefault);
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpace);
    
    return m;
}

@end
