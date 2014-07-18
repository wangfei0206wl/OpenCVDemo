//
//  RemapViewController.m
//  OpenCVDemo
//
//  Created by wangfei on 14-7-18.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import "RemapViewController.h"
#import "WebViewController.h"
#import "PublicDefines.h"
#import "OpenCVUtility.h"

@interface RemapViewController () {
    UIImageView *_picImageView;
    
    // 原始图像
    Mat _srcImage;
}

@end

@implementation RemapViewController

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
    [btnTestInit setTitle:@"垂直重映射" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(onClickVertical) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btnTestInit];

    btnTestInit = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTestInit.frame = CGRectMake(170, offsetY, 120, 30);
    [btnTestInit setTitle:@"水平重映射" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(onClickHorizon) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btnTestInit];
    
    offsetY += 30;
    btnTestInit = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTestInit.frame = CGRectMake(30, offsetY, 120, 30);
    [btnTestInit setTitle:@"双向重映射" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(onClickHAndV) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btnTestInit];
    
    btnTestInit = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTestInit.frame = CGRectMake(170, offsetY, 120, 30);
    [btnTestInit setTitle:@"居中缩小重映射" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(onClickSmall) forControlEvents:UIControlEventTouchUpInside];
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
    [self setTitle:@"Remapping重映射"];
    [self createRightButton];
    [self createViews];
    
    _srcImage = [OpenCVUtility UIImageToMat:[UIImage imageNamed:@"big_dog.jpg"]];
    _picImageView.image = [UIImage imageNamed:@"big_dog.jpg"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadPic {
    _picImageView.image = [UIImage imageNamed:@"big_dog.jpg"];
}

- (void)onClickVertical {
    Mat dst;
    Mat map_x, map_y;
    
    dst.create(_srcImage.rows, _srcImage.cols, _srcImage.type());
    map_x.create(_srcImage.rows, _srcImage.cols, CV_32FC1);
    map_y.create(_srcImage.rows, _srcImage.cols, CV_32FC1);
    
    for (int j = 0; j < _srcImage.rows; j++) {
        for (int i = 0; i < _srcImage.cols; i++) {
            map_x.at<float>(j, i) = i;
            map_y.at<float>(j, i) = _srcImage.rows - j;
        }
    }
    
    remap(_srcImage, dst, map_x, map_y, CV_INTER_LINEAR, BORDER_CONSTANT, Scalar(0, 0, 0));
    
    _picImageView.image = [OpenCVUtility MatToUIImage:dst];
}

- (void)onClickHorizon {
    Mat dst;
    Mat map_x, map_y;
    
    dst.create(_srcImage.rows, _srcImage.cols, _srcImage.type());
    map_x.create(_srcImage.rows, _srcImage.cols, CV_32FC1);
    map_y.create(_srcImage.rows, _srcImage.cols, CV_32FC1);
    
    for (int j = 0; j < _srcImage.rows; j++) {
        for (int i = 0; i < _srcImage.cols; i++) {
            map_x.at<float>(j, i) = _srcImage.cols - i;
            map_y.at<float>(j, i) = j;
        }
    }
    
    remap(_srcImage, dst, map_x, map_y, CV_INTER_LINEAR, BORDER_CONSTANT, Scalar(0, 0, 0));
    
    _picImageView.image = [OpenCVUtility MatToUIImage:dst];
}

- (void)onClickHAndV {
    Mat dst;
    Mat map_x, map_y;
    
    dst.create(_srcImage.rows, _srcImage.cols, _srcImage.type());
    map_x.create(_srcImage.rows, _srcImage.cols, CV_32FC1);
    map_y.create(_srcImage.rows, _srcImage.cols, CV_32FC1);
    
    for (int j = 0; j < _srcImage.rows; j++) {
        for (int i = 0; i < _srcImage.cols; i++) {
            map_x.at<float>(j, i) = _srcImage.cols - i;
            map_y.at<float>(j, i) = _srcImage.rows - j;
        }
    }
    
    remap(_srcImage, dst, map_x, map_y, CV_INTER_LINEAR, BORDER_CONSTANT, Scalar(0, 0, 0));
    
    _picImageView.image = [OpenCVUtility MatToUIImage:dst];
}

- (void)onClickSmall {
    Mat dst;
    Mat map_x, map_y;
    
    dst.create(_srcImage.rows, _srcImage.cols, _srcImage.type());
    map_x.create(_srcImage.rows, _srcImage.cols, CV_32FC1);
    map_y.create(_srcImage.rows, _srcImage.cols, CV_32FC1);
    
    for (int j = 0; j < _srcImage.rows; j++) {
        for (int i = 0; i < _srcImage.cols; i++) {
            if (i > _srcImage.cols * 0.25 && i < _srcImage.cols * 0.75
                && j > _srcImage.rows * 0.25 && j < _srcImage.rows * 0.75) {
            map_x.at<float>(j, i) = 2 * (i - _srcImage.cols * 0.25) + 0.5;
            map_y.at<float>(j, i) = 2 * (j - _srcImage.rows * 0.25) + 0.5;
            }
            else {
                map_x.at<float>(j, i) = 0;
                map_y.at<float>(j, i) = 0;
            }
        }
    }
    
    remap(_srcImage, dst, map_x, map_y, CV_INTER_LINEAR, BORDER_CONSTANT, Scalar(0, 0, 0));
    
    _picImageView.image = [OpenCVUtility MatToUIImage:dst];
}

- (void)onClickStudy {
    [super onClickStudy];
    
    WebViewController *controller = [[WebViewController alloc] init];
    controller.titleString = @"Remapping重映射";
    controller.urlString = @"http://www.opencv.org.cn/opencvdoc/2.3.2/html/doc/tutorials/imgproc/imgtrans/remap/remap.html#remap";
    [self.navigationController pushViewController:controller animated:YES];
}

@end
