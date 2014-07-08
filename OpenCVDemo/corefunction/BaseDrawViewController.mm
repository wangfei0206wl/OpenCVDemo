//
//  BaseDrawViewController.m
//  OpenCVDemo
//
//  Created by wangfei on 14-7-7.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import "BaseDrawViewController.h"
#import "WebViewController.h"
#import "PublicDefines.h"
#import "OpenCVUtility.h"

@interface BaseDrawViewController () {
    UIImageView *_picImageView;
}

@end

@implementation BaseDrawViewController

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
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 400);
    [self.view addSubview:scrollView];
    
    CGFloat offsetY = 20;
    UIButton *btnTestInit = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTestInit.frame = CGRectMake(30, offsetY, 120, 30);
    [btnTestInit setTitle:@"画线" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(drawLine) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btnTestInit];
    
    btnTestInit = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTestInit.frame = CGRectMake(170, offsetY, 120, 30);
    [btnTestInit setTitle:@"画椭圆" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(drawEllipse) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btnTestInit];

    offsetY += 30;
    btnTestInit = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTestInit.frame = CGRectMake(30, offsetY, 120, 30);
    [btnTestInit setTitle:@"画矩形" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(drawRectangle) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btnTestInit];
    
    btnTestInit = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTestInit.frame = CGRectMake(170, offsetY, 120, 30);
    [btnTestInit setTitle:@"画圆" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(drawCircle) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btnTestInit];
    
    offsetY += 30;
    btnTestInit = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTestInit.frame = CGRectMake(30, offsetY, 120, 30);
    [btnTestInit setTitle:@"画多边形" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(drawPoly) forControlEvents:UIControlEventTouchUpInside];
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
    [self setTitle:@"基本绘图"];
    [self createRightButton];
    [self createViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drawLine {
    Mat rookImage = Mat::zeros(260, 260, CV_8UC3);
    
    // 画线
    line(rookImage, cv::Point(20, 20), cv::Point(20, 240), Scalar(255, 0, 0), 1, 8);
    line(rookImage, cv::Point(20, 240), cv::Point(240, 240), Scalar(0, 255 ,0), 1, 8);
    line(rookImage, cv::Point(240, 240), cv::Point(20, 20), Scalar(0, 0, 255), 1, 8);
    
    _picImageView.image = [OpenCVUtility MatToUIImage:rookImage];
}

- (void)drawEllipse {
    Mat rookImage = Mat::zeros(260, 260, CV_8UC3);
    
    // 画椭圆
    ellipse(rookImage, cv::Point(rookImage.rows / 2, rookImage.cols / 2), cv::Size(rookImage.rows / 4, rookImage.cols / 8), 0, 0, 360, Scalar(255, 0, 0), 1, 8);
   
    _picImageView.image = [OpenCVUtility MatToUIImage:rookImage];
}

- (void)drawRectangle {
    Mat rookImage = Mat::zeros(260, 260, CV_8UC3);
    
    // 画矩形
    rectangle(rookImage, cv::Point(40, 40), cv::Point(220, 220), Scalar(255, 0 , 0));
    
    _picImageView.image = [OpenCVUtility MatToUIImage:rookImage];
}

- (void)drawCircle {
    Mat rookImage = Mat::zeros(260, 260, CV_8UC3);
    
    // 画圆
    circle(rookImage, cv::Point(130, 130), 100, Scalar(255, 0, 0));
    
    _picImageView.image = [OpenCVUtility MatToUIImage:rookImage];
}

- (void)drawPoly {
    Mat rookImage = Mat::zeros(260, 260, CV_8UC3);

    // 画多边形
    cv::Point rookPoints[1][5] = {cv::Point(20, 20), cv::Point(20, 150), cv::Point(100, 200), cv::Point(180, 240), cv::Point(150, 150)};
    const cv::Point *ppt[1] = {rookPoints[0]};
    int npt[] = {5};
    fillPoly(rookImage, ppt, npt, 1, Scalar(255, 255, 255));
    
    _picImageView.image = [OpenCVUtility MatToUIImage:rookImage];
}

- (void)onClickStudy {
    [super onClickStudy];
    
    WebViewController *controller = [[WebViewController alloc] init];
    controller.titleString = @"基本绘图";
    controller.urlString = @"http://www.opencv.org.cn/opencvdoc/2.3.2/html/doc/tutorials/core/basic_geometric_drawing/basic_geometric_drawing.html#drawing-1";
    [self.navigationController pushViewController:controller animated:YES];
}

@end
