//
//  BoundsViewController.m
//  OpenCVDemo
//
//  Created by wangfei on 14-7-24.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import "BoundsViewController.h"
#import "WebViewController.h"
#import "PublicDefines.h"
#import "OpenCVUtility.h"

@interface BoundsViewController () {
    // 原始图像
    UIImageView *_picImageView;
    // low-threshold值
    UILabel *_blurSize;
    // threshold设置
    UISlider *_sizeSlider;

    // 原始图像
    Mat _srcImage;
}

@end

@implementation BoundsViewController

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
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 420);
    [self.view addSubview:scrollView];
    
    CGFloat offsetY = 20;
    UIButton *btnTestInit = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTestInit.frame = CGRectMake(30, offsetY, SCREEN_WIDTH - 60, 30);
    [btnTestInit setTitle:@"加载图片" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(loadPic) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btnTestInit];
    
    offsetY += 30;
    btnTestInit = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTestInit.frame = CGRectMake(30, offsetY, 120, 30);
    [btnTestInit setTitle:@"矩形包围轮廓" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(onClickBoundingRect) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btnTestInit];
    
    btnTestInit = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTestInit.frame = CGRectMake(170, offsetY, 120, 30);
    [btnTestInit setTitle:@"圆形包围轮廓" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(onClickMinCircle) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btnTestInit];
    
    offsetY += 30;
    // 最小值
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, offsetY, 60, 30)];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.textColor = [UIColor blackColor];
    textLabel.font = [UIFont systemFontOfSize:14.0f];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.text = @"50";
    [scrollView addSubview:textLabel];
    
    // 最大值
    textLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 70, offsetY, 60, 30)];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.textColor = [UIColor blackColor];
    textLabel.font = [UIFont systemFontOfSize:14.0f];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.text = @"255";
    [scrollView addSubview:textLabel];
    
    // size
    textLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, offsetY, 160, 30)];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.textColor = [UIColor blackColor];
    textLabel.font = [UIFont systemFontOfSize:14.0f];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.text = @"最低阈值:";
    [scrollView addSubview:textLabel];
    
    // alpha值
    _blurSize = [[UILabel alloc] initWithFrame:CGRectMake(180, offsetY, 40, 30)];
    _blurSize.backgroundColor = [UIColor clearColor];
    _blurSize.textColor = [UIColor blackColor];
    _blurSize.font = [UIFont systemFontOfSize:14.0f];
    _blurSize.textAlignment = NSTextAlignmentCenter;
    _blurSize.text = @"50";
    [scrollView addSubview:_blurSize];
    
    offsetY += 40;
    _sizeSlider = [[UISlider alloc] initWithFrame:CGRectMake(30, offsetY, SCREEN_WIDTH - 60, 20)];
    _sizeSlider.maximumValue = 255.0f; _sizeSlider.minimumValue = 50.0f;
    [scrollView addSubview:_sizeSlider];
    [_sizeSlider addTarget:self action:@selector(sizeValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    offsetY += 40;
    _picImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, offsetY, (SCREEN_WIDTH - 60), (SCREEN_WIDTH - 60))];
    _picImageView.contentMode = UIViewContentModeCenter;
    [scrollView addSubview:_picImageView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"创建包围轮廓的矩形和圆形边界框"];
    [self createRightButton];
    [self createViews];
    
    _srcImage = [OpenCVUtility UIImageToMat:[UIImage imageNamed:@"balloon_demo.jpg"]];
    _picImageView.image = [UIImage imageNamed:@"balloon_demo.jpg"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (int)blurSize {
    int result = (int)_sizeSlider.value;
    
    return result;
}

- (void)loadPic {
    _picImageView.image = [UIImage imageNamed:@"balloon_demo.jpg"];
}

- (void)onClickBoundingRect {
    Mat src_gray;
    
    // 转换为灰度图
    cvtColor(_srcImage, src_gray, CV_BGR2GRAY);
    // 降噪
    blur(src_gray, src_gray, cv::Size(3, 3));
    
    // 图像二值化
    Mat thresh_output;
    threshold(src_gray, thresh_output, [self blurSize], 255, THRESH_BINARY);
    
    // 寻找轮廓
    cv::vector<cv::vector<cv::Point>> contours;
    cv::vector<cv::Vec4i> hierarchy;
    findContours(thresh_output, contours, hierarchy, CV_RETR_TREE, CV_CHAIN_APPROX_SIMPLE, cv::Point(0, 0));
    
    // 多边形逼近轮廓 + 获取矩形边界框
    cv::vector<cv::vector<cv::Point>> contours_poly(contours.size());
    cv::vector<cv::Rect> boundRect(contours.size());
    
    for (int i = 0; i < contours.size(); i++) {
        approxPolyDP(Mat(contours[i]), contours_poly[i], 3, true);
        boundRect[i] = boundingRect(Mat(contours_poly[i]));
    }
    
    // 画多边形轮廓 + 包围的矩形框
    Mat drawing = Mat::zeros(thresh_output.rows, thresh_output.cols, CV_8UC3);
    for (int i = 0; i < contours.size(); i++) {
        drawContours(drawing, contours_poly, i, Scalar::all(255), 1, 8, cv::vector<cv::Vec4i>(), 0, cv::Point());
        rectangle(drawing, boundRect[i].tl(), boundRect[i].br(), Scalar(0, 0, 255), 2, 8, 0);
    }
    
    _picImageView.image = [OpenCVUtility MatToUIImage:drawing];
}

- (void)onClickMinCircle {
    Mat src_gray;
    
    // 转换为灰度图
    cvtColor(_srcImage, src_gray, CV_BGR2GRAY);
    // 降噪
    blur(src_gray, src_gray, cv::Size(3, 3));
    
    // 图像二值化
    Mat thresh_output;
    threshold(src_gray, thresh_output, [self blurSize], 255, THRESH_BINARY);
    
    // 寻找轮廓
    cv::vector<cv::vector<cv::Point>> contours;
    cv::vector<cv::Vec4i> hierarchy;
    findContours(thresh_output, contours, hierarchy, CV_RETR_TREE, CV_CHAIN_APPROX_SIMPLE, cv::Point(0, 0));
    
    // 多边形逼近轮廓 + 获取矩形边界框
    cv::vector<cv::vector<cv::Point>> contours_poly(contours.size());
    cv::vector<cv::Point2f> center(contours.size());
    cv::vector<float> radius(contours.size());
    
    for (int i = 0; i < contours.size(); i++) {
        approxPolyDP(Mat(contours[i]), contours_poly[i], 3, true);
        minEnclosingCircle(contours_poly[i], center[i], radius[i]);
    }
    
    // 画多边形轮廓 + 包围的矩形框
    Mat drawing = Mat::zeros(thresh_output.rows, thresh_output.cols, CV_8UC3);
    for (int i = 0; i < contours.size(); i++) {
        drawContours(drawing, contours_poly, i, Scalar::all(255), 1, 8, cv::vector<cv::Vec4i>(), 0, cv::Point());
        circle(drawing, center[i], radius[i], Scalar(0, 0, 255), 2, 8, 0);
    }
    
    _picImageView.image = [OpenCVUtility MatToUIImage:drawing];
}

- (void)sizeValueChanged:(id)sender {
    int size = [self blurSize];
    
    _blurSize.text = [NSString stringWithFormat:@"%d", size];
}

- (void)onClickStudy {
    [super onClickStudy];
    
    WebViewController *controller = [[WebViewController alloc] init];
    controller.titleString = @"创建包围轮廓的矩形和圆形边界框";
    controller.urlString = @"http://www.opencv.org.cn/opencvdoc/2.3.2/html/doc/tutorials/imgproc/shapedescriptors/bounding_rects_circles/bounding_rects_circles.html#bounding-rects-circles";
    [self.navigationController pushViewController:controller animated:YES];
}

@end
