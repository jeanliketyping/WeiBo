//
//  BaseNavigationController.m
//  WeiBo
//
//  Created by mac on 15/10/8.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "BaseNavigationController.h"
#import "ThemeManager.h"


@interface BaseNavigationController ()

@end

@implementation BaseNavigationController




-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        [self _loadImage];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChange:) name:kThemeNameDidChangeNotification object:nil];
        
    }
    return self;
}


- (void)themeDidChange:(NSNotification *)notification{
    
    [self _loadImage];
    
}

- (void)_loadImage{
    
    ThemeManager *manager = [ThemeManager shareInstance];
    UIImage *image = [manager getThemeImage:@"mask_titlebar64@2x.png"];
    [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    

    UIColor *color = [manager getColor:@"Mask_Title_color"];
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:color};
    
//    UIImage *bgImage = [manager getThemeImage:@"bg_home.jpg"];
//    self.view.backgroundColor = [UIColor colorWithPatternImage:bgImage];
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self _loadImage];
    // Do any additional setup after loading the view.
    
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
