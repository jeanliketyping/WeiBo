//
//  WeiboCell.m
//  WeiBo
//
//  Created by mac on 15/10/12.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "WeiboCell.h"
#import "UIImageView+WebCache.h"
#import "WeiboModel.h"
#import "WeiboViewLayoutFrame.h"

@implementation WeiboCell

- (void)awakeFromNib {
    // Initialization code
    [self _createSubView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)_createSubView{
    _weiboView = [[WeiboView alloc] init];
    [self.contentView addSubview:_weiboView];
    
}

-(void)setLayout:(WeiboViewLayoutFrame *)layout{
    if (_layout != layout) {
        _layout = layout;
        _weiboView.layout = _layout;
        _layout.isDetail = NO;
        [self setNeedsLayout];
    }
    
}


-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    WeiboModel *_model = _layout.model;
    
    
    //01 头像
    NSString *urlStr = _model.userModel.profile_image_url;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:urlStr]];
    
    //02 用户昵称
    _nickNameLabel.text = _model.userModel.screen_name;
    
    //03 评论数、转发数
    _commentLabel.text = [NSString stringWithFormat:@"评论:%@",_model.commentsCount];
    _repostLabel.text = [NSString stringWithFormat:@"转发:%@",_model.repostsCount];
    
    //04 来源
    _sourceLabel.text = [NSString stringWithFormat:@"来源:%@",_model.source];
    
    //06 对weiboView 进行布局 显示
    _weiboView.frame = _layout.frame;


}


@end
