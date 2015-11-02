//
//  ThemeImageView.m
//  WeiBo
//
//  Created by mac on 15/10/9.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "ThemeImageView.h"
#import "ThemeManager.h"

@implementation ThemeImageView

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

- (void)setImageName:(NSString *)imageName
{
    if (![_imageName isEqualToString:imageName]) {
        _imageName = imageName;
        [self _loadImage];
    }
}

-(void)themeDidChange:(NSNotification *)notification
{
    [self _loadImage];
}

- (void)_loadImage{
    
    ThemeManager *manager = [ThemeManager shareInstance];
    
    UIImage *image = [manager getThemeImage:self.imageName];
    
    image = [image stretchableImageWithLeftCapWidth:_leftCap topCapHeight:_topCap];
    
    self.image = image;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
