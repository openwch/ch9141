//
//  constant.h
//
//  Created by wangchunlei on 15-1-12.
//  Copyright (c) 2015年 wangchunlei. All rights reserved.
//

#ifndef _____constant_h

#define _____constant_h

//请求出错提示消息
#define RetryLoading @"重新加载"
#define RequestError @"请求失败，请检查网络连接"
#define RequestNoData @"暂无数据!"
#define LoadDataAllComplete @"数据全部加载完成"
#define LoadDataing @"努力加载中"
#define UpdateDataing @"正在更新数据"
#define ServerError @"服务器处理出错!"
#define DataError @"数据处理出错!"
#define ReloadDataTitle @"重新加载"
#define NoDataTitle @"随便逛逛吧!"
#define AppID @"1029758086"
#define OperationSuccess @"操作成功"
#define RemoteHostName  @"www.apple.com"
#define NoneNetworkIcon @"none_network"
#define ServerErrorIcon @"none_network"
#define NoDataIcon @"none_network"
#define LoadDateCount 10

#define SERVICE_UUID @"FFF0"
#define READ_CHARACTER_UUID @"FFF1"
#define WRITE_CHARACTER_UUID @"FFF2"
#define CONFIG_CHARACTER_UUID @"FFF3"
#define MAX_SEND_TIME 8
#define MAX_WAIT_TIME 10

//系统版本
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define CurrentSystemVersion [[UIDevice currentDevice] systemVersion]

//当前语言
#define CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

//系统版本
#define IOS8 ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0)
#define IOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)

//判断当前设备是不是iphone5
#define kScreenIphone5    (([[UIScreen mainScreen] bounds].size.height)>=568)

#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)

#define HomeTitleBottomLine RGB(144,229,247)

#define TableBordColor RGB(210,210,210)
#define TableBordColor1 RGB(240,240,240)

#define DarkGreyColor2 RGB(50,50,50)
#define DarkGreyColor RGB(82,82,83)
#define LightGreyColor RGB(134,134,134)
#define LightGreyColor2 RGB(188,188,188)
#define LightGreyColor3 RGB(200,200,200)
#define LightGreyColor4 RGB(225,225,225)
#define LightGreyColor5 RGB(237,237,237)
#define BottomToolBjColor RGB(20,151,242)
#define DarkRedColor RGB(231,95,73)
#define DarkBlueColor RGB(24,144,255)

#define LightGreenColor RGB(165, 228, 190)
#define DarkGreenColor RGB(50,205,50)
#define LightRedColor RGB(243, 187, 197)
#define LightBlueColor RGB(1, 173, 248)
#define LightBlueColor2 RGB(163, 206, 237)
#define LightYellowColor2 RGB(255, 190,38)
#define LightYellowColor RGB(251, 204, 178)
#define LightIndigoColor RGB(19, 216, 232)

#define HUDColor RGBA(0, 0, 0,0.5)
#define AppMainColor RGB(1, 155, 246)
#define CellWhiteBjColor RGBA(255, 255, 255, 0.1)
#define ClazzStateColor RGB(113, 202, 8)
#define StateOrgranColor RGB(245, 163, 6)
#define StateRedColor RGB(227, 5, 5)

//navibar 配置
#define StateViewHeight 20.0f
#define NavigationBarHeight 44.0f
#define NavigationTopHeight 64.0f
#define NavigationBottomHeight 44.0f
#define SwitchTitleHeight 44.0f

#define ScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define ScreenHeight ([UIScreen mainScreen].bounds.size.height)

#define BigFont7 [UIFont systemFontOfSize:30]
#define BigFont6 [UIFont systemFontOfSize:28]
#define BigFont5 [UIFont systemFontOfSize:26]
#define BigFont4 [UIFont systemFontOfSize:24]
#define BigFont3 [UIFont systemFontOfSize:22]
#define BigFont2 [UIFont systemFontOfSize:20]
#define BigFont1 [UIFont systemFontOfSize:18]
#define BigFont [UIFont systemFontOfSize:16]
#define StandFont [UIFont systemFontOfSize:14]
#define MiddleFont [UIFont systemFontOfSize:12]
#define SmallFont [UIFont systemFontOfSize:10]

