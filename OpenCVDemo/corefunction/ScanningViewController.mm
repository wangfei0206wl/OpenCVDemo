//
//  ScanningViewController.m
//  OpenCVDemo
//
//  Created by wangfei on 14-7-3.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import "ScanningViewController.h"
#import "WebViewController.h"
#import "PublicDefines.h"
#import "OpenCVUtility.h"

@interface ScanningViewController () {
    cv::Mat _srcMat;
    
    UIImageView *_picImageView;
}

@end

@implementation ScanningViewController

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
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 450);
    [self.view addSubview:scrollView];
    
    UIButton *btnTestInit = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTestInit.frame = CGRectMake(60, 20, (SCREEN_WIDTH - 120), 30);
    [btnTestInit setTitle:@"加载图片" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(loadPic) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btnTestInit];
    
    UIButton *btnTest = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTest.frame = CGRectMake(60, 50, (SCREEN_WIDTH - 120), 30);
    [btnTest setTitle:@"指针遍历" forState:UIControlStateNormal];
    [btnTest addTarget:self action:@selector(forTestOne) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btnTest];
    
    UIButton *btnTestTwo = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTestTwo.frame = CGRectMake(60, 80, (SCREEN_WIDTH - 120), 30);
    [btnTestTwo setTitle:@"迭代遍历" forState:UIControlStateNormal];
    [btnTestTwo addTarget:self action:@selector(forTestTwo) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btnTestTwo];
    
    UIButton *btnTestThree = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTestThree.frame = CGRectMake(60, 110, (SCREEN_WIDTH - 120), 30);
    [btnTestThree setTitle:@"返回值地址计算遍历" forState:UIControlStateNormal];
    [btnTestThree addTarget:self action:@selector(forTestThree) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btnTestThree];
    
    UIButton *btnTestFour = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTestFour.frame = CGRectMake(60, 140, (SCREEN_WIDTH - 120), 30);
    [btnTestFour setTitle:@"LUT遍历" forState:UIControlStateNormal];
    [btnTestFour addTarget:self action:@selector(forTestFour) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btnTestFour];

    
    _picImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 170, (SCREEN_WIDTH - 60), (SCREEN_WIDTH - 60))];
    _picImageView.contentMode = UIViewContentModeScaleAspectFit;
    [scrollView addSubview:_picImageView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"扫描图像"];
    [self createRightButton];
    [self createViews];
}

- (void)loadPic {
    _picImageView.image = [UIImage imageNamed:@"lena.jpg"];
}

- (void)forTestOne {
    // 高效的方法遍历图像矩阵
    _srcMat = [OpenCVUtility UIImageToMat:[UIImage imageNamed:@"lena.jpg"]];
    double t = getTickCount();
  
    uchar table[256];
    for (int i = 0; i < 256; i++) {
        table[i] = i * 125 / 255;
    }
    
    CV_Assert(_srcMat.depth() != sizeof(uchar));
    
    int channels = _srcMat.channels();
    int nRows = _srcMat.rows * channels;
    int nCols = _srcMat.cols;
    
    if (_srcMat.isContinuous()) {
        nCols *= nRows;
        nRows = 1;
    }
    
    int i,j;
    uchar *p;
    for (i = 0; i < nRows; i++) {
        p = _srcMat.ptr<uchar>(i);
        for (j = 0; j < nCols; j++) {
            p[j] = table[p[j]];
        }
    }
    
    _picImageView.image = [OpenCVUtility MatToUIImage:_srcMat];
    
    t = (getTickCount() - t) / getTickFrequency();
    
    NSLog(@"------efficient scanning time:%lf", t);
}

