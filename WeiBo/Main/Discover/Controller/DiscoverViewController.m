//
//  DiscoverViewController.m
//  WeiBo
//
//  Created by mac on 15/10/8.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "DiscoverViewController.h"
#import "NearByWeiboViewController.h"
#import "BaseNavigationController.h"

@interface DiscoverViewController ()

@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nearByWeiboAction:(UIButton *)sender {
    
    NearByWeiboViewController *nearByWeiboVC = [[NearByWeiboViewController alloc] init];
    nearByWeiboVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:nearByWeiboVC animated:YES];
    
}


- (IBAction)nearByPeopleAction:(UIButton *)sender {
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
