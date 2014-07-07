//
//  ContrastViewController.m
//  OpenCVDemo
//
//  Created by wangfei on 14-7-7.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import "ContrastViewController.h"
#import "WebViewController.h"
#import "PublicDefines.h"
#import "OpenCVUtility.h"

@interface ContrastViewController () {
    UIImageView *_picImageView;
    UISlider *_alphaSlider;
    UISlider *_betaSlider;
    UILabel *_alphaLabel;
    UILabel *_betaLabel;
    UIButton *_btnType;
    
    int _convertType;
    cv::Mat _srcImage;
}

@end

@implementation ContrastViewController

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
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 500);
    [self.view addSubview:scrollView];
    
    CGFloat offsetY = 20;
    UIButton *btnTestInit = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTestInit.frame = CGRectMake(30, offsetY, 120, 30);
    [btnTestInit setTitle:@"加载图片" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(loadPic) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btnTestInit];

    _btnType = [UIButton buttonWithType:UIButtonTypeSystem];
    _btnType.frame = CGRectMake(170, offsetY, 120, 30);
    [_btnType setTitle:@"MyConvert" forState:UIControlStateNormal];
    [_btnType addTarget:self action:@selector(changeType) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:_btnType];

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
    textLabel.text = @"3";
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
    _alphaLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, offsetY, 40, 30)];
    _alphaLabel.backgroundColor = [UIColor clearColor];
    _alphaLabel.textColor = [UIColor blackColor];
    _alphaLabel.font = [UIFont systemFontOfSize:14.0f];
    _alphaLabel.textAlignment = NSTextAlignmentCenter;
    _alphaLabel.text = @"1.00";
    [scrollView addSubview:_alphaLabel];
    
    offsetY += 40;
    _alphaSlider = [[UISlider alloc] initWithFrame:CGRectMake(30, offsetY, SCREEN_WIDTH - 60, 20)];
    _alphaSlider.maximumValue = 3.0f; _alphaSlider.minimumValue = 1.0f;
    [scrollView addSubview:_alphaSlider];
    [_alphaSlider addTarget:self action:@selector(alphaValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    offsetY += 40;
    // 最小值
    textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, offsetY, 60, 30)];
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
    textLabel.text = @"100";
    [scrollView addSubview:textLabel];
    
    // alpha
    textLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, offsetY, 80, 30)];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.textColor = [UIColor blackColor];
    textLabel.font = [UIFont systemFontOfSize:14.0f];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.text = @"beta值:";
    [scrollView addSubview:textLabel];
    
    // alpha值
    _betaLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, offsetY, 40, 30)];
    _betaLabel.backgroundColor = [UIColor clearColor];
    _betaLabel.textColor = [UIColor blackColor];
    _betaLabel.font = [UIFont systemFontOfSize:14.0f];
    _betaLabel.textAlignment = NSTextAlignmentCenter;
    _betaLabel.text = @"0";
    [scrollView addSubview:_betaLabel];
    
    offsetY += 40;
    _betaSlider = [[UISlider alloc] initWithFrame:CGRectMake(30, offsetY, SCREEN_WIDTH - 60, 20)];
    _betaSlider.maximumValue = 100; _betaSlider.minimumValue = 0;
    [scrollView addSubview:_betaSlider];
    [_betaSlider addTarget:self action:@selector(betaValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    offsetY += 40;
    _picImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, offsetY, (SCREEN_WIDTH - 60), (SCREEN_WIDTH - 60))];
    _picImageView.contentMode = UIViewContentModeScaleAspectFit;
    [scrollView addSubview:_picImageView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"改变图像的对比度和亮度"];
    [self createRightButton];
    [self createViews];
    
    _convertType = 0;
    _srcImage = [OpenCVUtility UIImageToMat:[UIImage imageNamed:@"lena.jpg"]];
}

- (void)loadPic {
    _picImageView.image = [UIImage imageNamed:@"lena.jpg"];
}

- (void)processImage {
    float alpha = _alphaSlider.value;
    int beta = (int)_betaSlider.value;
    cv::Mat new_image = Mat::zeros(_srcImage.rows, _srcImage.cols, _srcImage.type());
    
    if (_convertType == 0) {
        // 像素来改变对比度与亮度
#if 1
        for (int y = 0; y < _srcImage.rows; y++) {
            for (int x = 0; x < _srcImage.cols; x++) {
                for (int c = 0; c < 3; c++) {
                    new_image.at<cv::Vec4b>(y, x)[c] = saturate_cast<uchar>(alpha * _srcImage.at<Vec4b>(y, x)[c] + beta);
                }
            }
        }
#else
        Mat_<Vec4b> tmp = _srcImage;
        Mat_<Vec4b> newImage = new_image;
        for (int y = 0; y < _srcImage.rows; y++) {
            for (int x = 0; x < _srcImage.cols; x++) {
                newImage(y, x)[0] = saturate_cast<uchar>(alpha * tmp(y, x)[0] + beta);
                newImage(y, x)[1] = saturate_cast<uchar>(alpha * tmp(y, x)[1] + beta);
                newImage(y, x)[2] = saturate_cast<uchar>(alpha * tmp(y, x)[2] + beta);
            }
        }
        new_image = newImage;
#endif
    }
    else {
        // 使用OpenCV convertTo
        _srcImage.convertTo(new_image, -1, alpha, beta);
    }
    
    _picImageView.image = [OpenCVUtility MatToUIImage:new_image];
}

- (void)changeType {
    NSString *title = _btnType.titleLabel.text;
    
    if ([title  isEqualToString:@"MyConvert"]) {
        [_btnType setTitle:@"OpenCV Convert" forState:UIControlStateNormal];
        _convertType = 1;
    }
    else {
        [_btnType setTitle:@"MyConvert" forState:UIControlStateNormal];
        _convertType = 0;
    }
    
    [self processImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alphaValueChanged:(id)sender {
    _alphaLabel.text = [NSString stringWithFormat:@"%.02f", _alphaSlider.value];
    
    [self processImage];
}

- (void)betaValueChanged:(id)sender {
    _betaLabel.text = [NSString stringWithFormat:@"%d", (int)_betaSlider.value];
    
    [self processImage];
}

- (void)onClickStudy {
    [super onClickStudy];
    
    WebViewController *controller = [[WebViewController alloc] init];
    controller.titleString = @"改变图像的对比度和亮度";
    controller.urlString = @"http://www.opencv.org.cn/opencvdoc/2.3.2/html/doc/tutorials/core/basic_linear_transform/basic_linear_transform.html#basic-linear-transform";
    [self.navigationController pushViewController:controller animated:YES];
}

@end
