//
//  BaseMatViewController.m
//  OpenCVDemo
//
//  Created by wangfei on 14-7-3.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import "BaseMatViewController.h"
#import "WebViewController.h"
#import "PublicDefines.h"
#import "OpenCVUtility.h"

@interface BaseMatViewController () {
    UIImageView *_picImageView;
}

@end

@implementation BaseMatViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)createViews {
    UIButton *btnTest = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTest.frame = CGRectMake(60, 80, (SCREEN_WIDTH - 120), 44);
    [btnTest setTitle:@"Mat的构造函数与拷贝构造函数" forState:UIControlStateNormal];
    [btnTest addTarget:self action:@selector(forTestOne) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnTest];
 
    UIButton *btnTestTwo = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTestTwo.frame = CGRectMake(60, 130, (SCREEN_WIDTH - 120), 44);
    [btnTestTwo setTitle:@"Mat的区域构造函数" forState:UIControlStateNormal];
    [btnTestTwo addTarget:self action:@selector(forTestTwo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnTestTwo];

    _picImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 180, (SCREEN_WIDTH - 60), (SCREEN_WIDTH - 60))];
    _picImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_picImageView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"Mat-基本图像容器"];
    [self createRightButton];
    [self createViews];
}

- (void)forTestOne {
    cv::Mat A, C;
    // 使用imread有时候会加载不出来图像，加载出来的图像颜色值也不正确
//    NSString *imageFile = [[NSBundle mainBundle] pathForResource:@"lena" ofType:@"jpg"];
//    A = imread([imageFile UTF8String], CV_LOAD_IMAGE_COLOR);
    A = [OpenCVUtility UIImageToMat:[UIImage imageNamed:@"lena.jpg"]];
    cv::Mat B(A);
    
    C = A;
    NSLog(@"------forTest");
//    cv::Mat F = A.clone();
//    Mat G;
//    A.copyTo(G);
    
    _picImageView.image = [OpenCVUtility MatToUIImage:A];
}

- (void)forTestTwo {
    cv::Mat A;
    A = [OpenCVUtility UIImageToMat:[UIImage imageNamed:@"lena.jpg"]];
    
    cv::Mat D(A, cv::Rect(0, A.rows / 4, A.cols, A.rows / 2));
//    cv::Mat D = A(Range(A.rows / 4, 3 * A.rows / 4), Range(A.cols / 4, 3 * A.cols / 4));
    _picImageView.image = [OpenCVUtility MatToUIImage:D];
}

// Mat的各种创建方法
- (void)forTestThree {
    // 创建2行2列矩阵，每个元素由3个无符号字节表示, 每个元素初始化为blue:0, green:0, red:255
    Mat M(2, 2, CV_8UC3, Scalar(0, 0, 255));
    
    // 创建一个3纬矩阵,每个纬度均为2个,每个元素由1个无符号字节表示,每个元素初始化为0
    int sz[3] = {2, 2, 2};
    Mat L(3, sz, CV_8UC(1), Scalar::all(0));
    
    // 创建一个4x4的矩阵，每个元素由2个无符号字节表示
    Mat N;
    N.create(4, 4, CV_8UC(2));
    
    // 创建一个4x4的矩阵，每个元素由一个64位的double表示
    /*
     [1, 0, 0, 0;
      0, 1, 0, 0;
      0, 0, 1, 0;
      0, 0, 0, 1]
     */
    Mat E = Mat::eye(4, 4, CV_64F);
    
    // 创建一个2x2的矩阵，每个元素由一个32位的float表示
    /*
     [1, 1;
      1, 1]
     */
    Mat O = Mat::ones(2, 2, CV_32F);
    
    // 创建一个3x3的矩阵，每个元素由一个8位的无符号字节表示
    /*
     [0, 0, 0;
      0, 0, 0;
      0, 0, 0]
     */
    Mat Z = Mat::zeros(3, 3, CV_8UC1);
    
    // 创建一个3x3的矩阵，每个元素由double类型表示,并初始化值
    /*
     [0, -1, 0;
      -1, 5, -1;
      0, -1, 0]
     */
    Mat C = (Mat_<double>(3, 3) << 0, -1, 0, -1, 5, -1, 0, -1, 0);
    
    // 复制C矩阵中的第二行的数据
    Mat RowClone = C.row(1).clone();
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onClickStudy {
    [super onClickStudy];
    
    WebViewController *controller = [[WebViewController alloc] init];
    controller.titleString = @"Mat-基本图像容器";
    controller.urlString = @"http://www.opencv.org.cn/opencvdoc/2.3.2/html/doc/tutorials/core/mat%20-%20the%20basic%20image%20container/mat%20-%20the%20basic%20image%20container.html#matthebasicimagecontainer";
    [self.navigationController pushViewController:controller animated:YES];
}

@end
