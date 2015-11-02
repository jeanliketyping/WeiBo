//
//  ThemeLabel.m
//  WeiBo
//
//  Created by mac on 15/10/10.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "ThemeLabel.h"
#import "ThemeManager.h"

@implementation ThemeLabel

-(void)dealloc
{
    //移除观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self _loadColor];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChange:) name:kThemeNameDidChangeNotification object:nil];
    }
    return self;
}

-(void)awakeFromNib{
    [self _loadColor];
}

- (void)setColorName:(NSString *)colorName
{
    if (![_colorName isEqualToString:colorName]) {
        _colorName = colorName;
        [self _loadColor];
    }
}


- (void)themeDidChange:(NSNotification *)notification{
    [self _loadColor];
}


- (void)_loadColor{
    ThemeManager *manager = [ThemeManager shareInstance];
    UIColor *color = [manager getColor:self.colorName];
    self.textColor = color;
}





@end
