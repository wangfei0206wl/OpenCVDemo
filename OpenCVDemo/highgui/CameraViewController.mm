//
//  CameraViewController.m
//  OpenCVDemo
//
//  Created by wangfei on 14-8-6.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import "CameraViewController.h"
#import "PublicDefines.h"
#import "OpenCVUtility.h"

@interface CameraViewController () {
    UIImageView *_imageView;
    UILabel *_blurSize;
    UISlider *_sizeSlider;
    
    CvVideoCamera *_videoCamera;
    
    BOOL _bFront;
}

@end

@implementation CameraViewController

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

    CGFloat offsetY = 0;

    UIButton *btnTestInit = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTestInit.frame = CGRectMake(30, offsetY, 120, 30);
    [btnTestInit setTitle:@"前置拍摄" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(onClickCamera:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btnTestInit];

    btnTestInit = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTestInit.frame = CGRectMake(170, offsetY, 120, 30);
    [btnTestInit setTitle:@"确定" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(onClickOK:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btnTestInit];

    offsetY += 30;
    // 最小值
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, offsetY, 60, 30)];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.textColor = [UIColor blackColor];
    textLabel.font = [UIFont systemFontOfSize:14.0f];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.text = @"10";
    [scrollView addSubview:textLabel];
    
    // 最大值
    textLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 70, offsetY, 60, 30)];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.textColor = [UIColor blackColor];
    textLabel.font = [UIFont systemFontOfSize:14.0f];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.text = @"30";
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
    _blurSize.text = @"15";
    [scrollView addSubview:_blurSize];
    
    offsetY += 40;
    _sizeSlider = [[UISlider alloc] initWithFrame:CGRectMake(30, offsetY, SCREEN_WIDTH - 60, 20)];
    _sizeSlider.maximumValue = 30.0f; _sizeSlider.minimumValue = 10.0f; _sizeSlider.value = 15.0f;
    [scrollView addSubview:_sizeSlider];
    [_sizeSlider addTarget:self action:@selector(sizeValueChanged:) forControlEvents:UIControlEventValueChanged];

    offsetY += 40;
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, offsetY, SCREEN_WIDTH - 60, (SCREEN_WIDTH - 60) * 352 / 288)];
    _imageView.contentMode = UIViewContentModeCenter;
    [scrollView addSubview:_imageView];
    
    _videoCamera = [[CvVideoCamera alloc] initWithParentView:_imageView];
    _videoCamera.delegate = (id)self;
    _videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionFront;
    _videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    _videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset352x288;
    _videoCamera.defaultFPS = 15;
//    _videoCamera.grayscaleMode = YES;
    
    [_videoCamera start];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"Camera的使用"];
    [self createViews];
    
    _bFront = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_videoCamera stop];
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

- (void)sizeValueChanged:(id)sender {
    int size = [self blurSize];
    
    _blurSize.text = [NSString stringWithFormat:@"%d", size];
}

- (void)changeCamera:(BOOL)bFront {
    int size = [self blurSize];
    
    if (_videoCamera.running) {
        [_videoCamera stop];
    }
    
    _videoCamera.defaultAVCaptureDevicePosition = bFront?AVCaptureDevicePositionFront:AVCaptureDevicePositionBack;
    _videoCamera.defaultFPS = size;
    
    [_videoCamera start];
}

- (void)onClickCamera:(id)sender {
    UIButton *btn = (UIButton *)sender;
    
    if ([btn.titleLabel.text isEqual:@"前置拍摄"]) {
        [btn setTitle:@"后置拍摄" forState:UIControlStateNormal];
        // 转换到后置拍摄
        _bFront = NO;
    }
    else {
        [btn setTitle:@"前置拍摄" forState:UIControlStateNormal];
        // 转换到前置拍摄
        _bFront = YES;
    }
}

- (void)onClickOK:(id)sender {
    [self changeCamera:_bFront];
}

- (void)processImage:(cv::Mat&)image {
    // 这里可以对图像进行处理
    cvtColor(image, image, CV_BGR2GRAY);
}

@end
