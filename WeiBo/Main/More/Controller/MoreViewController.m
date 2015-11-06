//
//  MoreViewController.m
//  WeiBo
//
//  Created by mac on 15/10/8.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "MoreViewController.h"
#import "ThemeImageView.h"
#import "ThemeViewController.h"
#import "AppDelegate.h"
#import "SinaWeibo.h"
#import "ThemeManager.h"
#import "ThemeLabel.h"
#import "MoreCell.h"

@interface MoreViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,SinaWeiboDelegate>
{
    UITableView *_tableView;
    SinaWeibo *_sinaWeibo;
}

@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _createView];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    _sinaWeibo = delegate.sinaWeibo;
    _sinaWeibo.delegate = self;
    // Do any additional setup after loading the view.
}


-(void)_createView{
    //创建表视图
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    
    _tableView.backgroundColor = [UIColor clearColor];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[MoreCell class] forCellReuseIdentifier:@"moreCell"];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }if (section == 1) {
        return 1;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"moreCell" forIndexPath:indexPath];
    cell.themeTextLabel.colorName = @"More_Item_Text_color";
    cell.themeDetailLabel.colorName = @"More_Item_Text_color";
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            cell.themeimageView.imageName = @"more_icon_theme.png";
            cell.themeTextLabel.text = @"主题选择";
            ThemeManager *manager = [ThemeManager shareInstance];
            cell.themeDetailLabel.text = manager.themeName;
            cell.themeDetailLabel.tag = 200;
        }
        else if (indexPath.row == 1){
            cell.themeimageView.imageName = @"more_icon_account.png";
            cell.themeTextLabel.text = @"账户管理";
        }
    }
    else if (indexPath.section == 1){
        cell.themeimageView.imageName = @"more_icon_feedback.png";
        cell.themeTextLabel.text = @"意见反馈";
    }
    else if(indexPath.section == 2){
        
        if ([_sinaWeibo isLoggedIn]) {
            NSLog(@"已经登录");
            cell.themeTextLabel.text = @"登出当前账号";
        }else{
            cell.themeTextLabel.text = @"请登录";
        }
        cell.themeTextLabel.textAlignment = NSTextAlignmentCenter;
        cell.themeTextLabel.tag = 201;
        
    }
    
    if (indexPath.section < 2) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            ThemeViewController *theme = [[ThemeViewController alloc] init];
            
            //参数回传的方法
            [theme setBlock:^(NSString *str){
                UILabel *label = (UILabel *)[self.view viewWithTag:200];
                label.text = str;
                return label.text;
            }];
            
            [self.navigationController pushViewController:theme animated:YES];
        }
        
    }
    if (indexPath.section == 2) {
        UILabel *label = (UILabel *)[self.view viewWithTag:201];
        
        if ([label.text isEqualToString:@"请登录"]) {
            [_sinaWeibo logIn];
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"确认登出么？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            alert.delegate = self;
            [alert show];
            
        }
    }
}

- (void)storeAuthData
{
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              _sinaWeibo.accessToken, @"AccessTokenKey",
                              _sinaWeibo.expirationDate, @"ExpirationDateKey",
                              _sinaWeibo.userID, @"UserIDKey",
                              _sinaWeibo.refreshToken, @"refresh_token", nil];
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"WeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"%@",NSHomeDirectory());
}

- (void)removeAuthData
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"WeiboAuthData"];
}

#pragma mark - SinaWeibo Delegate
//确认登录
- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"登录成功" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
    alert.delegate = self;
    [alert show];
    [self storeAuthData];
}
//确认登出
- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{
    //    NSLog(@"sinaweiboDidLogOut");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"登出成功" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
    alert.delegate = self;
    [self removeAuthData];
}

#pragma mark - alertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%ld",buttonIndex);//0:取消 1:确认
    if (buttonIndex == 0) {
        _userStateLabel.text = @"登出当前账号";
        [_tableView reloadData];
    }else{
        [_sinaWeibo logOut];
        _userStateLabel.text = @"请登录";
        [_tableView reloadData];
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
