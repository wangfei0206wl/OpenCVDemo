//
//  ThresholdViewController.m
//  OpenCVDemo
//
//  Created by wangfei on 14-7-14.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import "ThresholdViewController.h"
#import "WebViewController.h"
#import "PublicDefines.h"
#import "OpenCVUtility.h"

@interface ThresholdViewController () {
    UIImageView *_picImageView;
    
    // 原始图像
    Mat _srcImage;
}

@end

@implementation ThresholdViewController

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
    btnTestInit.frame = CGRectMake(30, offsetY, 120, 30);
    [btnTestInit setTitle:@"二进制阈值化" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(onClickTestF) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btnTestInit];
    
    btnTestInit = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTestInit.frame = CGRectMake(170, offsetY, 120, 30);
    [btnTestInit setTitle:@"反二进制阈值化" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(onClickTestS) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btnTestInit];
    
    offsetY += 30;
    btnTestInit = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTestInit.frame = CGRectMake(30, offsetY, 120, 30);
    [btnTestInit setTitle:@"截断阈值化" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(onClickTestT) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btnTestInit];
    
    btnTestInit = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTestInit.frame = CGRectMake(170, offsetY, 120, 30);
    [btnTestInit setTitle:@"阈值化为0" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(onClickTestFour) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btnTestInit];
    
    offsetY += 30;
    btnTestInit = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTestInit.frame = CGRectMake(30, offsetY, 120, 30);
    [btnTestInit setTitle:@"反阈值化为0" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(onClickTestFive) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btnTestInit];

    btnTestInit = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTestInit.frame = CGRectMake(170, offsetY, 120, 30);
    [btnTestInit setTitle:@"原始灰度图" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(onClickTestSix) forControlEvents:UIControlEventTouchUpInside];
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
    [self setTitle:@"基本的阈值操作"];
    [self createRightButton];
    [self createViews];
    
    _srcImage = [OpenCVUtility UIImageToMat:[UIImage imageNamed:@"dog.jpg"]];
    cvtColor(_srcImage, _srcImage, CV_BGR2GRAY);
    _picImageView.image = [OpenCVUtility MatToUIImage:_srcImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)processImage:(int)type {
    Mat dst;
    double thresh = 125;
    double maxVal = 255;
    
    threshold(_srcImage, dst, thresh, maxVal, type);
    
    _picImageView.image = [OpenCVUtility MatToUIImage:dst];
}

- (void)onClickTestF {
    // 二进制阈值化
    [self processImage:0];
}

- (void)onClickTestS {
    // 反二进制阈值化
    [self processImage:1];
}

- (void)onClickTestT {
    // 截断阈值化
    [self processImage:2];
}

- (void)onClickTestFour {
    // 阈值化为0
    [self processImage:3];
}

- (void)onClickTestFive {
    // 反阈值化为0
    [self processImage:4];
}

- (void)onClickTestSix {
    _picImageView.image = [OpenCVUtility MatToUIImage:_srcImage];
}

- (void)onClickStudy {
    [super onClickStudy];
    
    WebViewController *controller = [[WebViewController alloc] init];
    controller.titleString = @"基本的阈值操作";
    controller.urlString = @"http://www.opencv.org.cn/opencvdoc/2.3.2/html/doc/tutorials/imgproc/threshold/threshold.html#basic-threshold";
    [self.navigationController pushViewController:controller animated:YES];
}

@end
