//
//  LaplacianViewController.m
//  OpenCVDemo
//
//  Created by wangfei on 14-7-16.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import "LaplacianViewController.h"
#import "WebViewController.h"
#import "PublicDefines.h"
#import "OpenCVUtility.h"

@interface LaplacianViewController () {
    UIImageView *_picImageView;
    // 核的尺寸(只限正方形区域)
    UILabel *_blurSize;
    // 定义核尺寸的slider
    UISlider *_sizeSlider;
    
    // 原始图像
    Mat _srcImage;
}

@end

@implementation LaplacianViewController

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
    [btnTestInit setTitle:@"Laplace检测边缘" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(onClickLaplacian) forControlEvents:UIControlEventTouchUpInside];
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
    textLabel.text = @"扩展边界size值:";
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
    [self setTitle:@"Laplace算子"];
    [self createRightButton];
    [self createViews];
    
    /*
     1、对原图做高斯滤波
     2、将图像转换为灰度图
     */
    _srcImage = [OpenCVUtility UIImageToMat:[UIImage imageNamed:@"cow.jpg"]];
    GaussianBlur(_srcImage, _srcImage, cv::Size(3, 3), 0, 0, BORDER_DEFAULT);
    cvtColor(_srcImage, _srcImage, CV_RGB2GRAY);
    
    _picImageView.image = [OpenCVUtility MatToUIImage:_srcImage];
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

- (void)loadPic {
    _picImageView.image = [OpenCVUtility MatToUIImage:_srcImage];
}

- (void)onClickLaplacian {
    int size = [self blurSize];
    Mat dst;
    
    Laplacian(_srcImage, dst, CV_16S, size, 1, 0, BORDER_DEFAULT);
    
    _picImageView.image = [OpenCVUtility MatToUIImage:dst];
}

- (void)sizeValueChanged:(id)sender {
    int size = [self blurSize];
    
    _blurSize.text = [NSString stringWithFormat:@"%d", size];
}

- (void)onClickStudy {
    [super onClickStudy];
    
    WebViewController *controller = [[WebViewController alloc] init];
    controller.titleString = @"Laplace算子";
    controller.urlString = @"http://www.opencv.org.cn/opencvdoc/2.3.2/html/doc/tutorials/imgproc/imgtrans/laplace_operator/laplace_operator.html#laplace-operator";
    [self.navigationController pushViewController:controller animated:YES];
}

@end
