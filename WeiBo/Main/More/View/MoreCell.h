//
//  MoreCell.h
//  WeiBo
//
//  Created by mac on 15/10/10.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeManager.h"
#import "ThemeImageView.h"
#import "ThemeLabel.h"

@interface MoreCell : UITableViewCell
@property(nonatomic,strong)ThemeImageView *themeimageView;
@property(nonatomic,strong)ThemeLabel *themeTextLabel;
@property(nonatomic,strong)ThemeLabel *themeDetailLabel;
@end
