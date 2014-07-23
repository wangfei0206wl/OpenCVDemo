//
//  CalcHistViewController.m
//  OpenCVDemo
//
//  Created by wangfei on 14-7-22.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import "CalcHistViewController.h"
#import "WebViewController.h"
#import "PublicDefines.h"
#import "OpenCVUtility.h"

@interface CalcHistViewController () {
    UIImageView *_picImageView;
    
    // 原始图像
    Mat _srcImage;
}

@end

@implementation CalcHistViewController

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
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 360);
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
    [btnTestInit setTitle:@"直方图计算" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(onClickCalcHist) forControlEvents:UIControlEventTouchUpInside];
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
    [self setTitle:@"直方图计算"];
    [self createRightButton];
    [self createViews];
    
    _srcImage = [OpenCVUtility UIImageToMat:[UIImage imageNamed:@"scenery_new.jpg"]];
    _picImageView.image = [UIImage imageNamed:@"scenery_new.jpg"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadPic {
    _picImageView.image = [UIImage imageNamed:@"scenery_new.jpg"];
}

- (void)onClickCalcHist {
    cv::vector<Mat> rgb_planes;
    
    // 将多通道分隔成单通道Mat
    split(_srcImage, rgb_planes);
    
    // 设定bins数目
    int histSize = 255;
    
    // 设定取值范围
    float range[] = {0, 255};
    const float *histRange = {range};
    bool uniform = true;
    bool accumulate = false;
    
    Mat r_hist, g_hist, b_hist;
    
    // 计算直方图
    calcHist(&rgb_planes[0], 1, 0, Mat(), r_hist, 1, &histSize, &histRange, uniform, accumulate);
    calcHist(&rgb_planes[1], 1, 0, Mat(), g_hist, 1, &histSize, &histRange, uniform, accumulate);
    calcHist(&rgb_planes[2], 1, 0, Mat(), b_hist, 1, &histSize, &histRange, uniform, accumulate);
    
    // 创建直方图画布
    int hist_w = 400; int hist_h = 400;
    int bin_w = cvRound((double)hist_w / histSize);
    
    Mat histImage(hist_w, hist_h, CV_8UC3, Scalar(0, 0, 0));
    
    // 将直方图归一化到范围[0, histImage.rows]
    normalize(r_hist, r_hist, 0, histImage.rows, NORM_MINMAX, -1, Mat());
    normalize(g_hist, g_hist, 0, histImage.rows, NORM_MINMAX, -1, Mat());
    normalize(b_hist, b_hist, 0, histImage.rows, NORM_MINMAX, -1, Mat());
    
    //在直方图画布上画直方图
    for (int i = 0; i < histSize; i++) {
        line(histImage, cv::Point(bin_w * (i - 1), hist_h - cvRound(r_hist.at<float>(i - 1))), cv::Point(bin_w * i, hist_h - cvRound(r_hist.at<float>(i))), Scalar(0, 0, 255), 2, 8, 0);
        line(histImage, cv::Point(bin_w * (i - 1), hist_h - cvRound(g_hist.at<float>(i - 1))), cv::Point(bin_w * i, hist_h - cvRound(g_hist.at<float>(i))), Scalar(0, 255, 0), 2, 8, 0);
        line(histImage, cv::Point(bin_w * (i - 1), hist_h - cvRound(b_hist.at<float>(i - 1))), cv::Point(bin_w * i, hist_h - cvRound(b_hist.at<float>(i))), Scalar(255, 0, 0), 2, 8, 0);
    }
    
    _picImageView.image = [OpenCVUtility MatToUIImage:histImage];
}

- (void)onClickStudy {
    [super onClickStudy];
    
    WebViewController *controller = [[WebViewController alloc] init];
    controller.titleString = @"直方图计算";
    controller.urlString = @"http://www.opencv.org.cn/opencvdoc/2.3.2/html/doc/tutorials/imgproc/histograms/histogram_calculation/histogram_calculation.html#histogram-calculation";
    [self.navigationController pushViewController:controller animated:YES];
}

@end
