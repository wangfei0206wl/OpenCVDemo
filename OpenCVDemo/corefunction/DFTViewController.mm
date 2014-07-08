//
//  DFTViewController.m
//  OpenCVDemo
//
//  Created by wangfei on 14-7-8.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import "DFTViewController.h"
#import "WebViewController.h"
#import "PublicDefines.h"
#import "OpenCVUtility.h"

@interface DFTViewController () {
    UIImageView *_picImageView;
}

@end

@implementation DFTViewController

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
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 370);
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
    [btnTestInit setTitle:@"傅立叶变换" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(onClickDFT) forControlEvents:UIControlEventTouchUpInside];
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
    [self setTitle:@"离散傅里叶变换"];
    [self createRightButton];
    [self createViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadPic {
    _picImageView.image = [UIImage imageNamed:@"result_normal.jpg"];
}

/*???????这个可能有问题*/
- (void)onClickDFT {
    // 进行傅立叶变换
    NSString *imageFile = [[NSBundle mainBundle] pathForResource:@"result_normal" ofType:@"jpg"];
    Mat dst;
    // 必须为灰度图
    Mat src = imread([imageFile UTF8String], CV_LOAD_IMAGE_GRAYSCALE);
    
    // 计算最佳尺寸，并进行填充
    Mat padded;
    int m = getOptimalDFTSize(src.rows);
    int n = getOptimalDFTSize(src.cols);
    copyMakeBorder(src, padded, 0, m - src.rows, 0, n - src.cols, BORDER_CONSTANT, Scalar::all(0));
    
    // 增加一个0通道
    Mat planes[] = {Mat_<float>(padded), Mat::zeros(padded.rows, padded.cols, CV_32F)};
    Mat complexI;
    merge(planes, 2, complexI);
    
    // 进行傅立叶变换
    dft(complexI, complexI);
    
    // 分离出实数与复数部分
    split(complexI, planes);
    magnitude(planes[0], planes[1], planes[0]);
    dst = planes[0];
    
    // 转换到对数尺度
    dst += Scalar::all(1);
    log(dst, dst);
    
    // 剪切和重分布幅度图像限
    dst = dst(cv::Rect(0, 0, dst.cols & -2, dst.rows & -2));
    
    int cx = dst.cols / 2; int cy = dst.rows / 2;
    Mat q0(dst, cv::Rect(0, 0, cx, cy));
    Mat q1(dst, cv::Rect(cx, 0, cx, cy));
    Mat q2(dst, cv::Rect(0, cy, cx, cy));
    Mat q3(dst, cv::Rect(cx, cy, cx, cy));
    
    Mat tmp;
    q0.copyTo(tmp);
    q3.copyTo(q0);
    tmp.copyTo(q3);
    
    q1.copyTo(tmp);
    q2.copyTo(q1);
    tmp.copyTo(q2);
    
    // 归一化
    normalize(dst, dst, 0, 1, CV_MINMAX, -1, Mat());
    
    _picImageView.image = [OpenCVUtility MatToUIImage:dst];
}

- (void)onClickStudy {
    [super onClickStudy];
    
    WebViewController *controller = [[WebViewController alloc] init];
    controller.titleString = @"离散傅里叶变换";
    controller.urlString = @"http://www.opencv.org.cn/opencvdoc/2.3.2/html/doc/tutorials/core/discrete_fourier_transform/discrete_fourier_transform.html#discretfouriertransform";
    [self.navigationController pushViewController:controller animated:YES];
}

@end
