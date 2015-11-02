//
//  WeiboCell.h
//  WeiBo
//
//  Created by mac on 15/10/12.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboModel.h"
#import "WeiboView.h"
#import "WeiboViewLayoutFrame.h"


@interface WeiboCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
@property (strong, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *commentLabel;
@property (strong, nonatomic) IBOutlet UILabel *repostLabel;
@property (strong, nonatomic) IBOutlet UILabel *sourceLabel;

@property (nonatomic,strong)WeiboView *weiboView;

@property (nonatomic,strong)WeiboViewLayoutFrame *layout;

@end
