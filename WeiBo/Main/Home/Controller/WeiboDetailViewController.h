//
//  WeiboDetailViewController.h
//  WeiBo
//
//  Created by mac on 15/10/16.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "BaseViewController.h"
#import "WeiboModel.h"
#import "SinaWeibo.h"

@interface WeiboDetailViewController : BaseViewController<SinaWeiboRequestDelegate> 

//评论的微博Model
@property (nonatomic,strong)WeiboModel *model;
//评论列表数据
@property(nonatomic,strong)NSMutableArray *data;

@end
