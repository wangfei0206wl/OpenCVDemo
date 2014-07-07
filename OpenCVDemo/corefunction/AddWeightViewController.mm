//
//  AddWeightViewController.m
//  OpenCVDemo
//
//  Created by wangfei on 14-7-7.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import "AddWeightViewController.h"
#import "WebViewController.h"
#import "PublicDefines.h"
#import "OpenCVUtility.h"

@interface AddWeightViewController () {
    UIImageView *_picImageView;
    UISlider *_alphaSider;
    UILabel *_valueLabel;
    
    cv::Mat _srcImage;
    cv::Mat _addImage;
}

@end

@implementation AddWeightViewController

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
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 380);
    [self.view addSubview:scrollView];
    
    CGFloat offsetY = 20;
    UIButton *btnTestInit = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTestInit.frame = CGRectMake(60, offsetY, (SCREEN_WIDTH - 120), 30);
    [btnTestInit setTitle:@"加载图片" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(loadPic) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btnTestInit];
    
    offsetY += 30;
    // 最小值
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, offsetY, 60, 30)];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.textColor = [UIColor blackColor];
    textLabel.font = [UIFont systemFontOfSize:14.0f];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.text = @"0";
    [scrollView addSubview:textLabel];
    
    // 最大值
    textLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 70, offsetY, 60, 30)];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.textColor = [UIColor blackColor];
    textLabel.font = [UIFont systemFontOfSize:14.0f];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.text = @"1";
    [scrollView addSubview:textLabel];

    // alpha
    textLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, offsetY, 80, 30)];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.textColor = [UIColor blackColor];
    textLabel.font = [UIFont systemFontOfSize:14.0f];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.text = @"alpha值:";
    [scrollView addSubview:textLabel];

    // alpha值
    _valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, offsetY, 40, 30)];
    _valueLabel.backgroundColor = [UIColor clearColor];
    _valueLabel.textColor = [UIColor blackColor];
    _valueLabel.font = [UIFont systemFontOfSize:14.0f];
    _valueLabel.textAlignment = NSTextAlignmentCenter;
    _valueLabel.text = @"0.00";
    [scrollView addSubview:_valueLabel];
    
    offsetY += 40;
    _alphaSider = [[UISlider alloc] initWithFrame:CGRectMake(30, offsetY, SCREEN_WIDTH - 60, 20)];
    _alphaSider.maximumValue = 1.0f; _alphaSider.minimumValue = 0.0f;
    [scrollView addSubview:_alphaSider];
    [_alphaSider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    offsetY += 40;
    _picImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, offsetY, (SCREEN_WIDTH - 60), (SCREEN_WIDTH - 60))];
    _picImageView.contentMode = UIViewContentModeScaleAspectFit;
    [scrollView addSubview:_picImageView];
}

- (void)initMats {
    _srcImage = [OpenCVUtility UIImageToMat:[UIImage imageNamed:@"lena.jpg"]];
    _addImage = [OpenCVUtility UIImageToMat:[UIImage imageNamed:@"test.png"]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"对两幅图像求和"];
    [self createRightButton];
    [self createViews];
    [self initMats];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 对两图像进行求和运算
- (void)processImage:(double)alpha {
    Mat dst;
    
    addWeighted(_srcImage, (1 - alpha), _addImage, alpha, 0.0, dst);
    _picImageView.image = [OpenCVUtility MatToUIImage:dst];
}

- (void)loadPic {
    _picImageView.image = [UIImage imageNamed:@"lena.jpg"];
}

- (void)sliderValueChanged:(id)sender {
    _valueLabel.text = [NSString stringWithFormat:@"%.2f", _alphaSider.value];
    [self processImage:_alphaSider.value];
}

- (void)onClickStudy {
    [super onClickStudy];
    
    WebViewController *controller = [[WebViewController alloc] init];
    controller.titleString = @"对两幅图像求和";
    controller.urlString = @"http://www.opencv.org.cn/opencvdoc/2.3.2/html/doc/tutorials/core/adding_images/adding_images.html#adding-images";
    [self.navigationController pushViewController:controller animated:YES];
}

@end
