//
//  MatchTempViewController.m
//  OpenCVDemo
//
//  Created by wangfei on 14-7-23.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import "MatchTempViewController.h"
#import "WebViewController.h"
#import "PublicDefines.h"
#import "OpenCVUtility.h"

@interface MatchTempViewController () {
    // 原始图像
    UIImageView *_picImageView;
    // 图像匹配模板
    UIImageView *_tmpImageView;
    
    // 原始图像
    Mat _srcImage;
    // 模板图像
    Mat _tmpImage;
}

@end

@implementation MatchTempViewController

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
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 600);
    [self.view addSubview:scrollView];
    
    CGFloat offsetY = 20;
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, offsetY, SCREEN_WIDTH - 20, 30)];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.textColor = [UIColor blackColor];
    textLabel.font = [UIFont systemFontOfSize:14.0f];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.text = @"对图像采用不同的匹配方法进行匹配";
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
    [btnTestInit setTitle:@"SQDIFF" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(onClickSqdiff) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btnTestInit];
    
    btnTestInit = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTestInit.frame = CGRectMake(170, offsetY, 120, 30);
    [btnTestInit setTitle:@"SQDIFF_NORMED" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(onClickSqdiffN) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btnTestInit];
    
    offsetY += 30;
    btnTestInit = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTestInit.frame = CGRectMake(30, offsetY, 120, 30);
    [btnTestInit setTitle:@"CCORR" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(onClickCcorr) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btnTestInit];
    
    btnTestInit = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTestInit.frame = CGRectMake(170, offsetY, 120, 30);
    [btnTestInit setTitle:@"CCORR_NORMED" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(onClickCcorrN) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btnTestInit];
    
    offsetY += 30;
    btnTestInit = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTestInit.frame = CGRectMake(30, offsetY, 120, 30);
    [btnTestInit setTitle:@"CCOEFF" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(onClickCcoeff) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btnTestInit];
    
    btnTestInit = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTestInit.frame = CGRectMake(170, offsetY, 120, 30);
    [btnTestInit setTitle:@"CCOEFF_NORMED" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(onClickCcoeffN) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btnTestInit];

    offsetY += 40;
    _tmpImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 120) / 2, offsetY, 120, 120)];
    _tmpImageView.contentMode = UIViewContentModeScaleAspectFit;
    [scrollView addSubview:_tmpImageView];

    offsetY += 120;
    _picImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, offsetY, SCREEN_WIDTH - 60, SCREEN_WIDTH - 60)];
    _picImageView.contentMode = UIViewContentModeScaleAspectFit;
    [scrollView addSubview:_picImageView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"模板匹配"];
    [self createRightButton];
    [self createViews];
    
    _srcImage = [OpenCVUtility UIImageToMat:[UIImage imageNamed:@"lena.jpg"]];
    _tmpImage = [OpenCVUtility UIImageToMat:[UIImage imageNamed:@"lena_temp.jpg"]];
    _picImageView.image = [UIImage imageNamed:@"lena.jpg"];
    _tmpImageView.image = [UIImage imageNamed:@"lena_temp.jpg"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)matchImageWithMethod:(int)method {
    Mat image_display, result;
    
    image_display = _srcImage.clone();
    
    // 创建匹配矩阵
    int result_cols = _srcImage.cols - _tmpImage.cols + 1;
    int result_rows = _srcImage.rows - _tmpImage.rows + 1;
    result.create(result_rows, result_cols, CV_32FC1);
    
    // 进行匹配和归一化
    matchTemplate(_srcImage, _tmpImage, result, method);
    normalize(result, result, 0, 1, NORM_MINMAX, -1, Mat());
    
    // 通过minMaxLoc定位最匹配的位置
    double minVal; double maxVal; cv::Point minLoc; cv::Point maxLoc;
    cv::Point matchLoc;
    
    minMaxLoc(result, &minVal, &maxVal, &minLoc, & maxLoc, Mat());
    
    if (method == CV_TM_SQDIFF || method == CV_TM_SQDIFF_NORMED) {
        matchLoc = minLoc;
    }
    else {
        matchLoc = maxLoc;
    }
    
    // 原图中框出匹配位置
    rectangle(image_display, matchLoc, cv::Point(matchLoc.x + _tmpImage.cols, matchLoc.y + _tmpImage.rows), Scalar::all(255), 2, 8, 0);
    
    _picImageView.image = [OpenCVUtility MatToUIImage:image_display];
}

- (void)loadPic {
    _picImageView.image = [UIImage imageNamed:@"lena.jpg"];
}

- (void)onClickSqdiff {
    // 平方差匹配(CV_TM_SQDIFF)
    [self matchImageWithMethod:CV_TM_SQDIFF];
}

- (void)onClickSqdiffN {
    // 标准平方差匹配(CV_TM_SQDIFF_NORMED)
    [self matchImageWithMethod:CV_TM_SQDIFF_NORMED];
}

- (void)onClickCcorr {
    // 相关匹配(CV_TM_CCORR)
    [self matchImageWithMethod:CV_TM_CCORR];
}

- (void)onClickCcorrN {
    // 标准相关匹配(CV_TM_CCORR_NORMED)
    [self matchImageWithMethod:CV_TM_CCORR_NORMED];
}

- (void)onClickCcoeff {
    // 相关匹配(CV_TM_CCOEFF)
    [self matchImageWithMethod:CV_TM_CCOEFF];
}

- (void)onClickCcoeffN {
    // 相关匹配(CV_TM_CCOEFF_NORMED)
    [self matchImageWithMethod:CV_TM_CCOEFF_NORMED];
}

- (void)onClickStudy {
    [super onClickStudy];
    
    WebViewController *controller = [[WebViewController alloc] init];
    controller.titleString = @"模板匹配";
    controller.urlString = @"http://www.opencv.org.cn/opencvdoc/2.3.2/html/doc/tutorials/imgproc/histograms/template_matching/template_matching.html#template-matching";
    [self.navigationController pushViewController:controller animated:YES];
}

@end
