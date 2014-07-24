//
//  ContoursViewController.m
//  OpenCVDemo
//
//  Created by wangfei on 14-7-24.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import "ContoursViewController.h"
#import "WebViewController.h"
#import "PublicDefines.h"
#import "OpenCVUtility.h"

@interface ContoursViewController () {
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

@implementation ContoursViewController

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
    [btnTestInit setTitle:@"寻找轮廓" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(onClickFindContours) forControlEvents:UIControlEventTouchUpInside];
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
    [self setTitle:@"在图像中寻找轮廓"];
    [self createRightButton];
    [self createViews];
    
    _srcImage = [OpenCVUtility UIImageToMat:[UIImage imageNamed:@"fish_demo.jpg"]];
    _picImageView.image = [UIImage imageNamed:@"fish_demo.jpg"];
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
    _picImageView.image = [UIImage imageNamed:@"fish_demo.jpg"];
}

- (void)onClickFindContours {
    Mat src_gray;
    
    // 转换为灰度图
    cvtColor(_srcImage, src_gray, CV_BGR2GRAY);
    // 对图像进行降噪
    blur(src_gray, src_gray, cv::Size(3, 3));
    
    // 边缘检测
    Mat canny_output;
    cv::vector<cv::vector<cv::Point>> contours;
    cv::vector<cv::Vec4i> hierarchy;
    int threshold = [self blurSize];
    Canny(src_gray, canny_output, threshold, threshold * 2, 3);
    findContours(canny_output, contours, hierarchy, CV_RETR_TREE, CV_CHAIN_APPROX_SIMPLE, cv::Point(0, 0));
    
    // 绘制轮廓
    Mat drawing = Mat::zeros(canny_output.rows, canny_output.cols, CV_8UC3);
    for (int i = 0; i < contours.size(); i++) {
        drawContours(drawing, contours, i, Scalar::all(255), 2, 8, hierarchy, 0, cv::Point());
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
    controller.titleString = @"在图像中寻找轮廓";
    controller.urlString = @"http://www.opencv.org.cn/opencvdoc/2.3.2/html/doc/tutorials/imgproc/shapedescriptors/find_contours/find_contours.html#find-contours";
    [self.navigationController pushViewController:controller animated:YES];
}

@end
