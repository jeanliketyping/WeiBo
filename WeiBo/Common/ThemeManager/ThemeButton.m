//
//  ThemeButton.m
//  WeiBo
//
//  Created by mac on 15/10/9.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "ThemeButton.h"
#import "ThemeManager.h"

@implementation ThemeButton

-(void)dealloc
{
    //移除观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        //接收通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChange:) name:kThemeNameDidChangeNotification object:nil];
    }
    
    return self;
}


-(void)themeDidChange:(NSNotification *)notification
{
    [self _loadButtonImage];
}

- (void)setNormalButtonImage:(NSString *)normalButtonImage
{
    if (![_normalButtonImage isEqualToString:normalButtonImage]) {
        _normalButtonImage = [normalButtonImage copy];
        [self _loadButtonImage];
    }
}

- (void)setBgNormalButtonImage:(NSString *)bgNormalButtonImage
{
    if (![_bgNormalButtonImage isEqualToString:bgNormalButtonImage]) {
        _bgNormalButtonImage = [bgNormalButtonImage copy];
        [self _loadButtonImage];
    }
}

- (void)_loadButtonImage{
    
    ThemeManager *manager = [ThemeManager shareInstance];
    
    UIImage *normalImage = [manager getThemeImage:self.normalButtonImage];
    UIImage *bgNormalimage = [manager getThemeImage:self.bgNormalButtonImage];
    
    
    if (normalImage != nil) {
        [self setImage:normalImage forState:UIControlStateNormal];
    }
    if (bgNormalimage != nil) {
        [self setBackgroundImage:bgNormalimage forState:UIControlStateNormal];
    }
    
    
}



@end
