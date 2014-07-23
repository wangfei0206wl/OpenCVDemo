//
//  BackProjectViewController.m
//  OpenCVDemo
//
//  Created by wangfei on 14-7-23.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import "BackProjectViewController.h"
#import "WebViewController.h"
#import "PublicDefines.h"
#import "OpenCVUtility.h"

@interface BackProjectViewController () {
    UIImageView *_picImageView;
    UIImageView *_picHistImage;
    // bin的数目
    UILabel *_blurSize;
    // bin的数目
    UISlider *_sizeSlider;
    
    // 原始图像
    Mat _srcImage;
    // 直方图的图像矩阵
    Mat _imageHist;
}

@end

@implementation BackProjectViewController

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
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 340);
    [self.view addSubview:scrollView];
    
    CGFloat offsetY = 20;
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, offsetY, SCREEN_WIDTH - 20, 30)];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.textColor = [UIColor blackColor];
    textLabel.font = [UIFont systemFontOfSize:14.0f];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.text = @"对下方图像采用反向投影，来找到物体";
    [scrollView addSubview:textLabel];
    
    offsetY += 30;
    // 最小值
    textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, offsetY, 60, 30)];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.textColor = [UIColor blackColor];
    textLabel.font = [UIFont systemFontOfSize:14.0f];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.text = @"2";
    [scrollView addSubview:textLabel];
    
    // 最大值
    textLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 70, offsetY, 60, 30)];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.textColor = [UIColor blackColor];
    textLabel.font = [UIFont systemFontOfSize:14.0f];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.text = @"255";
    [scrollView addSubview:textLabel];
    
    // bins
    textLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, offsetY, 160, 30)];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.textColor = [UIColor blackColor];
    textLabel.font = [UIFont systemFontOfSize:14.0f];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.text = @"bins值:";
    [scrollView addSubview:textLabel];
    
    // alpha值
    _blurSize = [[UILabel alloc] initWithFrame:CGRectMake(180, offsetY, 40, 30)];
    _blurSize.backgroundColor = [UIColor clearColor];
    _blurSize.textColor = [UIColor blackColor];
    _blurSize.font = [UIFont systemFontOfSize:14.0f];
    _blurSize.textAlignment = NSTextAlignmentCenter;
    _blurSize.text = @"2";
    [scrollView addSubview:_blurSize];
    
    offsetY += 40;
    _sizeSlider = [[UISlider alloc] initWithFrame:CGRectMake(30, offsetY, SCREEN_WIDTH - 60, 20)];
    _sizeSlider.maximumValue = 255.0f; _sizeSlider.minimumValue = 2.0f;
    [scrollView addSubview:_sizeSlider];
    [_sizeSlider addTarget:self action:@selector(sizeValueChanged:) forControlEvents:UIControlEventValueChanged];

    offsetY += 30;
    UIButton *btnTestInit = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTestInit.frame = CGRectMake(30, offsetY, SCREEN_WIDTH - 60, 30);
    [btnTestInit setTitle:@"加载图片" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(loadPic) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btnTestInit];
    
    offsetY += 30;
    btnTestInit = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTestInit.frame = CGRectMake(30, offsetY, 120, 30);
    [btnTestInit setTitle:@"反向投影" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(onClickBackProject) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btnTestInit];
 
    btnTestInit = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTestInit.frame = CGRectMake(170, offsetY, 120, 30);
    [btnTestInit setTitle:@"直方图" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(onClickShowHist) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btnTestInit];

    offsetY += 40;
    _picImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, offsetY, 120, 120)];
    _picImageView.contentMode = UIViewContentModeScaleAspectFit;
    [scrollView addSubview:_picImageView];
    
    _picHistImage = [[UIImageView alloc] initWithFrame:CGRectMake(170, offsetY, 120, 120)];
    _picHistImage.contentMode = UIViewContentModeScaleAspectFit;
    [scrollView addSubview:_picHistImage];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"反向投影"];
    [self createRightButton];
    [self createViews];
    
    _srcImage = [OpenCVUtility UIImageToMat:[UIImage imageNamed:@"hand_demo_one.jpg"]];
    _picImageView.image = [UIImage imageNamed:@"hand_demo_one.jpg"];
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

- (void)loadPic {
    _picImageView.image = [UIImage imageNamed:@"hand_demo_one.jpg"];
}

- (void)onClickBackProject {
    Mat hsv, hue;
    
    // 转换图像到hsv
    cvtColor(_srcImage, hsv, CV_BGR2HSV);
    
    // 分离hue通道
    hue.create(hsv.rows, hsv.cols, hsv.depth());
    int ch[] = {0, 0};
    mixChannels(&hsv, 1, &hue, 1, ch, 1);
    
    // 直方图计算及归一化
    int size = [self blurSize];
    int histSize = MAX(size, 2);
    float hue_range[] = {0, 180};
    const float *ranges = {hue_range};
    
    calcHist(&hue, 1, 0, Mat(), _imageHist, 1, &histSize, &ranges, true, false);
    normalize(_imageHist, _imageHist, 0, 255, NORM_MINMAX, -1, Mat());
    
    // 计算反向投影
    Mat backproj;
    calcBackProject(&hue, 1, 0, _imageHist, backproj, &ranges, 1, true);
    
    // 显示反向投影
    _picImageView.image = [OpenCVUtility MatToUIImage:backproj];
}

- (void)onClickShowHist {
    if (_imageHist.empty() == false) {
        int size = [self blurSize];
        int histSize = MAX(size, 2);
        int w = 400; int h = 400;
        int bin_w = cvRound((double)w / histSize);
        Mat histImage = Mat::zeros(w, h, CV_8UC3);
        
        for (int i = 0; i < size; i++) {
            rectangle(histImage, cv::Point(i * bin_w, h), cv::Point((i + 1) * bin_w, h - cvRound(_imageHist.at<float>(i) * h / 255.0)), Scalar(0, 0, 255));
        }
        _picHistImage.image = [OpenCVUtility MatToUIImage:histImage];
    }
}

- (void)onClickStudy {
    [super onClickStudy];
    
    WebViewController *controller = [[WebViewController alloc] init];
    controller.titleString = @"反向投影";
    controller.urlString = @"http://www.opencv.org.cn/opencvdoc/2.3.2/html/doc/tutorials/imgproc/histograms/back_projection/back_projection.html#back-projection";
    [self.navigationController pushViewController:controller animated:YES];
}

@end
