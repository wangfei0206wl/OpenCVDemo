//
//  Filter2DViewController.m
//  OpenCVDemo
//
//  Created by wangfei on 14-7-15.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import "Filter2DViewController.h"
#import "WebViewController.h"
#import "PublicDefines.h"
#import "OpenCVUtility.h"

@interface Filter2DViewController () {
    UIImageView *_picImageView;
    // 核的尺寸(只限正方形区域)
    UILabel *_blurSize;
    // 定义核尺寸的slider
    UISlider *_sizeSlider;

    // 原始图像
    Mat _srcImage;
}

@end

@implementation Filter2DViewController

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
    btnTestInit.frame = CGRectMake(30, offsetY, SCREEN_WIDTH - 60, 30);
    [btnTestInit setTitle:@"线性滤波(filter2D)" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(onClickFilter2D) forControlEvents:UIControlEventTouchUpInside];
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
    [self setTitle:@"实现自己的线性滤波器"];
    [self createRightButton];
    [self createViews];
    
    _srcImage = [OpenCVUtility UIImageToMat:[UIImage imageNamed:@"cat.jpg"]];
    _picImageView.image = [UIImage imageNamed:@"cat.jpg"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (int)blurSize {
    int result = (int)_sizeSlider.value;
    
    result = (result % 2 == 0)?(result + 1):result;
    
    return result;
}

- (void)sizeValueChanged:(id)sender {
    int size = [self blurSize];
    
    _blurSize.text = [NSString stringWithFormat:@"%d", size];
}

- (void)onClickFilter2D {
    int size = [self blurSize];
    Mat dst;
    Mat kernel = Mat::ones(size, size, CV_32F) / (size * size);
    
    filter2D(_srcImage, dst, -1, kernel, cv::Point(-1, -1), 0, BORDER_DEFAULT);
    
    _picImageView.image = [OpenCVUtility MatToUIImage:dst];
}

- (void)onClickStudy {
    [super onClickStudy];
    
    WebViewController *controller = [[WebViewController alloc] init];
    controller.titleString = @"实现自己的线性滤波器";
    controller.urlString = @"http://www.opencv.org.cn/opencvdoc/2.3.2/html/doc/tutorials/imgproc/imgtrans/filter_2d/filter_2d.html#filter-2d";
    [self.navigationController pushViewController:controller animated:YES];
}

@end
