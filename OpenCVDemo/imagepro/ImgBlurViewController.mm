//
//  ImgBlurViewController.m
//  OpenCVDemo
//
//  Created by wangfei on 14-7-10.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import "ImgBlurViewController.h"
#import "WebViewController.h"
#import "PublicDefines.h"
#import "OpenCVUtility.h"

@interface ImgBlurViewController () {
    UIImageView *_picImageView;
    // 核的尺寸(只限正方形区域)
    UILabel *_blurSize;
    // 定义核尺寸的slider
    UISlider *_sizeSlider;
    
    // 原始图像
    Mat _srcImage;
}

@end

@implementation ImgBlurViewController

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
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 470);
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
    [btnTestInit setTitle:@"归化一块滤波" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(onClickBlur) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btnTestInit];

    btnTestInit = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTestInit.frame = CGRectMake(170, offsetY, 120, 30);
    [btnTestInit setTitle:@"高斯滤波" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(onClickGaussianBlur) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btnTestInit];
    
    offsetY += 30;
    btnTestInit = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTestInit.frame = CGRectMake(30, offsetY, 120, 30);
    [btnTestInit setTitle:@"中值滤波" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(onClickMedianBlur) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btnTestInit];

    btnTestInit = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTestInit.frame = CGRectMake(170, offsetY, 120, 30);
    [btnTestInit setTitle:@"双边滤波" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(onClickBilateralFilter) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btnTestInit];
    
    offsetY += 30;
    // 最小值
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, offsetY, 60, 30)];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.textColor = [UIColor blackColor];
    textLabel.font = [UIFont systemFontOfSize:14.0f];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.text = @"1";
    [scrollView addSubview:textLabel];
    
    // 最大值
    textLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 70, offsetY, 60, 30)];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.textColor = [UIColor blackColor];
    textLabel.font = [UIFont systemFontOfSize:14.0f];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.text = @"11";
    [scrollView addSubview:textLabel];
    
    // size
    textLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, offsetY, 160, 30)];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.textColor = [UIColor blackColor];
    textLabel.font = [UIFont systemFontOfSize:14.0f];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.text = @"size值(必须为奇数):";
    [scrollView addSubview:textLabel];
    
    // alpha值
    _blurSize = [[UILabel alloc] initWithFrame:CGRectMake(180, offsetY, 40, 30)];
    _blurSize.backgroundColor = [UIColor clearColor];
    _blurSize.textColor = [UIColor blackColor];
    _blurSize.font = [UIFont systemFontOfSize:14.0f];
    _blurSize.textAlignment = NSTextAlignmentCenter;
    _blurSize.text = @"1";
    [scrollView addSubview:_blurSize];
    
    offsetY += 40;
    _sizeSlider = [[UISlider alloc] initWithFrame:CGRectMake(30, offsetY, SCREEN_WIDTH - 60, 20)];
    _sizeSlider.maximumValue = 11.0f; _sizeSlider.minimumValue = 1.0f;
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
    [self setTitle:@"图像平滑处理"];
    [self createRightButton];
    [self createViews];
    
    _srcImage = [OpenCVUtility UIImageToMat:[UIImage imageNamed:@"lena.jpg"]];
    [self loadPic];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadPic {
    _picImageView.image = [UIImage imageNamed:@"lena.jpg"];
}

- (int)blurSize {
    int result = (int)_sizeSlider.value;
    
    result = (result % 2 == 0)?(result + 1):result;
    
    return result;
}

// 归一化块滤波
- (void)onClickBlur {
    Mat dst;
    int size = [self blurSize];

    blur(_srcImage, dst, cv::Size(size, size), cv::Point(-1, -1));
    
    _picImageView.image = [OpenCVUtility MatToUIImage:dst];
}

// 高斯滤波
- (void)onClickGaussianBlur {
    Mat dst;
    int size = [self blurSize];
    
    // 指定x方向与y方向的标准方差为0, 方差将由内核大小计算得到
    GaussianBlur(_srcImage, dst, cv::Size(size, size), 0, 0);
    
    _picImageView.image = [OpenCVUtility MatToUIImage:dst];
}

// 中值滤波
- (void)onClickMedianBlur {
    Mat dst;
    int size = [self blurSize];
    
    // 中值滤波必须为正方形的核
    medianBlur(_srcImage, dst, size);
    
    _picImageView.image = [OpenCVUtility MatToUIImage:dst];
}

// 双边滤波(只针对RGB图和灰度图，对于RGBA图，需要先转换成RGB图再做双边滤波)
- (void)onClickBilateralFilter {
    Mat dst, image_copy;
    int size = [self blurSize];
    
    if (_srcImage.type() == CV_8UC4) {
        cvtColor(_srcImage, image_copy, CV_BGRA2BGR);
    }
    
    dst = image_copy.clone();
    /*
     第三个参数: 像素的邻域直径
     第四个参数: 颜色空间的标准方差
     第五个参数: 坐标空间的标准方差
     */
    bilateralFilter(image_copy, dst, size, size * 2, size / 2);
    
    _picImageView.image = [OpenCVUtility MatToUIImage:dst];
}

- (void)sizeValueChanged:(id)sender {
    int size = [self blurSize];
    
    _blurSize.text = [NSString stringWithFormat:@"%d", size];
}

- (void)onClickStudy {
    [super onClickStudy];
    
    WebViewController *controller = [[WebViewController alloc] init];
    controller.titleString = @"图像平滑处理";
    controller.urlString = @"http://www.opencv.org.cn/opencvdoc/2.3.2/html/doc/tutorials/imgproc/gausian_median_blur_bilateral_filter/gausian_median_blur_bilateral_filter.html#smoothing";
    [self.navigationController pushViewController:controller animated:YES];
}

@end
