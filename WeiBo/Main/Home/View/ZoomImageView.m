//
//  ZoomImageView.m
//  WeiBo
//
//  Created by mac on 15/10/17.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "ZoomImageView.h"
#import "UIImage+GIF.h"
#import <ImageIO/ImageIO.h>

@implementation ZoomImageView

- (instancetype)init{
    
    self = [super init];
    if (self) {
        //添加手势
        [self initTap];
        [self createGifView];
    }
    return  self;
}

- (void)initTap{
    self.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomIn)];
    [self addGestureRecognizer:tap];
    
}

- (void)zoomIn{
    if ([self.delegate respondsToSelector:@selector(imageWillZoomIn:)]) {
        [self.delegate imageWillZoomIn:self];
    }
    
    
    //创建缩放视图
    [self createViews];
    
    //把相对于cell 的frame转换成相对于window的frame
    CGRect frame = [self convertRect:self.bounds toView:self.window];
    _fullImageView.frame = frame;
    
    //动画
    self.hidden = YES;

    [UIView animateWithDuration:0.35 animations:^{
        _fullImageView.frame = _scrollView.frame;
    } completion:^(BOOL finished) {
        _scrollView.backgroundColor = [UIColor blackColor];
        [self downloadImage];
    }];
}

//创建gif小图标
- (void)createGifView{
    
    _gifImageView = [[UIImageView alloc] init];
    _gifImageView.image = [UIImage imageNamed:@"timeline_gif.png"];
    [self addSubview:_gifImageView];
    _gifImageView.hidden = YES;
    
}

- (void)createViews{
    
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [self.window addSubview:_scrollView];
        
        _fullImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _fullImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        _fullImageView.image = self.image;
        [_scrollView addSubview:_fullImageView];
        
        UITapGestureRecognizer *zoomOutTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomOut)];
        [_scrollView addGestureRecognizer:zoomOutTap];
        
        //添加长按手势
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(saveToAlbum:)];
        //长按的最短时间
        longPress.minimumPressDuration = 2;
        //手指移动的最大距离
        longPress.allowableMovement = 10;
        [_scrollView addGestureRecognizer:longPress];
        [longPress requireGestureRecognizerToFail:zoomOutTap];
    }

}




- (void)zoomOut{
    if ([self.delegate respondsToSelector:@selector(imageWillZoomOut:)]) {
        [self.delegate imageWillZoomOut:self];
    }
    
    _scrollView.backgroundColor = [UIColor clearColor];
    [_connection cancel];
    self.hidden = NO;
    
    //动画
    [UIView animateWithDuration:0.35 animations:^{
        CGRect frame = [self convertRect:self.bounds toView:self.window];
        _fullImageView.frame = frame;
        _fullImageView.top += _scrollView.contentOffset.y;
        
    } completion:^(BOOL finished) {
        [_scrollView removeFromSuperview];
        _scrollView = nil;
        _fullImageView = nil;
        _hud = nil;
    }];
}

- (void)downloadImage{
    
    //进度
    _hud = [MBProgressHUD showHUDAddedTo:_scrollView animated:YES];
    _hud.mode = MBProgressHUDModeDeterminate;
    _hud.progress = 0.0;

        
    NSURL *url = [NSURL URLWithString:_bigImageURLStr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
    
    _connection = [NSURLConnection connectionWithRequest:request delegate:self];

}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    //获取响应头
    NSDictionary *headerFields = httpResponse.allHeaderFields;
    //获取下载文件大小
    NSString *lengthStr = [headerFields objectForKey:@"Content-length"];
    
    _length = [lengthStr doubleValue];
    
    _data = [[NSMutableData alloc] init];

}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    [_data appendData:data];
    CGFloat progress = _data.length / _length;
    NSLog(@"进度：%f",progress);
    
    _hud.progress = progress;
    
    
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    [_hud hide:YES];
    NSLog(@"下载完成");
    UIImage *image = [UIImage imageWithData:_data];
    _fullImageView.image= image;
    
    //尺寸处理
    CGFloat length = image.size.height / image.size.width * kScreenWidth;
    if (length > kScreenHeight) {
        [UIView animateWithDuration:0.3 animations:^{
            _fullImageView.height = length;
            _scrollView.contentSize = CGSizeMake(kScreenWidth, length);
        }];
    }
    
    if (_isGif) {
        [self showGif];
    }

}

- (void)showGif{
    
    //01  WebView播放(回不去)
//    UIWebView *webView = [[UIWebView alloc] initWithFrame:_scrollView.bounds];
//    webView.userInteractionEnabled = NO;
//    [webView loadData:_data MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
//    [_scrollView addSubview:webView];
    
    //02
    _fullImageView.image = [UIImage sd_animatedGIFWithData:_data];
    
    //03 用ImageIO
    //创建图片源
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)_data, NULL);
    //得到图片个数
    size_t count = CGImageSourceGetCount(source);
    
    NSMutableArray *images = [NSMutableArray array];
    
    NSTimeInterval duration = 0.0f;
    
    for (size_t i = 0; i < count; i ++) {
        //获取每一张图片 放到UIIMage对象里面
        CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
        
        duration += 0.1;
        
        [images addObject:[UIImage imageWithCGImage:image]];
        
        CGImageRelease(image);
    }
    
    //播放1
//    _fullImageView.animationImages = images;
//    _fullImageView.animationDuration = duration;
//    [_fullImageView startAnimating];
    
    //播放2
    UIImage *animatedImage = [UIImage animatedImageWithImages:images duration:duration];
    _fullImageView.image = animatedImage;
    
    
    CFRelease(source);
    
    
    
    
    
}

- (void)saveToAlbum:(UILongPressGestureRecognizer *)longPress{
    
    if (longPress.state == UIGestureRecognizerStateBegan) {
        NSLog(@"长按开始");
        
    }else if (longPress.state == UIGestureRecognizerStateEnded){
        NSLog(@"长按结束,将图片保存到相册");
        
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存图片", nil];
        [sheet showInView:[UIApplication sharedApplication].keyWindow];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog( @"%ld",buttonIndex); //保存图片：0 取消：1
    if (buttonIndex == 0) {
        NSLog(@"保存图片");
        //图片的保存
        /*
        UIImageWriteToSavedPhotosAlbum(<#UIImage *image#>, <#id completionTarget#>, <#SEL completionSelector#>, <#void *contextInfo#>)
         */
        UIImageWriteToSavedPhotosAlbum(_fullImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        
    }else if (buttonIndex == 1){
        NSLog(@"取消");
    }
}

-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    _hud = [MBProgressHUD showHUDAddedTo:_scrollView animated:YES];
    _hud.mode = MBProgressHUDModeCustomView;
    _hud.labelText = @"保存成功";
    [_hud show:YES];
    [_hud hide:YES afterDelay:2];
    NSLog(@"保存成功");
}


@end
