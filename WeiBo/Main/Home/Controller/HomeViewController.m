//
//  HomeViewController.m
//  WeiBo
//
//  Created by mac on 15/10/8.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"
#import "SinaWeibo.h"
#import "ThemeManager.h"
#import "WeiboModel.h"
#import "WeiboTableView.h"
#import "WeiboViewLayoutFrame.h"
#import "MJRefresh.h"
#import "ThemeImageView.h"
#import "ThemeLabel.h"
#import <AudioToolbox/AudioToolbox.h>

@interface HomeViewController ()
{
    WeiboTableView *_tableView;
    NSMutableArray *_data;
    ThemeImageView *_barImageView;
    ThemeLabel *_barLabel;
}
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavi];
    _data = [[NSMutableArray alloc] init];
    [self _createTableView];
}

- (void)viewDidAppear:(BOOL)animated{
    [self _loadData];
}

- (void)_createTableView{
    _tableView = [[WeiboTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(_loadNewData)];
    _tableView.footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(_loadMoreData)];
    
}

#pragma mark - 微博请求

- (void)_loadMoreData{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    SinaWeibo *sinaWeibo = delegate.sinaWeibo;
    
    //如果已经登陆则获取微博数据
    if (sinaWeibo.isLoggedIn) {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:@"10" forKey:@"count"];
        if (_data != nil) {
            WeiboViewLayoutFrame *layout = [_data lastObject];
            WeiboModel *model = layout.model;
            NSString *maxID = model.weiboIdStr;
            [params setObject:maxID forKey:@"max_id"];
        }
        SinaWeiboRequest *request = [sinaWeibo requestWithURL:home_timeline
                                                       params:params
                                                   httpMethod:@"GET"
                                                     delegate:self];
        
        request.tag = 302;
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请登录" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    
}

- (void)_loadNewData{
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    SinaWeibo *sinaWeibo = delegate.sinaWeibo;
    //如果已经登陆则获取微博数据
    if (sinaWeibo.isLoggedIn){
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:@"10" forKey:@"count"];
        if (_data != nil) {
            WeiboViewLayoutFrame *layout = _data[0];
            WeiboModel *model = layout.model;
            NSString *sinceID = model.weiboIdStr;
            [params setObject:sinceID forKey:@"since_id"];
        }
        
        SinaWeiboRequest *request = [sinaWeibo requestWithURL:home_timeline
                                                       params:params
                                                   httpMethod:@"GET"
                                                     delegate:self];
        request.tag = 301;
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请登录" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}



- (void)_loadData{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    SinaWeibo *sinaWeibo = delegate.sinaWeibo;
    //如果已经登陆则获取微博数据
    if (sinaWeibo.isLoggedIn){
        [self showHud:@"正在加载..."];
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:@"10" forKey:@"count"];
        
        SinaWeiboRequest *request = [sinaWeibo requestWithURL:home_timeline
                                                       params:params
                                                   httpMethod:@"GET"
                                                     delegate:self];
        request.tag = 300;
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请登录" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
    }
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
        WeiboModel *model = [[WeiboModel alloc] initWithDataDic:dic];
        WeiboViewLayoutFrame *layout = [[WeiboViewLayoutFrame alloc] init];
        layout.model = model;
        [layoutFrameArray addObject:layout];
    }
    
    if (request.tag == 300) {//普通加载
        _data = layoutFrameArray;
        [self completeHud:@"加载完成"];
        [self hideHud];
    }else if (request.tag == 301){// 刷新微博
        if (_data == nil) {
            _data = layoutFrameArray;
        }else{
            NSRange range = NSMakeRange(0, layoutFrameArray.count);
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
            [_data insertObjects:layoutFrameArray atIndexes:indexSet];
            [self showNewWeiboCount:layoutFrameArray.count];
        }
    }else if (request.tag == 302){// 加载微博
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
    
    [_tableView.header endRefreshing];
    [_tableView.footer endRefreshing];
    
}

- (void)showNewWeiboCount:(NSInteger)count{
    if (_barImageView == nil) {
        
        _barImageView = [[ThemeImageView alloc] initWithFrame:CGRectMake(5, -40, kScreenWidth - 10, 40)];
        _barImageView.imageName = @"timeline_notify.png";
        [self.view addSubview:_barImageView];
        
        _barLabel = [[ThemeLabel alloc] initWithFrame:_barImageView.bounds];
        _barLabel.colorName = @"Timeline_Notice_color";
        _barLabel.backgroundColor = [UIColor clearColor];
        _barLabel.textAlignment = NSTextAlignmentCenter;
        
        [_barImageView addSubview:_barLabel];
    }
    
    if (count > 0) {
        _barLabel.text = [NSString stringWithFormat:@"更新了%ld条微博",count];
        [UIView animateWithDuration:0.6 animations:^{
            _barImageView.transform = CGAffineTransformMakeTranslation(0, 64+5+40);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.6 animations:^{
                [UIView setAnimationDelay:1];//让提示停留1s
                _barImageView.transform = CGAffineTransformIdentity;
            }];
        }];
    }
    
    //播放声音
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"msgcome" ofType:@"wav"];
    NSURL *url = [NSURL fileURLWithPath:path];
    
    //注册系统声音
    SystemSoundID soundId;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundId);
    AudioServicesPlaySystemSound(soundId);
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
