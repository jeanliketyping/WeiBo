//
//  WeiboView.m
//  WeiBo
//
//  Created by mac on 15/10/12.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "WeiboView.h"
#import "UIImageView+WebCache.h"

@implementation WeiboView

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self _createSubView];
    }
    return self;
}

- (instancetype)init{
    
    self=  [super init];
    if (self) {
        [self _createSubView];
    }
    return self;
}


- (void)_createSubView{
    
    _textLabel = [[WXLabel alloc] init];
    _sourceLabel = [[WXLabel alloc] init];
    _imgView = [[ZoomImageView alloc] init];
    _bgImageView = [[ThemeImageView alloc] init];
    _bgImageView.leftCap = 30;
    _bgImageView.topCap = 20;
    
    _textLabel.wxLabelDelegate = self;
    _sourceLabel.wxLabelDelegate = self;
    
    [self addSubview:_bgImageView];
    [self addSubview:_textLabel];
    [self addSubview:_sourceLabel];
    [self addSubview:_imgView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChange) name:kThemeNameDidChangeNotification object:nil];
    
}


- (void)setLayout:(WeiboViewLayoutFrame *)layout{
    
    if (_layout != layout) {
        _layout = layout;
        
        [self setNeedsLayout];
    }
}


-(void)layoutSubviews{
    [super layoutSubviews];
    
    _textLabel.font =   [UIFont systemFontOfSize: FontSize_Weibo(_layout.isDetail)] ;
    _sourceLabel.font =  [UIFont systemFontOfSize: FontSize_ReWeibo(_layout.isDetail)] ;
    
    
    WeiboModel *model = _layout.model;
    
    //微博文字
    _textLabel.frame = _layout.textFrame;
    _textLabel.text = model.text;
    _textLabel.font = [UIFont systemFontOfSize:15];
    _textLabel.linespace = 5;
    
    if (model.reWeiboModel != nil) {//有转发
        
        _bgImageView.hidden = NO;
        _sourceLabel.hidden = NO;
        //被转发的微博
        _sourceLabel.frame = _layout.srTextFrame;
        _sourceLabel.text = model.reWeiboModel.text;
        _sourceLabel.font = [UIFont systemFontOfSize:14];
        _sourceLabel.linespace = 5;
        
        //背景图片
        _bgImageView.frame = _layout.bgImageFrame;
        _bgImageView.imageName = @"timeline_rt_border_9.png";
        
        //图片
        NSString *imageStr = model.reWeiboModel.thumbnailImage;
        if (imageStr == nil) {
            _imgView.hidden = YES;
        }else{
            _imgView.bigImageURLStr = model.reWeiboModel.originalImage;
            _imgView.hidden = NO;
            _imgView.frame = _layout.imgFrame;
            [_imgView sd_setImageWithURL:[NSURL URLWithString:imageStr]];
            
        }
        
        
    }else {//没转发
        
        _bgImageView.hidden = YES;
        _sourceLabel.hidden = YES;
        
        //图片
        NSString *imageStr = model.originalImage;
        if (imageStr == nil) {
            _imgView.hidden = YES;
        }else{
            _imgView.bigImageURLStr = model.originalImage;
            _imgView.hidden = NO;
            _imgView.frame = _layout.imgFrame;
            [_imgView sd_setImageWithURL:[NSURL URLWithString:imageStr]];
            
        }
        
    }
    
    if (_imgView.hidden == NO) {
        NSString *extension;
        
        _imgView.gifImageView.frame = CGRectMake(_imgView.width - 24, _imgView.height - 24, 24, 24);
        //url后缀，查看是否为gif
        if (model.reWeiboModel != nil) {
            
            extension = [model.reWeiboModel.thumbnailImage pathExtension];
        }else{
            extension = [model.thumbnailImage pathExtension];
        }
        
        if ([extension isEqualToString:@"gif"]) {
            _imgView.gifImageView.hidden = NO;
            _imgView.isGif = YES;
        }else{
            _imgView.gifImageView.hidden = YES;
            _imgView.isGif = NO;
        }
    }
    
    

}




#pragma mark - WXLabelDelegate

- (NSString *)contentsOfRegexStringWithWXLabel:(WXLabel *)wxLabel
{
    //需要添加链接字符串的正则表达式：@用户、http://、#话题#
    NSString *regex1 = @"@\\w+";
    NSString *regex2 = @"http(s)?://([A-Za-z0-9._-]+(/)?)*";
    NSString *regex3 = @"#\\w+#";
    NSString *regex = [NSString stringWithFormat:@"(%@)|(%@)|(%@)",regex1,regex2,regex3];
    return regex;
}

//设置当前链接文本的颜色
- (UIColor *)linkColorWithWXLabel:(WXLabel *)wxLabel{
    
    return [[ThemeManager shareInstance] getColor:@"Link_color"];
}
//设置当前文本手指经过的颜色
- (UIColor *)passColorWithWXLabel:(WXLabel *)wxLabel{
    
    return [UIColor grayColor];
}


- (void)toucheBenginWXLabel:(WXLabel *)wxLabel withContext:(NSString *)context{
    
    NSLog(@"点击");
}

- (void)themeDidChange{
    
    _textLabel.textColor = [[ThemeManager shareInstance] getColor:@"Timeline_Content_color"];
    _sourceLabel.textColor = [[ThemeManager shareInstance] getColor:@"Timeline_Content_color"];
    
}


@end
