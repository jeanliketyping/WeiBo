//
//  CommentsCell.h
//  WeiBo
//
//  Created by mac on 15/10/16.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"
#import "WXLabel.h"
#import "ThemeImageView.h"
#import "ThemeManager.h"

@interface CommentsCell : UITableViewCell<WXLabelDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
@property (strong, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (nonatomic, strong) WXLabel *commentLabel;


@property (nonatomic,strong)CommentModel *commentModel;

+ (float)getCommentHeight:(CommentModel *)commentModel;

@end