//等比算高
#define RatioHeight(height) floor(ScreenWidth*height/320)
#define BlodBigFont3 [UIFont fontWithName:@"Helvetica-Bold" size:26]
#define BlodBigFont2 [UIFont fontWithName:@"Helvetica-Bold" size:24]
#define BlodBigFont1 [UIFont fontWithName:@"Helvetica-Bold" size:22]
#define BlodBigFont [UIFont fontWithName:@"Helvetica-Bold" size:18]
#define BlodStandFont [UIFont fontWithName:@"Helvetica-Bold" size:16]
#define BlodMiddleFont [UIFont fontWithName:@"Helvetica-Bold" size:14]

//other
#define InputFieldBorderColor LightGreyColor4.CGColor
#define DefaultLocationCity @"南京"
#define DefaultSearchRange 6000
#define BlankViewHeight 10

//输入提醒
#define  NaviFontSize [UIFont systemFontOfSize:14]
#define InputFieldLeftSpace 16.0f
#define InputFieldHeight 46.0f
#define CommentStarsNum 5
#define ListPageShowNum 2

//CalendarDemo
#define APP_NAME  @"CalendarDemo"

#define IS_IPHONE_4S        [[UIScreen mainScreen] bounds].size.height == 480
#define IS_IPHONE_5         [[UIScreen mainScreen] bounds].size.height == 568
#define IS_IPHONE_6         [[UIScreen mainScreen] bounds].size.height == 667
#define IS_IPHONE_6_PLUS    [[UIScreen mainScreen] bounds].size.height == 736

#define DeviceHeight   [UIScreen mainScreen].bounds.size.height
#define DeviceWidth    [UIScreen mainScreen].bounds.size.width
#define IOS7VERSION ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0?YES:NO)


#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define RGBCOLOR(r, g, b)       [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:(float)r / 255.0f green:(float)g / 255.0f blue:(float)b / 255.0f alpha:a]
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//16进制字符串
#define  HexString @"0123456789abcedfABCDEF"

//define font
#define font10 [UIFont systemFontOfSize:10.0]
#define font12 [UIFont systemFontOfSize:12.0]
#define font13 [UIFont systemFontOfSize:13.0]
#define font14 [UIFont systemFontOfSize:14.0]
#define font15 [UIFont systemFontOfSize:15.0]
#define font16 [UIFont systemFontOfSize:16.0]
#define font17 [UIFont systemFontOfSize:17.0]
#define font18 [UIFont systemFontOfSize:18.0]
#define font24 [UIFont systemFontOfSize:24.0]
#define font12Bold [UIFont fontWithName:@"Helvetica-Bold" size:12.0]
#define font13Bold [UIFont fontWithName:@"Helvetica-Bold" size:13.0]
#define font14Bold [UIFont fontWithName:@"Helvetica-Bold" size:14.0]
#define font15Bold [UIFont fontWithName:@"Helvetica-Bold" size:15.0]
#define font16Bold [UIFont fontWithName:@"Helvetica-Bold" size:16.0]
#define font18Bold [UIFont fontWithName:@"Helvetica-Bold" size:18.0]
#define APPEngine  [IMEngine shareEngine]


#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad


#define isiPad (IDIOM == IPAD ? YES:NO)

#define kHeaderHeight 100
#define PackgeSize 1024


#define DefaultSaveFile @"savef.txt"
#define History_Connect_Key @"HistoryConnect"

#define Save_File_Name @"savefile.log"
#define BTitle_Show @"实时显示、不会自动清空内容"
#define BTitle_Save_File @"保存到文件"
#define BTitle_Show_Clear @"实时显示、内容超1500字符自动清空"
#define BTitle_Show_Stop @"实时显示、内容超1500字符自动停止"

#define BTitle_Send_Once @"单次发送"
#define BTitle_Send_Repeat @"连续发送"
#define BTitle_Send_Time @"定时发送"
#define BTitle_Send_File @"发送文件"
#define COM_UNSYN @"未同步串口参数"
#define  Aboutus_URL @"http://www.wch.cn/products/category/63.html"

#endif


