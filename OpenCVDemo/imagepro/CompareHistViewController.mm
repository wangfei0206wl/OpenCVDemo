//
//  CompareHistViewController.m
//  OpenCVDemo
//
//  Created by wangfei on 14-7-22.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import "CompareHistViewController.h"
#import "WebViewController.h"
#import "PublicDefines.h"
#import "OpenCVUtility.h"

@interface CompareHistViewController () {
    UIImageView *_picImageView;
    // 半张源图
    UIImageView *_picHalfDown;
    
    // 原始图像
    Mat _srcImage;
    // base图像
    Mat _hist_base;
    // 原图下半部分
    Mat _hist_half_down;
    // 测试图像一
    Mat _hist_test1;
    // 测试图像二
    Mat _hist_test2;
}

@end

@implementation CompareHistViewController

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
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 430);
    [self.view addSubview:scrollView];
    
    CGFloat offsetY = 20;
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, offsetY, SCREEN_WIDTH - 20, 30)];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.textColor = [UIColor blackColor];
    textLabel.font = [UIFont systemFontOfSize:14.0f];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.text = @"对下方四张图采用四种办法进行直方对比";
    [scrollView addSubview:textLabel];

    offsetY += 30;
    UIButton *btnTestInit = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTestInit.frame = CGRectMake(30, offsetY, SCREEN_WIDTH - 60, 30);
    [btnTestInit setTitle:@"加载图片" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(loadPic) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btnTestInit];
    
    offsetY += 30;
    btnTestInit = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTestInit.frame = CGRectMake(30, offsetY, 120, 30);
    [btnTestInit setTitle:@"Correlation" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(onClickCorrelation) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btnTestInit];
    
    btnTestInit = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTestInit.frame = CGRectMake(170, offsetY, 120, 30);
    [btnTestInit setTitle:@"Chi-square" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(onClickChiSquare) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btnTestInit];
    
    offsetY += 30;
    btnTestInit = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTestInit.frame = CGRectMake(30, offsetY, 120, 30);
    [btnTestInit setTitle:@"Intersection" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(onClickIntersection) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btnTestInit];
    
    btnTestInit = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTestInit.frame = CGRectMake(170, offsetY, 120, 30);
    [btnTestInit setTitle:@"Bhattacharyya" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(onClickBhattacharyya) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btnTestInit];
    
    offsetY += 40;
    _picImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, offsetY, 120, 120)];
    _picImageView.contentMode = UIViewContentModeScaleAspectFit;
    _picImageView.image = [UIImage imageNamed:@"hand_one.jpg"];
    [scrollView addSubview:_picImageView];
    
    _picHalfDown = [[UIImageView alloc] initWithFrame:CGRectMake(170, offsetY, 120, 120)];
    _picHalfDown.contentMode = UIViewContentModeScaleAspectFit;
