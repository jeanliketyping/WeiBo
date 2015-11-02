//
//  UserView.h
//  WeiBo
//
//  Created by mac on 15/10/17.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboModel.h"

@interface UserView : UIView
@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;

@property (strong, nonatomic) IBOutlet UILabel *nickNameLabel;

@property (strong, nonatomic) IBOutlet UILabel *sourceLabel;

@property (nonatomic,strong) WeiboModel *model;

@end
