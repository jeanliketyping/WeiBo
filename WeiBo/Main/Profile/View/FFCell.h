//
//  FFCell.h
//  WeiBo
//
//  Created by mac on 15/10/21.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeManager.h"

@interface FFCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;

@property (strong, nonatomic) IBOutlet UILabel *nickNameLabel;

@property (strong, nonatomic) IBOutlet UILabel *followerCountLabel;

@end
