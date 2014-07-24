//
//  ConvexHullViewController.m
//  OpenCVDemo
//
//  Created by wangfei on 14-7-24.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import "ConvexHullViewController.h"
#import "WebViewController.h"
#import "PublicDefines.h"
#import "OpenCVUtility.h"

@interface ConvexHullViewController () {
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

@implementation ConvexHullViewController

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
    [btnTestInit setTitle:@"计算物体凸包" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(onClickConvexHull) forControlEvents:UIControlEventTouchUpInside];
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
    [self setTitle:@"计算物体的凸包"];
    [self createRightButton];
    [self createViews];
    
    _srcImage = [OpenCVUtility UIImageToMat:[UIImage imageNamed:@"hand_two.jpg"]];
    _picImageView.image = [UIImage imageNamed:@"hand_two.jpg"];
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
    _picImageView.image = [UIImage imageNamed:@"hand_two.jpg"];
}

- (void)onClickConvexHull {
    Mat src_gray;
    
    // 转换成灰度图
    cvtColor(_srcImage, src_gray, CV_BGR2GRAY);
    // 对图像降噪
    blur(src_gray, src_gray, cv::Size(3, 3));
    
    // 对图像进行二值化
    Mat thresh_output;
    threshold(src_gray, thresh_output, [self blurSize], 255, THRESH_BINARY);
    
    // 寻找轮廓
    cv::vector<cv::vector<cv::Point>> contours;
    cv::vector<cv::Vec4i> hierarchy;
    
    findContours(thresh_output, contours, hierarchy, CV_RETR_TREE, CV_CHAIN_APPROX_SIMPLE, cv::Point(0, 0));
    
    // 对每个轮廓计算凸包
    cv::vector<cv::vector<cv::Point>> hull(contours.size());
    for (int i = 0; i < contours.size(); i++) {
        convexHull(Mat(contours[i]), hull[i], false);
    }
    
    // 绘制轮廓及其凸包
    Mat drawing = Mat::zeros(thresh_output.rows, thresh_output.cols, CV_8UC3);
    for (int i = 0; i < contours.size(); i++) {
        drawContours(drawing, contours, i, Scalar::all(255), 1, 8, cv::vector<cv::Vec4i>(), 0, cv::Point());
        drawContours(drawing, hull, i, Scalar(0, 0, 255), 1, 8, cv::vector<cv::Vec4i>(), 0, cv::Point());
        
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
    controller.titleString = @"计算物体的凸包";
    controller.urlString = @"http://www.opencv.org.cn/opencvdoc/2.3.2/html/doc/tutorials/imgproc/shapedescriptors/hull/hull.html#hull";
    [self.navigationController pushViewController:controller animated:YES];
}

@end
