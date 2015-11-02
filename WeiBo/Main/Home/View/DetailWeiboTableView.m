//
//  DetailWeiboTableView.m
//  WeiBo
//
//  Created by mac on 15/10/16.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "DetailWeiboTableView.h"
#import "WeiboModel.h"
#import "CommentsCell.h"
#import "UIImageView+WebCache.h"
#import "WeiboDetailViewController.h"
#import "UIView+UIViewController.h"
#import "CommentModel.h"
#import "WeiboViewLayoutFrame.h"
#import "UserView.h"

@implementation DetailWeiboTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    
    self = [super initWithFrame:frame style:style];
    
    if (self) {
        [self _creatHeaderView];
        self.dataSource = self;
        self.delegate = self;
        
        UINib *nib = [UINib nibWithNibName:@"CommentsCell" bundle:nil];
        [self registerNib:nib forCellReuseIdentifier:@"CommentsCell"];
        
    }
    return self;
}

- (void)_creatHeaderView{
    
    //1.创建父视图
    _theTableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0)];
    _theTableHeaderView.backgroundColor = [UIColor clearColor];
    
    //2.加载xib创建用户视图
    _userView = [[[NSBundle mainBundle] loadNibNamed:@"UserView" owner:self options:nil] lastObject];
    _userView.backgroundColor = [UIColor clearColor];
    _userView.width = kScreenWidth;
    _userView.backgroundColor =  [UIColor colorWithWhite:0.5 alpha:0.1];
    [_theTableHeaderView addSubview:_userView];
    
    
    //3.创建微博视图
    _weiboView = [[WeiboView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    _weiboView.imgView.contentMode = UIViewContentModeScaleAspectFit;
    [_theTableHeaderView addSubview:_weiboView];

}

- (void)setModel:(WeiboModel *)model{
    
    
    if (_model != model) {
        _model = model;
        
        //1.创建微博视图的布局对象
        WeiboViewLayoutFrame *layout = [[WeiboViewLayoutFrame alloc] init];
        //isDetail 需要先赋值
        layout.isDetail = YES;
        layout.model = model;
        
        _weiboView.layout = layout;
        _weiboView.frame = layout.frame;
        _weiboView.top = _userView.bottom + 5;
        
        //2.用户视图
        _userView.model = model;
        
        //3.设置头视图
        _theTableHeaderView.height = _weiboView.bottom;
        
        self.tableHeaderView = _theTableHeaderView;

    }

}

#pragma mark -  TabelView 代理

//获取组的头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    //1.创建组视图
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 40)];
    
    //2.评论Label
    UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
    countLabel.backgroundColor = [UIColor clearColor];
    countLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    countLabel.textColor = [UIColor blackColor];
    
    
    //3.评论数量
    NSNumber *total = [self.commentDic objectForKey:@"total_number"];
    int value = [total intValue];
    countLabel.text = [NSString stringWithFormat:@"评论:%d",value];
    [sectionHeaderView addSubview:countLabel];
    
    sectionHeaderView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.1];
    
    return sectionHeaderView;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _commentData.count;
}

//设置组的头视图的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

//设置单元格的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CommentModel *model = self.commentData[indexPath.row];
    
    //计算单元格的高度
    CGFloat height = [CommentsCell getCommentHeight:model];
    
    return height;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    CommentsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentsCell" forIndexPath:indexPath];
    
    CommentModel *model = _commentData[indexPath.row];

    cell.commentModel = model;
    
    return cell;
        
    
    
    
}






@end
