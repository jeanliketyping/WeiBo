//
//  ThemeViewController.m
//  WeiBo
//
//  Created by mac on 15/10/9.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "ThemeViewController.h"
#import "ThemeManager.h"
#import "MoreCell.h"

@interface ThemeViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSDictionary *_themeConfig;
    NSArray *_themeNames;
    UITableView *_tableView;
    
}
@end

@implementation ThemeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _readData];
    [self _createView];
    
    // Do any additional setup after loading the view.
}

- (void)_readData
{
    NSString *configPath = [[NSBundle mainBundle] pathForResource:@"theme" ofType:@"plist"];
    _themeConfig = [NSDictionary dictionaryWithContentsOfFile:configPath];
    _themeNames = [_themeConfig allKeys];
}

- (void)_createView
{
    
    _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[MoreCell class] forCellReuseIdentifier:@"moreCell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _themeNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"moreCell" forIndexPath:indexPath];
    
    cell.themeTextLabel.colorName = @"More_Item_Text_color";
    cell.themeTextLabel.text = _themeNames[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ThemeManager *manager = [ThemeManager shareInstance];
    manager.themeName = _themeNames[indexPath.row];
    _block(_themeNames[indexPath.row]);

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
