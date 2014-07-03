//
//  BaseViewController.h
//  TestProject
//
//  Created by wangfei on 14-5-12.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property (nonatomic, retain) UIView *naviView;
@property (nonatomic, retain) UIView *contentView;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UIButton *btnBack;
@property (nonatomic, assign) BOOL noBtnBack;
@property (nonatomic, retain) UIImageView *titleImageView;

- (void)createRightButton;
- (void)onClickBack;
- (void)showTitleBk;
- (void)onClickStudy;

@end
