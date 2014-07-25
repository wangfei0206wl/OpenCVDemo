//
//  PolygonTestViewController.m
//  OpenCVDemo
//
//  Created by wangfei on 14-7-25.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import "PolygonTestViewController.h"
#import "WebViewController.h"
#import "PublicDefines.h"
#import "OpenCVUtility.h"

@interface PolygonTestViewController () {
    // 原始图像
    UIImageView *_picImageView;

    // 原始图像
    Mat _srcImage;
}

@end

@implementation PolygonTestViewController

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
    btnTestInit.frame = CGRectMake(30, offsetY, SCREEN_WIDTH - 60, 30);
    [btnTestInit setTitle:@"多边形测试" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(onClickPolygonTest) forControlEvents:UIControlEventTouchUpInside];
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
    [self setTitle:@"多边形测试"];
    [self createRightButton];
    [self createViews];
    
    [self loadPic];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadPic {
    if (_srcImage.empty()) {
        int radius = 100;
        // 创建一个图形
        _srcImage = Mat::zeros(4 * radius, 4 * radius, CV_8UC1);
        
        // 绘制一系列点创建一个轮廓
        cv::vector<cv::Point2f> vert(6);
        
        vert[0] = cv::Point(1.5 * radius, 1.34 * radius);
        vert[1] = cv::Point(1 * radius, 2 * radius);
        vert[2] = cv::Point(1.5 * radius, 2.866 * radius);
        vert[3] = cv::Point(2.5 * radius, 2.866 * radius);
        vert[4] = cv::Point(3 * radius, 2 * radius);
        vert[5] = cv::Point(2.5 * radius, 1.34 * radius);
        
        // 绘制轮廓
        for (int i = 0;i < vert.size(); i++) {
            line(_srcImage, vert[i], vert[(i + 1) % vert.size()], Scalar(255), 3, 8);
        }
    }
    
    _picImageView.image = [OpenCVUtility MatToUIImage:_srcImage];
}

- (void)onClickPolygonTest {
    Mat src_copy = _srcImage.clone();
    
    // 寻找轮廓
    cv::vector<cv::vector<cv::Point>> contours;
    cv::vector<cv::Vec4i> hierarchy;
    findContours(src_copy, contours, hierarchy, CV_RETR_TREE, CHAIN_APPROX_SIMPLE);
    
    // 计算到轮廓的距离
    Mat raw_dist(src_copy.rows, src_copy.cols, CV_32FC1);
    
    for (int i = 0; i < src_copy.rows; i++) {
        for (int j = 0; j < src_copy.cols; j++) {
            raw_dist.at<float>(i, j) = pointPolygonTest(contours[0], cv::Point2f(j, i), true);
        }
    }
    
    double maxVal; double minVal;
    minMaxLoc(raw_dist, &minVal, &maxVal, 0, 0, Mat());
    minVal = abs(minVal); maxVal = abs(maxVal);
    
    // 绘制多边形
    Mat drawing = Mat::zeros(src_copy.rows, src_copy.cols, CV_8UC3);
    for (int i = 0; i < src_copy.rows; i++) {
        for (int j = 0; j < src_copy.cols; j++) {
            if (raw_dist.at<float>(i, j) < 0) {
                drawing.at<Vec3b>(i, j)[0] = 255 - (int)abs(raw_dist.at<float>(i, j)) * 255 / minVal;
            }
            else if (raw_dist.at<float>(i, j) > 0) {
                drawing.at<Vec3b>(i, j)[2] = 255 - (int)raw_dist.at<float>(i, j) * 255 / maxVal;
            }
            else {
                drawing.at<Vec3b>(i, j)[0] = 255;
                drawing.at<Vec3b>(i, j)[1] = 255;
                drawing.at<Vec3b>(i, j)[2] = 255;
            }
        }
    }
    
    _picImageView.image = [OpenCVUtility MatToUIImage:drawing];
}

- (void)onClickStudy {
    [super onClickStudy];
    
    WebViewController *controller = [[WebViewController alloc] init];
    controller.titleString = @"多边形测试";
    controller.urlString = @"http://www.opencv.org.cn/opencvdoc/2.3.2/html/doc/tutorials/imgproc/shapedescriptors/point_polygon_test/point_polygon_test.html#point-polygon-test";
    [self.navigationController pushViewController:controller animated:YES];
}

@end
