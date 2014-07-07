//
//  MatMaskViewController.m
//  OpenCVDemo
//
//  Created by wangfei on 14-7-4.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import "MatMaskViewController.h"
#import "WebViewController.h"
#import "PublicDefines.h"
#import "OpenCVUtility.h"

@interface MatMaskViewController () {
    UIImageView *_picImageView;
}

@end

@implementation MatMaskViewController

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
    
    UIButton *btnTestInit = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTestInit.frame = CGRectMake(60, 20, (SCREEN_WIDTH - 120), 30);
    [btnTestInit setTitle:@"加载图片" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(loadPic) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btnTestInit];
    
    UIButton *btnTest = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTest.frame = CGRectMake(60, 50, (SCREEN_WIDTH - 120), 30);
    [btnTest setTitle:@"像素访问实现掩码操作" forState:UIControlStateNormal];
    [btnTest addTarget:self action:@selector(forTestOne) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btnTest];
    
    UIButton *btnTestTwo = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTestTwo.frame = CGRectMake(60, 80, (SCREEN_WIDTH - 120), 30);
    [btnTestTwo setTitle:@"filter2D实现掩码操作" forState:UIControlStateNormal];
    [btnTestTwo addTarget:self action:@selector(forTestTwo) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btnTestTwo];
    
    _picImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 110, (SCREEN_WIDTH - 60), (SCREEN_WIDTH - 60))];
    _picImageView.contentMode = UIViewContentModeScaleAspectFit;
    [scrollView addSubview:_picImageView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"矩阵的掩码操作"];
    [self createRightButton];
    [self createViews];
}

- (void)loadPic {
    _picImageView.image = [UIImage imageNamed:@"lena.jpg"];
}

- (void)forTestOne {
    //像素访问实现掩码操作
    Mat src, dst;
    
    src = [OpenCVUtility UIImageToMat:[UIImage imageNamed:@"lena.jpg"]];
    CV_Assert(src.depth() == CV_8U);
    dst.create(src.rows, src.cols, src.type());
    const int nChannels = src.channels();
    
    for (int j = 1; j < src.rows - 1; j++) {
        const uchar *previous = src.ptr<uchar>(j - 1);
        const uchar *current = src.ptr<uchar>(j);
        const uchar *next = src.ptr<uchar>(j + 1);
        
        uchar *output = dst.ptr<uchar>(j);
        for (int i = nChannels; i < nChannels * (src.cols - 1); i++) {
            *output++ = saturate_cast<uchar>(5 * current[i] -
                                             current[i - nChannels] - current[i + nChannels]
                                             - previous[i] - next[i]);
        }
    }
    
    dst.row(0).setTo(Scalar(0));
    dst.row(dst.rows - 1).setTo(Scalar(0));
    dst.col(0).setTo(Scalar(0));
    dst.col(dst.cols - 1).setTo(Scalar(0));
    
    _picImageView.image = [OpenCVUtility MatToUIImage:dst];
}

- (void)forTestTwo {
    // filter2D实现掩码操作
    Mat src, dst;
    
    src = [OpenCVUtility UIImageToMat:[UIImage imageNamed:@"lena.jpg"]];
    
    CV_Assert(src.depth() == CV_8U);
    Mat kern = (Mat_<char>(3, 3) << 0, -1, 0, -1, 5, -1, 0, -1,0);
    filter2D(src, dst, src.depth(), kern);
    
    _picImageView.image = [OpenCVUtility MatToUIImage:dst];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onClickStudy {
    [super onClickStudy];
    
    WebViewController *controller = [[WebViewController alloc] init];
    controller.titleString = @"矩阵的掩码操作";
    controller.urlString = @"http://www.opencv.org.cn/opencvdoc/2.3.2/html/doc/tutorials/core/mat-mask-operations/mat-mask-operations.html#maskoperationsfilter";
    [self.navigationController pushViewController:controller animated:YES];
}

@end
