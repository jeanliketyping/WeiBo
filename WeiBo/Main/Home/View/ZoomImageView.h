//
//  ZoomImageView.h
//  WeiBo
//
//  Created by mac on 15/10/17.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@class  ZoomImageView;

@protocol ZoomImageViewDelegate <NSObject>

//图片将要放大
- (void)imageWillZoomIn:(ZoomImageView *)imageView;

- (void)imageWillZoomOut:(ZoomImageView *)imageView;

@end

@interface ZoomImageView : UIImageView<NSURLConnectionDataDelegate,UIActionSheetDelegate>

{
    UIScrollView *_scrollView;
    UIImageView *_fullImageView;
    
    NSMutableData *_data;
    double _length;

    MBProgressHUD *_hud;
    NSURLConnection *_connection;

}
@property (nonatomic,weak)id<ZoomImageViewDelegate> delegate;

@property (nonatomic, strong)NSString *bigImageURLStr;

@property (nonatomic,assign)BOOL isGif;
@property (nonatomic,strong)UIImageView *gifImageView;

@end
