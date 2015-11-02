//
//  WeiboViewLayoutFrame.h
//  WeiBo
//
//  Created by mac on 15/10/12.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboModel.h"

@interface WeiboViewLayoutFrame : NSObject

@property (nonatomic,assign) CGRect textFrame;//微博文字
@property (nonatomic,assign) CGRect srTextFrame;//转发源微博文字
@property (nonatomic,assign) CGRect bgImageFrame;//微博文字
@property (nonatomic,assign) CGRect imgFrame;//微博文字

@property (nonatomic,assign) CGRect frame;//整个weiboView的frame


@property (nonatomic,strong) WeiboModel *model;//微博的model


@property (nonatomic,assign) BOOL isDetail;//是否是详情页面布局

@end
