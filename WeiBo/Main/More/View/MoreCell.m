//
//  MoreCell.m
//  WeiBo
//
//  Created by mac on 15/10/10.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "MoreCell.h"
#import "ThemeManager.h"
#import "ThemeImageView.h"
#import "ThemeLabel.h"

@implementation MoreCell

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self _createSubView];

        //注册通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChangeAction:) name:kThemeNameDidChangeNotification object:nil];
    }
    return self;
}

- (void)_createSubView{
    
    _themeimageView = [[ThemeImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
    _themeTextLabel = [[ThemeLabel alloc]initWithFrame:CGRectMake(50, 10, kScreenWidth-100, 30)];
    _themeDetailLabel = [[ThemeLabel alloc] initWithFrame:CGRectMake(kScreenWidth-150, 10, 100, 30)];
    
    _themeTextLabel.font = [UIFont boldSystemFontOfSize:15];
    _themeTextLabel.backgroundColor = [UIColor clearColor];
    
    _themeDetailLabel.font = [UIFont boldSystemFontOfSize:15];
    _themeDetailLabel.backgroundColor = [UIColor clearColor];
    _themeDetailLabel.textAlignment = NSTextAlignmentRight;
    
    [self.contentView addSubview:_themeimageView];
    [self.contentView addSubview:_themeTextLabel];
    [self.contentView addSubview:_themeDetailLabel];
    
}





- (void)themeChangeAction:(NSNotification *)notification{
    //接收到通知 改变cell背景颜色
    self.backgroundColor = [[ThemeManager shareInstance] getColor:@"More_Item_color"];
}






- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
