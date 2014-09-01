//
//  VideoCmpViewController.m
//  OpenCVDemo
//
//  Created by wangfei on 14-8-14.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import "VideoCmpViewController.h"
#import "WebViewController.h"
#import "PublicDefines.h"
#import "OpenCVUtility.h"

@interface VideoCmpViewController () {
    Mat _srcImageF;
    Mat _srcImageS;
}

@end

@implementation VideoCmpViewController

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
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 200);
    [self.view addSubview:scrollView];
    
    CGFloat offsetY = 20;
    UIButton *btnTestInit = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTestInit.frame = CGRectMake(30, offsetY, 120, 30);
    [btnTestInit setTitle:@"PSNR算法" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(onClickPSNR:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btnTestInit];
    
    btnTestInit = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTestInit.frame = CGRectMake(170, offsetY, 120, 30);
    [btnTestInit setTitle:@"SSIM算法" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(onClickSSIM:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btnTestInit];

    offsetY += (30 + 20);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, offsetY, 120, 120)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = [UIImage imageNamed:@"lena.jpg"];
    [scrollView addSubview:imageView];

    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(170, offsetY, 120, 120)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = [UIImage imageNamed:@"lena.jpg"];
    [scrollView addSubview:imageView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"视频相似度测量"];
    [self createRightButton];
    [self createViews];
    
    _srcImageF = [OpenCVUtility UIImageToMat:[UIImage imageNamed:@"lena.jpg"]];
    _srcImageS = [OpenCVUtility UIImageToMat:[UIImage imageNamed:@"lena.jpg"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onClickPSNR:(id)sender {
    double value = [self getPSNR:_srcImageF cmpMat:_srcImageS];
    
    NSString *message = [NSString stringWithFormat:@"PSNR 比较结果: %0.2f", value];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)onClickSSIM:(id)sender {
    Scalar value = [self getMSSIM:_srcImageF cmpMat:_srcImageS];
    
    NSString *message = [NSString stringWithFormat:@"SSIM 比较结果: R(%0.2f%%), G(%0.2f%%), B(%0.2f%%)", value.val[2] * 100, value.val[1] * 100, value.val[0] * 100];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

- (double)getPSNR:(const Mat&)I1 cmpMat:(const Mat&)I2 {
    Mat s1;
    absdiff(I1, I2, s1);
    s1.convertTo(s1, CV_32F);
    s1 = s1.mul(s1);
    
    Scalar s = sum(s1);
    
    double sse = s.val[0] + s.val[1] + s.val[2];
    if (sse <= 1e-10) {
        return 0;
    }
    else {
        double mse = sse / (double)(I1.channels() * I1.total());
        double psnr = 10.0 * log10(255 * 255 / mse);
        
        return psnr;
    }
}

- (Scalar)getMSSIM:(const Mat&)i1 cmpMat:(const Mat&)i2 {
    const double C1 = 6.5025, C2 = 58.5225;
    int d = CV_32F;
    
    Mat I1, I2;
    i1.convertTo(I1, d);
    i2.convertTo(I2, d);
    
    Mat I2_2 = I2.mul(I2);
    Mat I1_2 = I1.mul(I1);
    Mat I1_I2 = I1.mul(I2);
    
    Mat mu1, mu2;
    GaussianBlur(I1, mu1, cv::Size(11, 11), 1.5);
    GaussianBlur(I2, mu2, cv::Size(11, 11), 1.5);
    
    Mat mu1_2 = mu1.mul(mu1);
    Mat mu2_2 = mu2.mul(mu2);
    Mat mu1_mu2 = mu1.mul(mu2);
    
    Mat sigma1_2, sigma2_2, sigma12;
    GaussianBlur(I1_2, sigma1_2, cv::Size(11, 11), 1.5);
    sigma1_2 -= mu1_2;
    
    GaussianBlur(I2_2, sigma2_2, cv::Size(11, 11), 1.5);
    sigma2_2 -= mu2_2;
    
    GaussianBlur(I1_I2, sigma12, cv::Size(11, 11), 1.5);
    sigma12 -= mu1_mu2;
    
    Mat t1, t2, t3;
    t1 = 2 * mu1_mu2 + C1;
    t2 = 2 * sigma12 + C2;
    t3 = t1.mul(t2);
    
    t1 = mu1_2 + mu2_2 + C1;
    t2 = sigma1_2 + sigma2_2 + C2;
    t1 = t1.mul(t2);
    
    Mat ssim_map;
    divide(t3, t1, ssim_map);
    
    Scalar mssim = mean(ssim_map);
    
    return mssim;
}

- (void)onClickStudy {
    [super onClickStudy];
    
    WebViewController *controller = [[WebViewController alloc] init];
    controller.titleString = @"视频相似度测量";
    controller.urlString = @"http://www.opencv.org.cn/opencvdoc/2.3.2/html/doc/tutorials/highgui/video-input-psnr-ssim/video-input-psnr-ssim.html#videoinputpsnrmssim";
    [self.navigationController pushViewController:controller animated:YES];
}

@end