//    test1Image.image = [UIImage imageNamed:@"hand_two.jpg"];
    [scrollView addSubview:_picHalfDown];
    
    offsetY += 140;
    UIImageView *test1Image = [[UIImageView alloc] initWithFrame:CGRectMake(30, offsetY, 120, 120)];
    test1Image.contentMode = UIViewContentModeScaleAspectFit;
    test1Image.image = [UIImage imageNamed:@"hand_two.jpg"];
    [scrollView addSubview:test1Image];

    test1Image = [[UIImageView alloc] initWithFrame:CGRectMake(170, offsetY, 120, 120)];
    test1Image.contentMode = UIViewContentModeScaleAspectFit;
    test1Image.image = [UIImage imageNamed:@"hand_three.jpg"];
    [scrollView addSubview:test1Image];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"直方图比较"];
    [self createRightButton];
    [self createViews];
    
    _srcImage = [OpenCVUtility UIImageToMat:[UIImage imageNamed:@"hand_one.jpg"]];
    
    [self fetchAllMats];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchAllMats {
    Mat src_base, hsv_base;
    Mat src_test1, hsv_test1;
    Mat src_test2, hsv_test2;
    Mat hsv_half_down;
    
    src_base = [OpenCVUtility UIImageToMat:[UIImage imageNamed:@"hand_one.jpg"]];
    src_test1 = [OpenCVUtility UIImageToMat:[UIImage imageNamed:@"hand_two.jpg"]];
    src_test2 = [OpenCVUtility UIImageToMat:[UIImage imageNamed:@"hand_three.jpg"]];
    
    // 转换到hsv
    cvtColor(src_base, hsv_base, CV_BGR2HSV);
    cvtColor(src_test1, hsv_test1, CV_BGR2HSV);
    cvtColor(src_test2, hsv_test2, CV_BGR2HSV);
    
    hsv_half_down = hsv_base(cv::Range(hsv_base.rows / 2, hsv_base.rows - 1), cv::Range(0, hsv_base.cols - 1));
    
    // show half down image
    Mat tmp;
    cvtColor(hsv_half_down, tmp, CV_HSV2BGR);
    _picHalfDown.image = [OpenCVUtility MatToUIImage:tmp];
    
    // 对hue通道使用50个bin, 对saturation通道使用60个bin
    int h_bins = 50; int s_bins = 60;
    int histSize[] = {h_bins, s_bins};
    
    // hue的取值范围[0, 256], staturation取值范围[0, 180]
    float h_ranges[] = {0, 256};
    float s_ranges[] = {0, 180};
    const float *ranges[] = {h_ranges, s_ranges};
    
    // 使用第0通道和第1通道
    int channels[] = {0, 1};
    
    // 计算hsv图像直方图
    calcHist(&hsv_base, 1, channels, Mat(), _hist_base, 2, histSize, ranges, true, false);
    normalize(_hist_base, _hist_base, 0, 1, NORM_MINMAX, -1, Mat());
    
    calcHist(&hsv_half_down, 1, channels, Mat(), _hist_half_down, 2, histSize, ranges, true, false);
    normalize(_hist_half_down, _hist_half_down, 0, 1, NORM_MINMAX, -1, Mat());
    
    calcHist(&hsv_test1, 1, channels, Mat(), _hist_test1, 2, histSize, ranges, true, false);
    normalize(_hist_test1, _hist_test1, 0, 1, NORM_MINMAX, -1, Mat());
    
    calcHist(&hsv_test2, 1, channels, Mat(), _hist_test2, 2, histSize, ranges, true, false);
    normalize(_hist_test2, _hist_test2, 0, 1, NORM_MINMAX, -1, Mat());
}

- (void)loadPic {
    _picImageView.image = [UIImage imageNamed:@"hand_one.jpg"];
}

- (void)onClickCorrelation {
    double base_base = compareHist(_hist_base, _hist_base, 0);
    double base_half = compareHist(_hist_base, _hist_half_down, 0);
    double base_test1 = compareHist(_hist_base, _hist_test1, 0);
    double base_test2 = compareHist(_hist_base, _hist_test2, 0);
    
    NSString *message = [NSString stringWithFormat:@"correlation直方图比较结果:%f, %f, %f, %f\n [值越大越相似] \n [共四张图像,见代码]", base_base, base_half, base_test1, base_test2];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)onClickChiSquare {
    double base_base = compareHist(_hist_base, _hist_base, 1);
    double base_half = compareHist(_hist_base, _hist_half_down, 1);
    double base_test1 = compareHist(_hist_base, _hist_test1, 1);
    double base_test2 = compareHist(_hist_base, _hist_test2, 1);
    
    NSString *message = [NSString stringWithFormat:@"ChiSquare直方图比较结果:%f, %f, %f, %f\n [值越小越相似] \n [共四张图像,见代码]", base_base, base_half, base_test1, base_test2];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)onClickIntersection {
    double base_base = compareHist(_hist_base, _hist_base, 2);
    double base_half = compareHist(_hist_base, _hist_half_down, 2);
    double base_test1 = compareHist(_hist_base, _hist_test1, 2);
    double base_test2 = compareHist(_hist_base, _hist_test2, 2);
    
    NSString *message = [NSString stringWithFormat:@"Intersection直方图比较结果:%f, %f, %f, %f\n [值越大越相似] \n [共四张图像,见代码]", base_base, base_half, base_test1, base_test2];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)onClickBhattacharyya {
    double base_base = compareHist(_hist_base, _hist_base, 3);
    double base_half = compareHist(_hist_base, _hist_half_down, 3);
    double base_test1 = compareHist(_hist_base, _hist_test1, 3);
    double base_test2 = compareHist(_hist_base, _hist_test2, 3);
    
    NSString *message = [NSString stringWithFormat:@"Bhattacharyya直方图比较结果:%f, %f, %f, %f\n [值越小越相似] \n [共四张图像,见代码]", base_base, base_half, base_test1, base_test2];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)onClickStudy {
    [super onClickStudy];
    
    WebViewController *controller = [[WebViewController alloc] init];
    controller.titleString = @"直方图比较";
    controller.urlString = @"http://www.opencv.org.cn/opencvdoc/2.3.2/html/doc/tutorials/imgproc/histograms/histogram_comparison/histogram_comparison.html#histogram-comparison";
    [self.navigationController pushViewController:controller animated:YES];
}

@end