- (void)forTestTwo {
    // 迭代法遍历图像矩阵
    _srcMat = [OpenCVUtility UIImageToMat:[UIImage imageNamed:@"lena.jpg"]];
    double t = getTickCount();
    
    uchar table[256];
    for (int i = 0; i < 256; i++) {
        table[i] = i * 125 / 255;
    }
    
    CV_Assert(_srcMat.depth() != sizeof(uchar));
    
    const int channels = _srcMat.channels();
    switch(channels) {
        case 1:
        {
            MatIterator_<uchar> it, end;
            for (it = _srcMat.begin<uchar>(), end = _srcMat.end<uchar>(); it != end; it++) {
                *it = table[*it];
            }
        }
            break;
        case 3:
        {
            MatIterator_<Vec3b> it, end;
            for (it = _srcMat.begin<Vec3b>(), end = _srcMat.end<Vec3b>(); it != end; it++) {
                (*it)[0] = table[(*it)[0]];
                (*it)[1] = table[(*it)[1]];
                (*it)[2] = table[(*it)[2]];
            }
        }
        case 4:
        {
            MatIterator_<Vec4b> it, end;
            for (it = _srcMat.begin<Vec4b>(), end = _srcMat.end<Vec4b>(); it != end; it++) {
                (*it)[0] = table[(*it)[0]];
                (*it)[1] = table[(*it)[1]];
                (*it)[2] = table[(*it)[2]];
            }
        }
            break;
            break;
    }

    _picImageView.image = [OpenCVUtility MatToUIImage:_srcMat];
    
    t = (getTickCount() - t) / getTickFrequency();
    
    NSLog(@"------iterator scanning time:%lf", t);
}

- (void)forTestThree {
    // 通过相关返回值的On-the-fly地址计算遍历图像矩阵
    _srcMat = [OpenCVUtility UIImageToMat:[UIImage imageNamed:@"lena.jpg"]];
    double t = getTickCount();
   
    uchar table[256];
    for (int i = 0; i < 256; i++) {
        table[i] = i * 125 / 255;
    }
    
    CV_Assert(_srcMat.depth() != sizeof(uchar));
    
    const int channels = _srcMat.channels();
    switch(channels) {
        case 1:
        {
            for (int i = 0; i < _srcMat.rows; i++) {
                for (int j = 0; j < _srcMat.cols; j++) {
                    _srcMat.at<uchar>(i, j) = table[_srcMat.at<uchar>(i, j)];
                }
            }
        }
            break;
        case 3:
        {
            Mat_<Vec3b> _tmp = _srcMat;
            for (int i = 0; i < _srcMat.rows; i++) {
                for (int j = 0; j < _srcMat.cols; j++) {
                    _tmp(i, j)[0] = table[_tmp(i, j)[0]];
                    _tmp(i, j)[1] = table[_tmp(i, j)[1]];
                    _tmp(i, j)[2] = table[_tmp(i, j)[2]];
                }
            }
            _srcMat = _tmp;
        }
            break;
        case 4:
        {
            Mat_<Vec4b> _tmp = _srcMat;
            for (int i = 0; i < _srcMat.rows; i++) {
                for (int j = 0; j < _srcMat.cols; j++) {
                    _tmp(i, j)[0] = table[_tmp(i, j)[0]];
                    _tmp(i, j)[1] = table[_tmp(i, j)[1]];
                    _tmp(i, j)[2] = table[_tmp(i, j)[2]];
                }
            }
            _srcMat = _tmp;
        }
            break;
    }
    
    _picImageView.image = [OpenCVUtility MatToUIImage:_srcMat];
    
    t = (getTickCount() - t) / getTickFrequency();
    
    NSLog(@"------on-the-fly scanning time:%lf", t);
}

- (void)forTestFour {
    // 核心函数LUT遍历图像矩阵
    _srcMat = [OpenCVUtility UIImageToMat:[UIImage imageNamed:@"lena.jpg"]];
    double t = getTickCount();

    Mat lookUpTable(1, 256, CV_8U);
    uchar *p = lookUpTable.data;
    
    for (int i = 0; i < 256; i++) {
        p[i] = i * 125 / 255;
    }
    
    CV_Assert(_srcMat.depth() != sizeof(uchar));
    
    LUT(_srcMat, lookUpTable, _srcMat);
    
    _picImageView.image = [OpenCVUtility MatToUIImage:_srcMat];
    
    t = (getTickCount() - t) / getTickFrequency();
    
    NSLog(@"------lut scanning time:%lf", t);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onClickStudy {
    [super onClickStudy];
    
    WebViewController *controller = [[WebViewController alloc] init];
    controller.titleString = @"扫描图像";
    controller.urlString = @"http://www.opencv.org.cn/opencvdoc/2.3.2/html/doc/tutorials/core/how_to_scan_images/how_to_scan_images.html#howtoscanimagesopencv";
    [self.navigationController pushViewController:controller animated:YES];
}

@end
