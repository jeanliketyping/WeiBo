//
//  CommentModel.m
//  WeiBo
//
//  Created by mac on 15/10/16.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "CommentModel.h"
#import "Utils.h"
@implementation CommentModel

- (void)setAttributes:(NSDictionary *)dataDic {
    [super setAttributes:dataDic];
    
    NSDictionary *userDic = [dataDic objectForKey:@"user"];
    UserModel *userModel = [[UserModel alloc] initWithDataDic:userDic];
    self.userModel = userModel;
    
    NSDictionary *status = [dataDic objectForKey:@"status"];
    WeiboModel *weiboModel = [[WeiboModel alloc] initWithDataDic:status];
    self.weiboModel = weiboModel;
    
    NSDictionary *commentDic = [dataDic objectForKey:@"reply_comment"];
    if (commentDic != nil) {
        CommentModel *commentModel = [[CommentModel alloc] initWithDataDic:commentDic];
        self.commentModel = commentModel;
    }
    
    //处理评论中的表情
    self.text = [Utils parseTextImage:_text];
    
}

@end
