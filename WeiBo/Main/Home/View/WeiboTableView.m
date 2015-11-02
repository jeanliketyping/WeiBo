//
//  WeiboTableView.m
//  WeiBo
//
//  Created by mac on 15/10/12.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "WeiboTableView.h"
#import "WeiboModel.h"
#import "WeiboCell.h"
#import "UIImageView+WebCache.h"
#import "WeiboViewLayoutFrame.h"
#import "UIView+UIViewController.h"
#import "WeiboDetailViewController.h"

@implementation WeiboTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    
    self = [super initWithFrame:frame style:style];
    
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        
        
//        [self registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        UINib *nib = [UINib nibWithNibName:@"WeiboCell" bundle:nil];
        [self registerNib:nib forCellReuseIdentifier:@"WeiboCell"];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WeiboCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WeiboCell" forIndexPath:indexPath];
    
    WeiboViewLayoutFrame *layout = _data[indexPath.row];


    cell.layout = layout;
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WeiboViewLayoutFrame *layout = _data[indexPath.row];
    return layout.frame.size.height + 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WeiboDetailViewController *vc = [[WeiboDetailViewController alloc] init];
    
    WeiboViewLayoutFrame *layout = _data[indexPath.row];
    WeiboModel *model = layout.model;
    vc.model = model;

    [self.viewController.navigationController pushViewController:vc animated:YES];
    
}










@end
