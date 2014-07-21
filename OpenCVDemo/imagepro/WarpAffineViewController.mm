//
//  WarpAffineViewController.m
//  OpenCVDemo
//
//  Created by wangfei on 14-7-21.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import "WarpAffineViewController.h"
#import "WebViewController.h"
#import "PublicDefines.h"
#import "OpenCVUtility.h"

@interface WarpAffineViewController () {
    UIImageView *_picImageView;
    
    // 原始图像
    Mat _srcImage;
}

@end

@implementation WarpAffineViewController

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
    btnTestInit.frame = CGRectMake(30, offsetY, 120, 30);
    [btnTestInit setTitle:@"仿射变换" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(onClickWarpAffine) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btnTestInit];
    
    btnTestInit = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTestInit.frame = CGRectMake(170, offsetY, 120, 30);
    [btnTestInit setTitle:@"图像旋转" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(onClickRotation) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btnTestInit];
    
    offsetY += 40;
    _picImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, offsetY, (SCREEN_WIDTH - 60), (SCREEN_WIDTH - 60))];
    _picImageView.contentMode = UIViewContentModeCenter;
    [scrollView addSubview:_picImageView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"仿射变换"];
    [self createRightButton];
    [self createViews];
    
    _srcImage = [OpenCVUtility UIImageToMat:[UIImage imageNamed:@"scenery.jpg"]];
    _picImageView.image = [UIImage imageNamed:@"scenery.jpg"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadPic {
    _picImageView.image = [UIImage imageNamed:@"scenery.jpg"];
}

// 对图像扭曲
- (void)onClickWarpAffine {
    cv::Point2f srcTri[3];
    cv::Point2f dstTri[3];
    
    Mat warp_mat(2, 3, CV_32FC1);
    Mat warp_dst;
    
    warp_dst = Mat::zeros(_srcImage.rows, _srcImage.cols, _srcImage.type());
    
    // 设置源图像和目标图像上的三组点以计算仿射矩阵
    srcTri[0] = cv::Point2f(0, 0);
    srcTri[1] = cv::Point2f(_srcImage.cols - 1, 0);
    srcTri[2] = cv::Point2f(0, _srcImage.rows - 1);
    
    dstTri[0] = cv::Point2f(_srcImage.cols * 0.0, _srcImage.rows * 0.33);
    dstTri[1] = cv::Point2f(_srcImage.cols * 0.85, _srcImage.rows * 0.25);
    dstTri[2] = cv::Point2f(_srcImage.cols * 0.15, _srcImage.rows * 0.7);
    
    // 求得仿射变换
    warp_mat = getAffineTransform(srcTri, dstTri);
    
    // 对源图像应用此仿射变换
    warpAffine(_srcImage, warp_dst, warp_mat, warp_dst.size());
    
    _picImageView.image = [OpenCVUtility MatToUIImage:warp_dst];
}

// 对图像旋转
- (void)onClickRotation {
    Mat rotate_mat(2, 3, CV_32FC1);
    Mat rotate_dst;
    
    rotate_dst = Mat::zeros(_srcImage.rows, _srcImage.cols, _srcImage.type());
    
    // 计算图像中心顺时针旋转50度缩放因子为0.6的旋转矩阵
    cv::Point center = cv::Point(_srcImage.cols / 2, _srcImage.rows / 2);
    double angle = -50.0f;
    double scale = 0.6;
    
    // 求得旋转矩阵
    rotate_mat = getRotationMatrix2D(center, angle, scale);
    
    // 对图像应用此旋转矩阵
    warpAffine(_srcImage, rotate_dst, rotate_mat, rotate_dst.size());
    
    _picImageView.image = [OpenCVUtility MatToUIImage:rotate_dst];
}

- (void)onClickStudy {
    [super onClickStudy];
    
    WebViewController *controller = [[WebViewController alloc] init];
    controller.titleString = @"仿射变换";
    controller.urlString = @"http://www.opencv.org.cn/opencvdoc/2.3.2/html/doc/tutorials/imgproc/imgtrans/warp_affine/warp_affine.html#warp-affine";
    [self.navigationController pushViewController:controller animated:YES];
}

@end
