//
//  VideoCreateViewController.m
//  OpenCVDemo
//
//  Created by wangfei on 14-9-2.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import "VideoCreateViewController.h"
#import "WebViewController.h"
#import "PublicDefines.h"
#import "OpenCVUtility.h"

@interface VideoCreateViewController ()

@end

@implementation VideoCreateViewController

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
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 60);
    [self.view addSubview:scrollView];
    
    CGFloat offsetY = 20;
    UIButton *btnTestInit = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTestInit.frame = CGRectMake(30, offsetY, SCREEN_WIDTH - 60, 30);
    [btnTestInit setTitle:@"创建视频" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(onClickCreateVideo:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btnTestInit];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"用OpenCV创建视频"];
    [self createRightButton];
    [self createViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createVideo {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Megamind" ofType:@"mp4"];
    VideoCapture inputVideo(path.UTF8String);
    
    if (!inputVideo.isOpened()) {
        NSLog(@"-------open megamind.avi failure");
        return;
    }
    
    int ext = static_cast<int>(inputVideo.get(CV_CAP_PROP_FOURCC));
    cv::Size s = cv::Size((int)inputVideo.get(CV_CAP_PROP_FRAME_WIDTH),
                          (int)inputVideo.get(CV_CAP_PROP_FRAME_HEIGHT));
//    char EXT[] = {static_cast<char>(ext & 0xff), static_cast<char>((ext & 0xff00) >> 8), static_cast<char>((ext & 0xff0000) >> 16), static_cast<char>((ext & 0xff000000) >> 24), 0};
    NSRange range = [path rangeOfString:@".mp4"];
    NSString *newPath = [NSString stringWithFormat:@"%@_new.mp4", [path substringToIndex:range.location]];
    VideoWriter outputVideo;
    outputVideo.open(newPath.UTF8String, ext, inputVideo.get(CV_CAP_PROP_FPS), s, true);
    
    if (!outputVideo.isOpened()) {
        NSLog(@"-------create new megamind.avi failure");
        return;
    }
    
    int channel = 2;
    Mat src, res;
    cv::vector<cv::Mat> sp1;
    
    while (true) {
        inputVideo >> src;
        if (src.empty())
            break;
        
        split(src, sp1);
        for (int i = 0; i < 3; i++) {
            if (i != channel)
                sp1[i] = Mat ::zeros(s.width, s.height, sp1[0].type());
            merge(sp1, res);
            
            outputVideo << res;
        }
    }
    
    NSLog(@"-------finished write video");
    
    NSString *message = [NSString stringWithFormat:@"%@ has create", newPath];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)onClickCreateVideo:(id)sender {
//    [self createVideo];
    NSString *message = [NSString stringWithFormat:@"本demo请看代码，此代码只供参考，opencv目前只支持avi视频格式，最大文件不超过2G。\n[opencv对于视频的支持很小]"];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)onClickStudy {
    [super onClickStudy];
    
    WebViewController *controller = [[WebViewController alloc] init];
    controller.titleString = @"用OpenCV创建视频";
    controller.urlString = @"http://www.opencv.org.cn/opencvdoc/2.3.2/html/doc/tutorials/highgui/video-write/video-write.html#videowritehighgui";
    [self.navigationController pushViewController:controller animated:YES];
}

@end
