//
//  ThemeManager.h
//  WeiBo
//
//  Created by mac on 15/10/9.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kThemeNameDidChangeNotification @"kThemeNameDidChangeNotification"
#define kThemeName @"kThemeName"

@interface ThemeManager : NSObject

@property (nonatomic,copy)NSString *themeName;//主题名字

+ (ThemeManager *)shareInstance;//单例方法

- (UIImage *)getThemeImage:(NSString *)imageName;
- (UIColor *)getColor:(NSString *)colorName;

@end
