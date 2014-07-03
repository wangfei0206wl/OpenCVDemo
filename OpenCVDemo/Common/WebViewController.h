//
//  WebViewController.h
//  OpenCVDemo
//
//  Created by wangfei on 14-7-3.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import "BaseViewController.h"

/*
 显示每一节对应的web讲义
 */
@interface WebViewController : BaseViewController

// 关联的url
@property (nonatomic, retain) NSString *urlString;
// 标题
@property (nonatomic, retain) NSString *titleString;

@end
