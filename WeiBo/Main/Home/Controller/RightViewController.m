//
//  RightViewController.m
//  WeiBo
//
//  Created by mac on 15/10/10.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "RightViewController.h"
#import "ThemeManager.h"
#import "SendWeiboViewController.h"
#import "BaseNavigationController.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"
#import "NearShopsViewController.h"

@interface RightViewController ()

@end

@implementation RightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _changeButtonImage];
    // Do any additional setup after loading the view.
}

- (void)dealloc{
    //移除观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (instancetype)init{
    self = [super init];
    if (self) {
        [self _changeButtonImage];
        //发送通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChange:) name:kThemeNameDidChangeNotification object:nil];
    }
    return self;
}


- (void)themeDidChange:(NSNotification *)notification{
    
    [self _changeButtonImage];
}

-(void)_changeButtonImage{
    
    NSArray *imageNames = @[@"newbar_icon_1.png",
                            @"newbar_icon_2.png",
                            @"newbar_icon_3.png",
                            @"newbar_icon_4.png",
                            @"newbar_icon_5.png"];
    
    ThemeManager *manager = [ThemeManager shareInstance];
    for (int i = 0 ; i < imageNames.count ; i ++) {
        UIImage *image = [manager getThemeImage:imageNames[i]];
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10, 64 + i * (40 + 20), 40, 40)];
        [button setBackgroundImage:image forState:UIControlStateNormal];

        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 50 + i;
        [self.view addSubview:button];
    }
    
    
}

- (void)buttonAction:(UIButton *)button{
    if (button.tag == 50) {
        NSLog(@"发送微博");
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:^(BOOL finished) {
            //弹出发送微博控制器
            SendWeiboViewController *sendWeibo = [[SendWeiboViewController alloc] init];
            BaseNavigationController *navi = [[BaseNavigationController alloc] initWithRootViewController:sendWeibo];
            [self presentViewController:navi animated:YES completion:nil];
        }];
    }else if (button.tag == 54){
        //附近地点
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:^(BOOL finished) {
            
            NearShopsViewController *nearShopsVC = [[NearShopsViewController alloc] init];
            nearShopsVC.title = @"附近商圈";
            
            //创建导航控制器
            BaseNavigationController *navi = [[BaseNavigationController alloc] initWithRootViewController:nearShopsVC];
            [self presentViewController:navi animated:YES completion:nil];
        }];

        
        
    }
    
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
