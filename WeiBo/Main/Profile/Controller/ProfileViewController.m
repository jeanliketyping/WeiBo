//
//  ProfileViewController.m
//  WeiBo
//
//  Created by mac on 15/10/8.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "ProfileViewController.h"
#import "AppDelegate.h"
#import "SinaWeibo.h"
#import "ThemeManager.h"
#import "WeiboModel.h"
#import "WeiboViewLayoutFrame.h"
#import "WeiboTableView.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "FollowersListViewController.h"
#import "FriendsListViewController.h"
#import "BaseNavigationController.h"

@interface ProfileViewController ()
{
    UIView *_bgView;
    UIImageView *_iconImageView;
    UILabel *_nickNameLabel;
    UILabel *_msgLabel;
    UILabel *_descriptionLabel;
    
    WeiboTableView *_tableView;
    NSMutableArray *_data;
    
    FollowersListViewController *_followers;
    FriendsListViewController *_friends;
}


@end

@implementation ProfileViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self _createViews];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated{
    [self _loadData];
}


- (void)_createViews{
    
    _tableView = [[WeiboTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    _tableView.footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(_loadMoreData)];
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 70, kScreenWidth - 20, 160)];
    
    
    //头像
    _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 80, 80)];
    _iconImageView.backgroundColor = [UIColor redColor];
    [_bgView addSubview:_iconImageView];
    
    //昵称
    _nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, _bgView.frame.size.width - 100, 20)];
    _nickNameLabel.font = [UIFont systemFontOfSize:20];
    _nickNameLabel.text = @"昵称";
    [_bgView addSubview:_nickNameLabel];
    
    //信息
    _msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 40, _bgView.frame.size.width - 100, 15)];
    _msgLabel.font = [UIFont systemFontOfSize:15];
    _msgLabel.text = @"基本信息";
    [_bgView addSubview:_msgLabel];
    
    //简介
    _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 65, _bgView.frame.size.width - 100, 15)];
    _descriptionLabel.font = [UIFont systemFontOfSize:15];
    _descriptionLabel.text = @"简介";
    [_bgView addSubview:_descriptionLabel];
    
    //4个button
    NSArray *buttonNames = @[@"关注",@"粉丝",@"资料",@"更多"];
    for (int i = 0; i < 4; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(5 + (60 + 10) * i, 90, 60, 60)];
        
        button.backgroundColor = [UIColor lightGrayColor];
        
        UILabel *buttonNameLabel = [[UILabel alloc] init];
        
        if (i == 0 || i == 1) {
            UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 60, 10)];
            countLabel.text = @"0";
            if (i == 0) {
                countLabel.tag = 300;
            }else{
                countLabel.tag = 301;
            }
            countLabel.textAlignment = NSTextAlignmentCenter;
            buttonNameLabel.frame = CGRectMake(0, 40, 60, 10);
            buttonNameLabel.textAlignment = NSTextAlignmentCenter;
            buttonNameLabel.text = buttonNames[i];
            [button addSubview:countLabel];
            [button addSubview:buttonNameLabel];
        }
        else{
            buttonNameLabel.frame = CGRectMake(0, 25, 60, 10);
            buttonNameLabel.text = buttonNames[i];
            buttonNameLabel.textAlignment = NSTextAlignmentCenter;
            [button addSubview:buttonNameLabel];
        }
        
        if (i == 0) {
            [button addTarget:self action:@selector(friendsList:) forControlEvents:UIControlEventTouchUpInside];
        }else if (i == 1){
            [button addTarget:self action:@selector(followersList:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [_bgView addSubview:button];
    }
    
    _tableView.tableHeaderView = _bgView;
    
    _followers = [[FollowersListViewController alloc] init];
    
    _friends = [[FriendsListViewController alloc] init];
}
//上拉加载更多以往数据
- (void)_loadMoreData{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    SinaWeibo *sinaWeibo = delegate.sinaWeibo;
    if (sinaWeibo.isLoggedIn) {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:sinaWeibo.userID forKey:@"uid"];
        //    [params setObject:@"10" forKey:@"count"];
        WeiboViewLayoutFrame *layout = [_data lastObject];
        WeiboModel *model = layout.model;
        NSString *maxID = model.weiboIdStr;
        [params setObject:maxID forKey:@"max_id"];
        
        SinaWeiboRequest *request = [sinaWeibo requestWithURL:@"statuses/user_timeline.json"
                                                       params:params
                                                   httpMethod:@"GET"
                                                     delegate:self];
        request.tag = 601;
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请登录" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
    }
}

