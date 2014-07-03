/*!
 @header PublicDefines.h
 @abstract PublicDefines data base class
 @author xiulian.yin
 @version 1.0
 */

#import <Foundation/Foundation.h>

//系统版本判断
#define SYSTEM_VERSION_GREATER_THAN(V)  [[[UIDevice currentDevice] systemVersion]floatValue]>V
#define IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f)
//设备判断
#define IPHONE5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136),[[UIScreen mainScreen] currentMode].size) : NO)

//颜色值处理
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define COLOR(R, G, B) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.0]

//最近登录账号
#define LoginAccount @"latestLoginAccount"
#define LatestLoginAccount [[NSUserDefaults standardUserDefaults]objectForKey:LoginAccount]

//是否是第一次启动
#define FirstLaunched @"firstLaunched"
#define IsFirstLaunch [[NSUserDefaults standardUserDefaults] objectForKey:FirstLaunched]==nil?YES:NO
#define SetFirstLaunch [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:FirstLaunched]

// 是否为模拟器版(0:编译为模拟器版本;1:编译为真机版本)
#define HANDSET_VERSION 1

// 是否为本地版本(1:无网络，本地假数据版本; 0:有网络，真实网络数据版本)
#define LOCAL_VERSION 1

// 屏幕高度
#define SCREEN_HEIGHT           [[UIScreen mainScreen] bounds].size.height
// 屏幕宽度
#define SCREEN_WIDTH            [[UIScreen mainScreen] bounds].size.width
// 状态栏高度
#define STATUS_HEIGHT           20
// 导航栏高度
#define NAVIGATIONBAR_HEIGHT    44

// 正文normal下颜色
#define TEXT_NORMAL_COLOR       0x485e73
// 正文不可用情况下颜色
#define TEXT_DISABLE_COLOR      0x999999
// 红色文字颜色
#define TEXT_RED_COLOR          0xcf4659
