//
//  PyramidViewController.m
//  OpenCVDemo
//
//  Created by wangfei on 14-7-14.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import "PyramidViewController.h"
#import "WebViewController.h"
#import "PublicDefines.h"
#import "OpenCVUtility.h"

@interface PyramidViewController () {
    // 用于放置image的scroll view
    UIScrollView *_imageScrollView;
    UIImageView *_picImageView;
    // 缩放比例
    UILabel *_sizeLabel;
    // 定义缩放比例的slider
    UISlider *_sizeSlider;
  
    // 原始图像
    Mat _srcImage;
    // 当前操作类型
    BOOL _bPyramidUp;
}

@end

@implementation PyramidViewController

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
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 320);
    [self.view addSubview:scrollView];
    
    CGFloat offsetY = 20;
    UIButton *btnTestInit = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTestInit.frame = CGRectMake(30, offsetY, 120, 30);
    [btnTestInit setTitle:@"向上采样" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(onClickUp) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btnTestInit];
    
    btnTestInit = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTestInit.frame = CGRectMake(170, offsetY, 120, 30);
    [btnTestInit setTitle:@"向下采样" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(onClickDown) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btnTestInit];
    
    offsetY += 40;
    _imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(30, offsetY, (SCREEN_WIDTH - 60), (SCREEN_WIDTH - 60))];
    _imageScrollView.contentSize = CGSizeMake((SCREEN_WIDTH - 60), (SCREEN_WIDTH - 60));
    _picImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (SCREEN_WIDTH - 60), (SCREEN_WIDTH - 60))];
    _picImageView.contentMode = UIViewContentModeCenter;
    [_imageScrollView addSubview:_picImageView];
    [scrollView addSubview:_imageScrollView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"图像金字塔"];
    [self createRightButton];
    [self createViews];
    
    _srcImage = [OpenCVUtility UIImageToMat:[UIImage imageNamed:@"dog.jpg"]];
    _picImageView.image = [UIImage imageNamed:@"dog.jpg"];
    _bPyramidUp = YES;
    
    [self adjustViews];
}

- (void)adjustViews {
    CGRect frame =  _picImageView.frame;
    frame.size = _picImageView.image.size;
    _picImageView.frame = frame;
    
    if (frame.size.width > (SCREEN_WIDTH - 60) || frame.size.height > (SCREEN_WIDTH - 60)) {
        _imageScrollView.contentSize = frame.size;
    }
    else {
        _imageScrollView.contentSize = CGSizeMake((SCREEN_WIDTH - 60), (SCREEN_WIDTH - 60));
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)processImage {
    Mat dst;

    if (_bPyramidUp) {
        pyrUp(_srcImage, dst, cv::Size(_srcImage.cols * 2, _srcImage.rows * 2));
    }
    else {
        pyrDown(_srcImage, dst, cv::Size(_srcImage.cols / 2, _srcImage.rows / 2));
    }
    
    _picImageView.image = [OpenCVUtility MatToUIImage:dst];
    _srcImage = dst;
    
    [self adjustViews];
}

- (void)onClickUp {
    _bPyramidUp = YES;
    [self processImage];
}

- (void)onClickDown {
    _bPyramidUp = NO;
    [self processImage];
}

- (void)onClickStudy {
    [super onClickStudy];
    
    WebViewController *controller = [[WebViewController alloc] init];
    controller.titleString = @"图像金字塔";
    controller.urlString = @"http://www.opencv.org.cn/opencvdoc/2.3.2/html/doc/tutorials/imgproc/pyramids/pyramids.html#pyramids";
    [self.navigationController pushViewController:controller animated:YES];
}

@end
