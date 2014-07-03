//
//  WebViewController.m
//  OpenCVDemo
//
//  Created by wangfei on 14-7-3.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import "WebViewController.h"
#import "PublicDefines.h"

@interface WebViewController () {
    UIWebView *_webView;
}

@end

@implementation WebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)creatWebView {
    CGRect frame = IOS7?[[UIScreen mainScreen] bounds]:[[UIScreen mainScreen] applicationFrame];
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, IOS7?64:44, 320, frame.size.height - (IOS7?64:44))];
    _webView.delegate = (id)self;
    _webView.scalesPageToFit = YES;
    [self.view addSubview:_webView];
}

- (void)loadWeb:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [_webView loadRequest:request];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:_titleString];
    [self creatWebView];
    [self loadWeb:_urlString];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
