//
//  MainTabBarController.m
//  WeiBo
//
//  Created by mac on 15/10/8.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "MainTabBarController.h"
#import "BaseNavigationController.h"
#import "ThemeImageView.h"
#import "ThemeButton.h"
#import "AppDelegate.h"
#import "ThemeLabel.h"

@interface MainTabBarController ()
{
    ThemeImageView *_selectedImageView;
    
    ThemeImageView *_badgeImageView;
    ThemeLabel *_badgeLabel;
}
@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    //加载子控制器
    [self _createSubController];
    //设置tabbar
    [self _createTabBar];
    //定时器 请求 获取 未读消息
    [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//创建子控制器
-(void)_createSubController
{
    NSArray *names = @[@"HomeStoryboard",
                       @"DiscoverStoryboard",
                       @"ProfileStoryboard",
                       @"MoreStoryboard"];
    NSMutableArray *navis = [NSMutableArray array];
    
    for (int i = 0; i < names.count; i ++) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:names[i] bundle:nil];
        BaseNavigationController *navi = [storyboard instantiateInitialViewController];
        [navis addObject:navi];
    }
    
    self.viewControllers = navis;

}

-(void)_createTabBar
{
    //移除tabBarButton
    for (UIView *view in self.tabBar.subviews) {
        //通过字符串获得类对象
        Class class = NSClassFromString(@"UITabBarButton");
        if ([view isKindOfClass:class]) {
            [view removeFromSuperview];
        }
    }
    
//    @"Skins/cat/mask_navbar.png" tabBar背景
//    @"Skins/cat/home_bottom_tab_arrow.png" 选中图片
//    @"Skins/cat/home_tab_icon_1.png" 图片
    
    CGFloat width = kScreenWidth / 4;
    
    
    //添加背景图片
    ThemeImageView *imageView = [[ThemeImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 49)];
//    imageView.image = [UIImage imageNamed:@"Skins/cat/mask_navbar.png"];
    imageView.imageName = @"mask_navbar.png";
    [self.tabBar addSubview:imageView];
    
    //选中图片
    _selectedImageView = [[ThemeImageView alloc] initWithFrame:CGRectMake(0, 0, width, 49)];
    _selectedImageView.imageName = @"home_bottom_tab_arrow.png";
    [self.tabBar addSubview:_selectedImageView];
    
    //设置按钮
    /*
    NSArray *imageNames = @[@"Skins/cat/home_tab_icon_1.png",
                            @"Skins/cat/home_tab_icon_2.png",
                            @"Skins/cat/home_tab_icon_3.png",
                            @"Skins/cat/home_tab_icon_4.png",
                            @"Skins/cat/home_tab_icon_5.png"];
     */
    NSArray *imageNames = @[@"home_tab_icon_1.png",
//                            @"home_tab_icon_2.png",
                            @"home_tab_icon_3.png",
                            @"home_tab_icon_4.png",
                            @"home_tab_icon_5.png"];
    
    for (int i = 0; i < imageNames.count; i ++) {
        ThemeButton *button = [[ThemeButton alloc] initWithFrame:CGRectMake(i * width, 0, width, 49)];
        [button setNormalButtonImage:imageNames[i]];
        
        button.tag = i;
        
        [button addTarget:self action:@selector(selecteAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.tabBar addSubview:button];
    }
}


-(void)selecteAction:(UIButton *)button
{
    [UIView animateWithDuration:.35 animations:^{
        _selectedImageView.center = button.center;
    }];
    
    self.selectedIndex = button.tag;
}

- (void)timerAction:(NSTimer *)timer{
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;

    SinaWeibo *sinaWeibo = appDelegate.sinaWeibo;
    
    [sinaWeibo requestWithURL:unread_count params:nil httpMethod:@"GET" delegate:self];
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result{
    
    NSNumber *status = [result objectForKey:@"status"];
    NSInteger count = [status integerValue];
    
    CGFloat buttonWidth = kScreenWidth / 4;
    
    if (_badgeImageView == nil) {
        
        _badgeImageView = [[ThemeImageView alloc] initWithFrame:CGRectMake(buttonWidth - 32, 0, 32, 32)];
        _badgeImageView.imageName = @"number_notify_9.png";
        
        [self.tabBar addSubview:_badgeImageView];
        
        _badgeLabel = [[ThemeLabel alloc] initWithFrame:_badgeImageView.bounds];
        _badgeLabel.backgroundColor = [UIColor clearColor];
        _badgeLabel.colorName = @"Timeline_Notice_color";
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
        _badgeLabel.font = [UIFont systemFontOfSize:13];
        [_badgeImageView addSubview:_badgeLabel];
    }
    
    if (count == 0) {
        _badgeImageView.hidden = YES;
    }else if (count > 99){
        _badgeImageView.hidden = NO;
        _badgeLabel.text = @"99";
    }else{
        _badgeImageView.hidden = NO;
        _badgeLabel.text = [NSString stringWithFormat:@"%ld",count];
    }
    
    
    
    
}







@end
