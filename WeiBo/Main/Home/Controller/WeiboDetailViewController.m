//
//  WeiboDetailViewController.m
//  WeiBo
//
//  Created by mac on 15/10/16.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "WeiboDetailViewController.h"
#import "AppDelegate.h"
#import "SinaWeibo.h"
#import "DetailWeiboTableView.h"
#import "CommentModel.h"
#import "MJRefresh.h"



@interface WeiboDetailViewController (){
    DetailWeiboTableView *_tableView;
    
}

@end

@implementation WeiboDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"微博详情";
    [self createtableView];
    [self loadData];
    // Do any additional setup after loading the view.
}


- (void)createtableView{
    
    _tableView = [[DetailWeiboTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    
    [self.view addSubview:_tableView];
    
    _tableView.model = self.model;
    
    //上拉加载
    _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(_loadMoreData)];
}

//加载数据
- (void)loadData{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    SinaWeibo *sinaWeibo = delegate.sinaWeibo;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSString *weiboId = self.model.weiboIdStr;
    [params setObject:weiboId forKey:@"id"];
    
    SinaWeiboRequest *request = [sinaWeibo requestWithURL:comments
                                                   params:params
                                               httpMethod:@"GET"
                                                 delegate:self];
    request.tag = 400;
}

//加载更多数据
- (void)_loadMoreData{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    SinaWeibo *sinaWeibo = delegate.sinaWeibo;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSString *weiboId = self.model.weiboIdStr;
    [params setObject:weiboId forKey:@"id"];
    //设置max_id 分页加载
    CommentModel *cm = [self.data lastObject];
    if (cm == nil) {
        return;
    }
    NSString *lastID = cm.idstr;
    [params setObject:lastID forKey:@"max_id"];
    SinaWeiboRequest *request = [sinaWeibo requestWithURL:comments
                                                   params:params
                                               httpMethod:@"GET"
                                                 delegate:self];
    request.tag = 401;
    
    
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result{
    
    NSArray *commentsArray = [result objectForKey:@"comments"];
    
    NSMutableArray *commentModelArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dic in commentsArray) {
        
        CommentModel *commentModel = [[CommentModel alloc] initWithDataDic:dic];
        [commentModelArray addObject:commentModel];
    }
    
    if (request.tag == 400) {
        self.data = commentModelArray;
        
    }else if(request.tag ==401){//更多数据
        [_tableView.footer endRefreshing];
        if (commentModelArray.count > 1) {
            [commentModelArray removeObjectAtIndex:0];
            [self.data addObjectsFromArray:commentModelArray];
        }else{
            return;
        }
    }
    
    _tableView.commentData = commentModelArray;
    _tableView.commentDic = result;
    [_tableView reloadData];
        
        
}








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
