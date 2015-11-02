//
//  FriendsListViewController.m
//  WeiBo
//
//  Created by mac on 15/10/21.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "FriendsListViewController.h"
#import "FFCollectionView.h"
#import "AppDelegate.h"
#import "FollowerModel.h"
@interface FriendsListViewController ()<SinaWeiboRequestDelegate>
{
    FFCollectionView *_collectionView;
}

@end

@implementation FriendsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关注列表";
    [self createViews];
    [self loadData];
    // Do any additional setup after loading the view.
}

- (void)createViews{
    
    //创建布局对象
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(100, 100);
    layout.minimumInteritemSpacing = 5;
    //设置滚动方向
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //设置四周空隙
    //    layout.sectionInset = UIEdgeInsetsMake(<#CGFloat top#>, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>);
    
    layout.sectionInset = UIEdgeInsetsMake(-45, 17, 0, 17);
    
    _collectionView = [[FFCollectionView alloc] initWithFrame:CGRectMake(-5, 64, kScreenWidth + 10, kScreenHeight - 64) collectionViewLayout:layout];
    [self.view addSubview:_collectionView];
    
}

//加载数据
- (void)loadData{
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    SinaWeibo *sinaWeibo = delegate.sinaWeibo;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:_model.userModel.idstr forKey:@"uid"];
    
    [sinaWeibo requestWithURL:@"friendships/friends.json"
                       params:params
                   httpMethod:@"GET"
                     delegate:self];
    
}


- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    
    NSLog(@"%@",result);
    
    //每一个用户信息存到数组里
    NSArray *usersArray = [result objectForKey:@"users"];
    NSMutableArray *modelArray = [[NSMutableArray alloc] init];
    //解析model
    for (NSDictionary *dic in usersArray) {
        FollowerModel *model = [[FollowerModel alloc] init];
        model.profile_image_url = dic[@"profile_image_url"];
        model.name = dic[@"name"];
        model.followers_count = dic[@"followers_count"];
        [modelArray addObject:model];
        
    }
    
    if (modelArray != nil) {
        _collectionView.data = modelArray;
        [_collectionView reloadData];
        
    }
    
}














- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}










@end
