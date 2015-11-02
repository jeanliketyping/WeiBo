//
//  UserView.m
//  WeiBo
//
//  Created by mac on 15/10/17.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "UserView.h"
#import "UIImageView+WebCache.h"

@implementation UserView

- (void)setModel:(WeiboModel *)model{
    
    if (_model != model) {
        _model = model;
        [self setNeedsLayout];
    }
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    
    //用户头像
    NSString *imgURL = self.model.userModel.avatar_large;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:imgURL]];
    _iconImageView.frame = CGRectMake(15 , 15, 65, 65);
    
    //昵称
    _nickNameLabel.text = self.model.userModel.screen_name;
    

    //来源
    _sourceLabel.text = self.model.source;

}

@end
