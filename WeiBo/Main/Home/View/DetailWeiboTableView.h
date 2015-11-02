//
//  DetailWeiboTableView.h
//  WeiBo
//
//  Created by mac on 15/10/16.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboModel.h"
#import "WeiboView.h"
#import "UserView.h"

@interface DetailWeiboTableView : UITableView<UITableViewDataSource,UITableViewDelegate>

{
    //用户视图
    UserView *_userView;
    //微博视图
    WeiboView *_weiboView;
    
    //头视图
    UIView *_theTableHeaderView;
}

@property (nonatomic,strong) WeiboModel *model;
@property (nonatomic,strong) NSMutableArray *commentData;
@property(nonatomic,strong)NSDictionary *commentDic;

@end
