//
//  SobelViewController.m
//  OpenCVDemo
//
//  Created by wangfei on 14-7-16.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import "SobelViewController.h"
#import "WebViewController.h"
#import "PublicDefines.h"
#import "OpenCVUtility.h"

@interface SobelViewController () {
    UIImageView *_picImageView;

    // 原始图像
    Mat _srcImage;
}

@end

@implementation SobelViewController

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
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 360);
    [self.view addSubview:scrollView];
    
    CGFloat offsetY = 20;
    UIButton *btnTestInit = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTestInit.frame = CGRectMake(30, offsetY, SCREEN_WIDTH - 60, 30);
    [btnTestInit setTitle:@"加载图片" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(loadPic) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btnTestInit];
    
    offsetY += 30;
    btnTestInit = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTestInit.frame = CGRectMake(30, offsetY, SCREEN_WIDTH - 60, 30);
    [btnTestInit setTitle:@"Sobel一阶求导" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(onClickSobel) forControlEvents:UIControlEventTouchUpInside];
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
    [self setTitle:@"Sobel导数"];
    [self createRightButton];
    [self createViews];
    
    /*
     1、对原图做高斯滤波
     2、将图像转换为灰度图
     */
    _srcImage = [OpenCVUtility UIImageToMat:[UIImage imageNamed:@"lena.jpg"]];
    GaussianBlur(_srcImage, _srcImage, cv::Size(3, 3), 0, 0, BORDER_DEFAULT);
    cvtColor(_srcImage, _srcImage, CV_RGB2GRAY);
    
    _picImageView.image = [OpenCVUtility MatToUIImage:_srcImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadPic {
    _picImageView.image = [OpenCVUtility MatToUIImage:_srcImage];
}

- (void)onClickSobel {
    int ddepth = CV_16S;
    Mat dst;
    Mat grad_x, grad_y;
    Mat abs_grad_x, abs_grad_y;
    
    // 求x方向导数
    /*
     参数：
     原图像, 目标图像, 图像深度, x方向阶数, y方向阶数, 核大小, 缩放比例, delta, ..
     */
    Sobel(_srcImage, grad_x, ddepth, 1, 0, 3, 1, 0, BORDER_DEFAULT);
    convertScaleAbs(grad_x, abs_grad_x);
    
    // 求y方向导数
    Sobel(_srcImage, grad_y, ddepth, 0, 1, 3, 1, 0, BORDER_DEFAULT);
    convertScaleAbs(grad_y, abs_grad_y);
    
    // 合并梯度
    addWeighted(abs_grad_x, 0.5, abs_grad_y, 0.5, 0, dst);
    
    _picImageView.image = [OpenCVUtility MatToUIImage:dst];
}

- (void)onClickStudy {
    [super onClickStudy];
    
    WebViewController *controller = [[WebViewController alloc] init];
    controller.titleString = @"Sobel导数";
    controller.urlString = @"http://www.opencv.org.cn/opencvdoc/2.3.2/html/doc/tutorials/imgproc/imgtrans/sobel_derivatives/sobel_derivatives.html#sobel-derivatives";
    [self.navigationController pushViewController:controller animated:YES];
}

@end
