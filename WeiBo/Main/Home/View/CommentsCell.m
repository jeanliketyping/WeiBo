//
//  CommentsCell.m
//  WeiBo
//
//  Created by mac on 15/10/16.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "CommentsCell.h"
#import "UIImageView+WebCache.h"
#import "ThemeManager.h"

@implementation CommentsCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (void)setCommentModel:(CommentModel *)commentModel{
    
    if (_commentModel != commentModel) {
        _commentModel = commentModel;
        
        _commentLabel = [[WXLabel alloc] initWithFrame:CGRectZero];
        _commentLabel.font = [UIFont systemFontOfSize:14.0f];
        _commentLabel.linespace = 5;
        _commentLabel.wxLabelDelegate = self;
        [self.contentView addSubview:_commentLabel];
        
        self.backgroundColor = [UIColor clearColor];
        [self setNeedsLayout];
    }
}


-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    
    
    //1 头像
    NSString *urlStr = _commentModel.userModel.profile_image_url;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:urlStr]];
    
    //02 用户昵称
    _nickNameLabel.text = _commentModel.userModel.screen_name;
    
    //03 评论
    CGFloat height = [WXLabel getTextHeight:14.0f
                                      width:240
                                       text:_commentModel.text
                                  linespace:5];
    
    _commentLabel.frame = CGRectMake(_iconImageView.right + 20, _nickNameLabel.bottom + 5, kScreenWidth - 70, height);
    
    _commentLabel.text = _commentModel.text;

}


//返回一个正则表达式，通过此正则表达式查找出需要添加超链接的文本
- (NSString *)contentsOfRegexStringWithWXLabel:(WXLabel *)wxLabel {
    //需要添加连接的字符串的正则表达式：@用户、http://... 、 #话题#
    NSString *regex1 = @"@\\w+"; //@"@[_$]";
    NSString *regex2 = @"http(s)?://([A-Za-z0-9._-]+(/)?)*";
    NSString *regex3 = @"#^#+#";  //\w 匹配字母或数字或下划线或汉字
    
    NSString *regex = [NSString stringWithFormat:@"(%@)|(%@)|(%@)",regex1,regex2,regex3];
    
    return regex;
}

//设置当前链接文本的颜色
- (UIColor *)linkColorWithWXLabel:(WXLabel *)wxLabel {
    
    UIColor *linkColor = [[ThemeManager shareInstance] getColor:@"Link_color"];
    return linkColor;
}

//设置当前文本手指经过的颜色
- (UIColor *)passColorWithWXLabel:(WXLabel *)wxLabel {
    return [UIColor darkGrayColor];
}


//计算评论单元格的高度
+ (float)getCommentHeight:(CommentModel *)commentModel {
    CGFloat height = [WXLabel getTextHeight:14.0f
                                      width:kScreenWidth-70
                                       text:commentModel.text
                                  linespace:5];
    
    
    
    return height+40;
}


@end
