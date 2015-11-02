//
//  LeftViewController.m
//  WeiBo
//
//  Created by mac on 15/10/10.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "LeftViewController.h"
#import "ThemeLabel.h"

@interface LeftViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
}
@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _createView];
    // Do any additional setup after loading the view.
}

- (void)_createView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    
    _tableView.backgroundColor = [UIColor clearColor];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [self.view addSubview:_tableView];
    
    
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 5;
    }else{
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    

    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    if (indexPath.section == 0) {
        
        if(indexPath.row == 0){
            cell.textLabel.text = @"无";
        }else if(indexPath.row == 1){
            cell.textLabel.text = @"偏移";
        }else if(indexPath.row == 2){
            cell.textLabel.text = @"偏移&缩放";
        }else if(indexPath.row == 3){
            cell.textLabel.text = @"旋转";
        }else if(indexPath.row == 4){
            cell.textLabel.text = @"视差";
        }
    }
    else if(indexPath.section == 1){
        
        if (indexPath.row == 0) {
            cell.textLabel.text = @"小图";
;
        }else if (indexPath.row == 1) {
            cell.textLabel.text = @"大图";
;
        }
    }
    
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        ThemeLabel *firstLabel = [[ThemeLabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        firstLabel.text = @"界面切换效果";
        firstLabel.colorName = @"More_Item_Text_color";
        return firstLabel;
    }else{
        ThemeLabel *secondLabel = [[ThemeLabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        secondLabel.text = @"图片浏览模式";
        secondLabel.colorName = @"More_Item_Text_color";
        return secondLabel;
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