//普通加载数据
- (void)_loadData{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    SinaWeibo *sinaWeibo = delegate.sinaWeibo;
    if (sinaWeibo.isLoggedIn) {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:sinaWeibo.userID forKey:@"uid"];
        //    [params setObject:@"10" forKey:@"count"];
        SinaWeiboRequest *request = [sinaWeibo requestWithURL:@"statuses/user_timeline.json"
                                                       params:params
                                                   httpMethod:@"GET"
                                                     delegate:self];
        request.tag = 600;
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请登录" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
    }
}

//加载个人数据
- (void)_loadProfileData:(WeiboModel *)weiboModel{
    NSString *urlStr = weiboModel.userModel.avatar_large;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:urlStr]];
    _nickNameLabel.text = weiboModel.userModel.screen_name;
    NSString *genderText;
    if ([weiboModel.userModel.gender isEqualToString:@"f"]) {
        genderText = @"女";
    }else if ([weiboModel.userModel.gender isEqualToString:@"m"]){
        genderText = @"男";
    }
    _msgLabel.text = [NSString stringWithFormat:@"%@ %@",genderText,weiboModel.userModel.location];
    _descriptionLabel.text =
    [NSString stringWithFormat:@"简介:%@",weiboModel.userModel.description];
    UILabel *friendsLabel = (UILabel *)[self.view viewWithTag:300];
    friendsLabel.text = [weiboModel.userModel.friends_count stringValue];
    UILabel *followersLabel = (UILabel *)[self.view viewWithTag:301];
    followersLabel.text = [weiboModel.userModel.followers_count stringValue];
}

- (void)followersList:(UIButton *)button{
    NSLog(@"粉丝列表");
    [self.navigationController pushViewController:_followers animated:YES];
}

- (void)friendsList:(UIButton *)button{
    NSLog(@"关注列表");
    [self.navigationController pushViewController:_friends animated:YES];
}

- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"didFail");
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    NSLog(@"%@",result);
    //每一条微博存到 数组里
    NSArray *statusesArray = [result objectForKey:@"statuses"];
    NSMutableArray *layoutFrameArray = [[NSMutableArray alloc] init];
    
    //解析model
    for (NSDictionary *dic in statusesArray) {
        WeiboModel *model = [[WeiboModel alloc] initWithDataDic:dic
                         ];
        WeiboViewLayoutFrame *layout = [[WeiboViewLayoutFrame alloc] init];
        layout.model = model;
        [layoutFrameArray addObject:layout];
    }
    WeiboViewLayoutFrame *layoutLatest = [layoutFrameArray lastObject];
    WeiboModel *weiboModel = layoutLatest.model;
    _followers.model = layoutLatest.model;
    _friends.model = layoutLatest.model;
    [self _loadProfileData:weiboModel];
    if (request.tag == 600) {//普通加载
        _data = layoutFrameArray;
    }else if (request.tag == 601){//加载更多
        if (_data == nil) {
            _data = layoutFrameArray;
        }else{
            [_data removeLastObject];
            [_data addObjectsFromArray:layoutFrameArray];
        }
    }
    if (_data != nil) {
        _tableView.data = _data;
        [_tableView reloadData];
    }
    [_tableView.footer endRefreshing];
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
