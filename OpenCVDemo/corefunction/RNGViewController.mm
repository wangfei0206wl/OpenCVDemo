//
//  RNGViewController.m
//  OpenCVDemo
//
//  Created by wangfei on 14-7-8.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import "RNGViewController.h"
#import "WebViewController.h"
#import "PublicDefines.h"
#import "OpenCVUtility.h"

@interface RNGViewController () {
    UIImageView *_picImageView;
}

@end

@implementation RNGViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)createViews {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, IOS7?64:44, SCREEN_WIDTH, self.contentView.frame.size.height)];
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 340);
    [self.view addSubview:scrollView];
    
    CGFloat offsetY = 20;
    UIButton *btnTestInit = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTestInit.frame = CGRectMake(30, offsetY, (SCREEN_WIDTH - 60), 30);
    [btnTestInit setTitle:@"随机绘制文本" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(drawTextWithRNG) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btnTestInit];
    
    offsetY += 40;
    _picImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, offsetY, (SCREEN_WIDTH - 60), (SCREEN_WIDTH - 60))];
    _picImageView.contentMode = UIViewContentModeScaleAspectFit;
    [scrollView addSubview:_picImageView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"随机数发生器&绘制文字"];
    [self createRightButton];
    [self createViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drawTextWithRNG {
    cv::RNG rng(0xFFFFFFFF);
    int icolor = (unsigned)rng;
    Scalar color = Scalar(icolor & 255, (icolor >> 8) & 255, (icolor >> 16) & 255);
    int fontFace = rng.uniform(0, 8);
    int fontScale = rng.uniform(0, 100) * 0.05 + 0.1;
    cv::Point fontPoint = cv::Point(rng.uniform(20, 240), rng.uniform(20, 240));
    
    Mat image = Mat::zeros(260, 260, CV_8UC3);
    
    // 绘制文字
    putText(image, "Hello Kitty", fontPoint, fontFace, fontScale, color);
    
    _picImageView.image = [OpenCVUtility MatToUIImage:image];
}

- (void)onClickStudy {
    [super onClickStudy];
    
    WebViewController *controller = [[WebViewController alloc] init];
    controller.titleString = @"随机数发生器&绘制文字";
    controller.urlString = @"http://www.opencv.org.cn/opencvdoc/2.3.2/html/doc/tutorials/core/random_generator_and_text/random_generator_and_text.html#drawing-2";
    [self.navigationController pushViewController:controller animated:YES];
}

@end
