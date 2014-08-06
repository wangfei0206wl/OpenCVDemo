//
//  FaceDetectViewController.m
//  OpenCVDemo
//
//  Created by wangfei on 14-8-6.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import "FaceDetectViewController.h"
#import "PublicDefines.h"
#import "OpenCVUtility.h"

// 人脸识别类
@interface FaceDetector : NSObject {
    // 人脸识别器
    cv::CascadeClassifier *_faceCasCade;
}

- (void)detectFacesInMat:(Mat *)imageMat;

@end

@implementation FaceDetector

- (id)init {
    if (self = [super init]) {
        [self loadCasCades];
    }
    
    return self;
}

- (void)loadCasCades {
    NSString *facePath = [[NSBundle mainBundle] pathForResource:@"lbpcascade_frontalface" ofType:@"xml"];
    
    _faceCasCade = new CascadeClassifier();
    // 加载人脸特征数据文件
    _faceCasCade->load([facePath UTF8String]);
}

- (void)detectFacesInMat:(Mat *)imageMat {
    std::vector<cv::Rect> faces;
    
    // haar detect
    float haar_scale = 1.15;
    int haar_minNeighbors = 3;
    int haar_flags = 0 | CV_HAAR_SCALE_IMAGE | CV_HAAR_DO_CANNY_PRUNING;
    cv::Size haar_minSize = cvSize(60, 60);
    
    _faceCasCade->detectMultiScale(*imageMat, faces, haar_scale, haar_minNeighbors, haar_flags, haar_minSize);
    
    for (int i = 0; i < faces.size(); i++) {
        cv::Point center(faces[i].x + faces[i].width * 0.5, faces[i].y + faces[i].height * 0.5);
        ellipse(*imageMat, center, cv::Size(faces[i].height / 2, faces[i].width / 2), 0, 0, 360, Scalar(255, 0, 0), 2, 8);

    }
}

@end

@interface FaceDetectViewController () {
    UIImageView *_picImageView;
    
    BOOL _bDetectImage;
    Mat _srcImage;
    CvVideoCamera *_videoCamera;
    FaceDetector *_faceDetector;
}

@end

@implementation FaceDetectViewController

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
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 470);
    [self.view addSubview:scrollView];
    
    CGFloat offsetY = 20;
    UIButton *btnTestInit = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTestInit.frame = CGRectMake(30, offsetY, 120, 30);
    [btnTestInit setTitle:@"加载图片" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(loadPic) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btnTestInit];
    
    btnTestInit = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTestInit.frame = CGRectMake(170, offsetY, 120, 30);
    [btnTestInit setTitle:@"开启摄像头" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(onClickCamera:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btnTestInit];
    
    offsetY += 30;
    btnTestInit = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTestInit.frame = CGRectMake(30, offsetY, SCREEN_WIDTH - 60, 30);
    [btnTestInit setTitle:@"检测人脸" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(onClickDetectFace:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btnTestInit];

    offsetY += 40;
    _picImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, offsetY, (SCREEN_WIDTH - 60), (SCREEN_WIDTH - 60) * 352 / 288)];
    _picImageView.contentMode = UIViewContentModeScaleAspectFit;
    [scrollView addSubview:_picImageView];
    
    _videoCamera = [[CvVideoCamera alloc] initWithParentView:_picImageView];
    _videoCamera.delegate = (id)self;
    _videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionFront;
    _videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    _videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset352x288;
    _videoCamera.defaultFPS = 15;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"人脸识别"];
    [self createViews];
    
    _bDetectImage = YES;
    _faceDetector = [[FaceDetector alloc] init];
    _srcImage = [OpenCVUtility UIImageToMat:[UIImage imageNamed:@"lena.jpg"]];
    [self loadPic];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadPic {
    if (_videoCamera.running) {
        [_videoCamera stop];
    }
    _picImageView.image = [UIImage imageNamed:@"lena.jpg"];
    _bDetectImage = YES;
}

- (void)onClickCamera:(id)sender {
    _bDetectImage = NO;
    if (_videoCamera.running) {
        [_videoCamera stop];
    }
    [_videoCamera start];
}

- (void)onClickDetectFace:(id)sender {
    if (_bDetectImage) {
        [_faceDetector detectFacesInMat:&_srcImage];
    }
}

- (void)processImage:(cv::Mat&)image {
    // 这里可以对图像进行处理
    [_faceDetector detectFacesInMat:&image];
}

@end
