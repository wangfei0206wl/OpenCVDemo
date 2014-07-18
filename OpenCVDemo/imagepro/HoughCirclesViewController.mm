//
//  HoughCirclesViewController.m
//  OpenCVDemo
//
//  Created by wangfei on 14-7-18.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import "HoughCirclesViewController.h"
#import "WebViewController.h"
#import "PublicDefines.h"
#import "OpenCVUtility.h"

@interface HoughCirclesViewController () {
    UIImageView *_picImageView;

    // 原始图像
    Mat _srcImage;
}

@end

@implementation HoughCirclesViewController

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
    [btnTestInit setTitle:@"标准霍夫圆变换" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(onClickHoughCircles) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btnTestInit];
    
    offsetY += 40;
    _picImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, offsetY, (SCREEN_WIDTH - 60), (SCREEN_WIDTH - 60))];
    _picImageView.contentMode = UIViewContentModeCenter;
    [scrollView addSubview:_picImageView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"霍夫圆变换"];
    [self createRightButton];
    [self createViews];

    _picImageView.image = [UIImage imageNamed:@"circles.jpg"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadPic {
    _picImageView.image = [UIImage imageNamed:@"circles.jpg"];
}

- (void)onClickHoughCircles {
    Mat dst;
    cv::vector<cv::Vec3f> circles;
    
    _srcImage = [OpenCVUtility UIImageToMat:[UIImage imageNamed:@"circles.jpg"]];
    dst = _srcImage.clone();
    // 高斯平滑降噪
    cvtColor(_srcImage, _srcImage, CV_RGB2GRAY);
    GaussianBlur(_srcImage, _srcImage, cv::Size(3, 3), 0, 0, BORDER_DEFAULT);

    // 使用霍夫梯度法实现霍夫圆变换
    HoughCircles(_srcImage, circles, CV_HOUGH_GRADIENT, 1, _srcImage.rows / 8, 200, 50, 0, 0);
    
    for (int i = 0; i < circles.size(); i++) {
        cv::Point center(cvRound(circles[i][0]), cvRound(circles[i][1]));
        int radius = cvRound(circles[i][2]);
        
        // 绘制圆心
        circle(dst, center, 3, Scalar(0, 255, 0), -1, 8, 0);
        // 绘制圆
        circle(dst, center, radius, Scalar(0, 0, 255), 3, 8, 0);
    }
    
    _picImageView.image = [OpenCVUtility MatToUIImage:dst];
}

- (void)onClickStudy {
    [super onClickStudy];
    
    WebViewController *controller = [[WebViewController alloc] init];
    controller.titleString = @"霍夫圆变换";
    controller.urlString = @"http://www.opencv.org.cn/opencvdoc/2.3.2/html/doc/tutorials/imgproc/imgtrans/hough_circle/hough_circle.html#hough-circle";
    [self.navigationController pushViewController:controller animated:YES];
}

@end
