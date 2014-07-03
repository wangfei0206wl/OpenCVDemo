//
//  BaseViewController.m
//  TestProject
//
//  Created by wangfei on 14-5-12.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import "BaseViewController.h"
#import "PublicDefines.h"

@interface BaseViewController () {
    UISwipeGestureRecognizer *_leftSwipeGesture;
}

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:YES];

    // 内容视图
    CGFloat offsetY = IOS7?(STATUS_HEIGHT + NAVIGATIONBAR_HEIGHT):NAVIGATIONBAR_HEIGHT;
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, offsetY, SCREEN_WIDTH, self.view.frame.size.height - offsetY)];
    _contentView.backgroundColor = UIColorFromRGB(0xfbfbfb);
    [self.view addSubview:_contentView];
    //视图上添加左滑事件，返回上一级
    _leftSwipeGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(onClickBack)];
    _leftSwipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [_contentView addGestureRecognizer:_leftSwipeGesture];
   
    // 状态栏
    if (IOS7) {
        UIView *statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, STATUS_HEIGHT)];
        statusView.backgroundColor = UIColorFromRGB(0xf4f4f4);
        [self.view addSubview:statusView];
    }

    // 导航栏
    _naviView = [[UIView alloc] initWithFrame:CGRectMake(0, IOS7?STATUS_HEIGHT:0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT)];
    _naviView.backgroundColor = UIColorFromRGB(0xf4f4f4);//UIColorFromRGB(0x44cc8a);//
    [self.view addSubview:_naviView];

    if (_noBtnBack == NO) {
        //定制返回按钮
        _btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnBack.frame = CGRectMake(0, 0, 44, 44);
        [_btnBack setImage:[UIImage imageNamed:@"common_bacArrow"] forState:UIControlStateNormal];
//        [_btnBack setImage:[UIImage imageNamed:@"btn_cancel_pressed"] forState:UIControlStateHighlighted];
        [_btnBack addTarget:self action:@selector(onClickBack) forControlEvents:UIControlEventTouchUpInside];
        [_naviView addSubview:_btnBack];
    }
    
//    // 标题上方面图片
//    _titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 80) / 2, 0, 80, 44)];
//    _titleImageView.image = [UIImage imageNamed:@"image_title_bk"];
//    _titleImageView.contentMode = UIViewContentModeCenter;
//    [_naviView addSubview:_titleImageView];
//    _titleImageView.hidden = YES;
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 12, SCREEN_WIDTH - 60, 20)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    _titleLabel.textColor = UIColorFromRGB(TEXT_NORMAL_COLOR);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_naviView addSubview:_titleLabel];
    
    // 下方线
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 43, SCREEN_WIDTH, 1)];
    lineView.backgroundColor = UIColorFromRGB(0x485e73);
    [_naviView addSubview:lineView];
}

- (void)setTitle:(NSString *)title {
    _titleLabel.text = title;
}

- (void)createRightButton {
    // 显示web
    UIButton *btnWebView = [UIButton buttonWithType:UIButtonTypeSystem];
    btnWebView.frame = CGRectMake(SCREEN_WIDTH - 60, 0, 60, 44);
    [btnWebView setTitle:@"学习" forState:UIControlStateNormal];
    [btnWebView setTitleColor:UIColorFromRGB(TEXT_NORMAL_COLOR) forState:UIControlStateNormal];
    [btnWebView addTarget:self action:@selector(onClickStudy) forControlEvents:UIControlEventTouchUpInside];
    [self.naviView addSubview:btnWebView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onClickBack {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)showTitleBk {
    _titleImageView.hidden = NO;
}

- (void)onClickStudy {
    
}

@end
