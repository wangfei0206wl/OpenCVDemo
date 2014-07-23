//
//  ImageProViewController.m
//  OpenCVDemo
//
//  Created by wangfei on 14-7-3.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import "ImageProViewController.h"
#import "PublicDefines.h"
#import "ImgBlurViewController.h"
#import "ErosionViewController.h"
#import "MorphoViewController.h"
#import "PyramidViewController.h"
#import "ThresholdViewController.h"
#import "Filter2DViewController.h"
#import "CopyBorderViewController.h"
#import "SobelViewController.h"
#import "LaplacianViewController.h"
#import "CannyViewController.h"
#import "HoughLinesViewController.h"
#import "HoughCirclesViewController.h"
#import "RemapViewController.h"
#import "WarpAffineViewController.h"
#import "EqualizeHistViewController.h"
#import "CalcHistViewController.h"
#import "CompareHistViewController.h"
#import "BackProjectViewController.h"
#import "MatchTempViewController.h"

@interface ImageProViewController () {
    NSArray *_arrMenus;
}

@end

@implementation ImageProViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)initDatas {
    _arrMenus = [NSArray arrayWithObjects:@"图像平滑处理", @"腐蚀与膨胀", @"更多形态学变换", @"图像金字塔", @"基本的阈值操作", @"实现自己的线性滤波器", @"给图像添加边界", @"Sobel导数", @"Laplace算子", @"Canny边缘检测", @"霍夫线变换", @"霍夫圆变换", @"Remapping重映射", @"仿射变换", @"直方图均值化", @"直方图计算", @"直方图对比", @"反向投影", @"模板匹配", @"在图像中寻找轮廓", @"计算物体的凸包", @"创建包围轮廓的矩形和圆形边界框", @"为轮廓创建可倾斜的边界框和椭圆", @"轮廓矩", @"多边形测试", nil];
}

- (void)createViews {
    CGFloat height = [[UIScreen mainScreen] bounds].size.height - 64;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, IOS7?64:44, SCREEN_WIDTH, height) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = (id)self;
    tableView.dataSource = (id)self;
    
    [self.view addSubview:tableView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"imgproc模块"];
    [self initDatas];
    [self createViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch(indexPath.row) {
        case 0:
        {
            ImgBlurViewController *controller = [[ImgBlurViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 1:
        {
            ErosionViewController *controller = [[ErosionViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 2:
        {
            MorphoViewController *controller = [[MorphoViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 3:
        {
            PyramidViewController *controller = [[PyramidViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
             break;
        case 4:
        {
            ThresholdViewController *controller = [[ThresholdViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 5:
        {
            Filter2DViewController *controller = [[Filter2DViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 6:
        {
            CopyBorderViewController *controller = [[CopyBorderViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 7:
        {
            SobelViewController *controller = [[SobelViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 8:
        {
            LaplacianViewController *controller = [[LaplacianViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 9:
        {
            CannyViewController *controller = [[CannyViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 10:
        {
            HoughLinesViewController *controller = [[HoughLinesViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 11:
        {
            HoughCirclesViewController *controller = [[HoughCirclesViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 12:
        {
            RemapViewController *controller = [[RemapViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 13:
        {
            WarpAffineViewController *controller = [[WarpAffineViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 14:
        {
            EqualizeHistViewController *controller = [[EqualizeHistViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 15:
        {
            CalcHistViewController *controller = [[CalcHistViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 16:
        {
            CompareHistViewController *controller = [[CompareHistViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 17:
        {
            BackProjectViewController *controller = [[BackProjectViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 18:
        {
            MatchTempViewController *controller = [[MatchTempViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        default:
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
    return [_arrMenus count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"MenuCell";
    NSString *item = [_arrMenus objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = item;
    
    return cell;
}
@end
