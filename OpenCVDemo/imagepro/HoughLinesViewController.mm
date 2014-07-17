//
//  HoughLinesViewController.m
//  OpenCVDemo
//
//  Created by wangfei on 14-7-17.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import "HoughLinesViewController.h"
#import "WebViewController.h"
#import "PublicDefines.h"
#import "OpenCVUtility.h"

@interface HoughLinesViewController () {
    UIImageView *_picImageView;
    // 最少的曲线交点个数
    UILabel *_blurSize;
    // 最少的曲线交点个数的slider
    UISlider *_sizeSlider;
    
    // 原始图像
    Mat _srcImage;
}

@end

@implementation HoughLinesViewController

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
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 440);
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
    [btnTestInit setTitle:@"标准霍夫线变换" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(onClickHoughLines) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btnTestInit];
    
    offsetY += 30;
    btnTestInit = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTestInit.frame = CGRectMake(30, offsetY, SCREEN_WIDTH - 60, 30);
    [btnTestInit setTitle:@"统计概率霍夫线变换" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(onClickHoughLinesP) forControlEvents:UIControlEventTouchUpInside];
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
    textLabel.text = @"曲线交点最小个数:";
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
    _picImageView.contentMode = UIViewContentModeScaleAspectFit;
    [scrollView addSubview:_picImageView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"霍夫线变换"];
    [self createRightButton];
    [self createViews];
    
    /*
     1、将图像转换为灰度图
     2、对图像做canny边缘检测
     */
    _srcImage = [OpenCVUtility UIImageToMat:[UIImage imageNamed:@"building.jpg"]];
    // 高斯平滑降噪
    GaussianBlur(_srcImage, _srcImage, cv::Size(3, 3), 0, 0, BORDER_DEFAULT);
    cvtColor(_srcImage, _srcImage, CV_RGB2GRAY);
    Canny(_srcImage, _srcImage, 50, 150, 3);
    
    _picImageView.image = [OpenCVUtility MatToUIImage:_srcImage];
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
    _picImageView.image = [OpenCVUtility MatToUIImage:_srcImage];
}

- (void)onClickHoughLines {
    int size = [self blurSize];
    cv::vector<cv::Vec2f> lines;
    Mat dst;
    
    dst = _srcImage.clone();
//    dst.create(_srcImage.rows, _srcImage.cols, CV_8UC3);
//    dst = Scalar::all(255);
    HoughLines(_srcImage, lines, 1, CV_PI / 180, size, 0, 0);
    
    // 绘制lines
    for (int i = 0; i < lines.size(); i++) {
        float rho = lines[i][0], theta = lines[i][1];
        cv::Point pt1, pt2;
        double a = cos(theta), b = sin(theta);
        double x0 = a * rho, y0 = b * rho;
        
        pt1.x = cvRound(x0 + 1000 * (-b));
        pt1.y = cvRound(y0 + 1000 * (a));
        pt2.x = cvRound(x0 - 1000 * (-b));
        pt2.y = cvRound(y0 - 1000 * (a));
        line(dst, pt1, pt2, Scalar(0, 0, 255), 3, CV_AA);
    }
    
    _picImageView.image = [OpenCVUtility MatToUIImage:dst];
}

- (void)onClickHoughLinesP {
    int size = [self blurSize];
    cv::vector<cv::Vec4i> lines;
    Mat dst;
    
    dst = _srcImage.clone();
//    dst.create(_srcImage.rows, _srcImage.cols, CV_8UC3);
//    dst = Scalar::all(0);
    HoughLinesP(_srcImage, lines, 1, CV_PI / 180, size, 50, 10);
    
    // 绘制lines
    for (int i = 0; i < lines.size(); i++) {
        cv::Vec4i l = lines[i];
        line(dst, cv::Point(l[0], l[1]), cv::Point(l[2], l[3]), Scalar(0, 0, 255), 3, CV_AA);
    }
    
    _picImageView.image = [OpenCVUtility MatToUIImage:dst];
}

- (void)sizeValueChanged:(id)sender {
    int size = [self blurSize];
    
    _blurSize.text = [NSString stringWithFormat:@"%d", size];
}

- (void)onClickStudy {
    [super onClickStudy];
    
    WebViewController *controller = [[WebViewController alloc] init];
    controller.titleString = @"霍夫线变换";
    controller.urlString = @"http://www.opencv.org.cn/opencvdoc/2.3.2/html/doc/tutorials/imgproc/imgtrans/hough_lines/hough_lines.html#hough-lines";
    [self.navigationController pushViewController:controller animated:YES];
}

@end
