//
//  ThemeManager.m
//  WeiBo
//
//  Created by mac on 15/10/9.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "ThemeManager.h"

@implementation ThemeManager
{
    NSDictionary *_themeConfig;
    NSDictionary *_colorConfig;
}

+ (ThemeManager *)shareInstance
{
    static ThemeManager *instance = nil;
    
    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        //读取本地持久化的主题名字
        _themeName = [[NSUserDefaults standardUserDefaults] objectForKey:kThemeName];

        if (_themeName.length == 0) {
            _themeName = @"Cat";//如果本地没有存储主题名字，则默认用Cat
        }
        
        //读取 主题名－>主题路径 配置文件 放到字典里
        NSString *configPath = [[NSBundle mainBundle] pathForResource:@"theme" ofType:@"plist"];
        _themeConfig = [NSDictionary dictionaryWithContentsOfFile:configPath];
        
        //读取颜色设置
        NSString *themePath = [self themePath];        
        NSString *filePath = [themePath stringByAppendingPathComponent:@"config.plist"];
        _colorConfig = [NSDictionary dictionaryWithContentsOfFile:filePath];

       
    }
    return self;
}

//主题切换 设置主题名字 触发通知
- (void)setThemeName:(NSString *)themeName
{
    if (![_themeName isEqualToString:themeName]) {
        
        _themeName = [themeName copy];
        
        //把主题名字存储到plist中 NSUserDefaults
        [[NSUserDefaults standardUserDefaults] setObject:_themeName forKey:kThemeName];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //重新读取颜色配置文件
        NSString *themePath = [self themePath];
        NSString *filePath = [themePath stringByAppendingPathComponent:@"config.plist"];
        _colorConfig = [NSDictionary dictionaryWithContentsOfFile:filePath];
        
        //当主题名字改变时 发通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kThemeNameDidChangeNotification object:nil];
    }
}

- (UIColor *)getColor:(NSString *)colorName{
    
    if (colorName.length == 0) {
        return nil;
    }
    //获取 配置文件中的rgb值
    NSDictionary *rgbDic = [_colorConfig objectForKey:colorName];
    
    CGFloat r = [rgbDic[@"R"] floatValue];
    CGFloat g = [rgbDic[@"G"] floatValue];
    CGFloat b = [rgbDic[@"B"] floatValue];
    
    CGFloat alpha = 1;
    
    if (rgbDic[@"alpha"] != nil) {
        alpha = [rgbDic[@"alpha"] floatValue];
    }

    //通过rgb值创建UIColor对象
    UIColor *color = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:alpha];
    
    return color;
    
}


- (UIImage *)getThemeImage:(NSString *)imageName{
    //得到图片路径
    
    //获取 主题包路径
    NSString *themePath = [self themePath];
    
    //拼接 主题路径 ＋ imageName
    NSString *filePath = [themePath stringByAppendingPathComponent:imageName];
    
    //得到 UIImage
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    
    return image;
}


//获取 主题包路径
- (NSString *)themePath{
    //boundle资源根路径
    NSString *resPath = [[NSBundle mainBundle] resourcePath];
    
    //当前主题包的路径
    NSString *pathSufix = [_themeConfig objectForKey:self.themeName];//Skins/cat
    
    //完整路径
    NSString *path = [resPath stringByAppendingPathComponent:pathSufix];
    
    return path;
}



@end
