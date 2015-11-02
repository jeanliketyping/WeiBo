//
//  BaseViewController.m
//  WeiBo
//
//  Created by mac on 15/10/8.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "BaseViewController.h"
#import "ThemeManager.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"
#import "MBProgressHUD.h"
#import "UIProgressView+AFNetworking.h"

@interface BaseViewController ()
{
    MBProgressHUD *_hud;
    UIView *_tipView;
    UIWindow *_tipWindow;
}
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _loadBGImage];
    // Do any additional setup after loading the view.
    
}

- (void)viewWillAppear:(BOOL)animated{
    [self _loadBGImage];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {

        //发送通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChange:) name:kThemeNameDidChangeNotification object:nil];
        
    }
    return self;
}

- (void)themeDidChange:(NSNotification *)notification{
    
    [self _loadBGImage];
    [self setNavi];
    
}

- (void)_loadBGImage{
    
    ThemeManager *manager = [ThemeManager shareInstance];
    UIImage *bgImage = [manager getThemeImage:@"bg_home.jpg"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:bgImage];

}


- (void)setNavi{
    
    ThemeManager *manager = [ThemeManager shareInstance];
    
    UIImage *leftImage = [manager getThemeImage:@"group_btn_all_on_title.png"];
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [leftButton setBackgroundImage:leftImage forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(setAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    UIImage *rightImage = [manager getThemeImage:@"button_icon_plus.png"];
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [rightButton setBackgroundImage:rightImage forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(editAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;

}



-(void)setAction{
    
    MMDrawerController *mmDraw = self.mm_drawerController;

    [mmDraw openDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(void)editAction{
    MMDrawerController *mmDraw = self.mm_drawerController;
    
    [mmDraw openDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}



- (void)showHud:(NSString *)title{
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_hud show:YES];
    _hud.labelText = title;
    _hud.dimBackground = YES;//阴影
    
}

- (void)hideHud{
    
    [_hud hide:YES afterDelay:1];
    
}

- (void)completeHud:(NSString *)title{
    
    _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
    _hud.mode = MBProgressHUDModeCustomView;
    _hud.labelText = title;
  
}


//- (void)showLoading:(BOOL)show{
//    
//    
//    if (_tipView == nil) {
//        
//        _tipView = [[UIView alloc] initWithFrame:CGRectMake(0, (kScreenWidth - 30)/2, kScreenWidth, 30)];
//        _tipView.backgroundColor = [UIColor clearColor];
//        
//        
//        UIActivityIndicatorView *aiView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//        aiView.tag = 50;
//        [_tipView addSubview:aiView];
//        
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
//        label.backgroundColor = [UIColor clearColor];
//        label.text = @"正在加载...";
//        label.textColor = [UIColor blackColor];
//        label.font = [UIFont systemFontOfSize:10];
//        [_tipView addSubview:label];
//        
//        label.left = (kScreenWidth - label.width) / 2;
//        aiView.right = label.left - 5;
//    }
//    
//    if (show) {
//        UIActivityIndicatorView *aiView = (UIActivityIndicatorView *)[self.view viewWithTag:50];
//        [aiView startAnimating];
//        [self.view addSubview:aiView];
//    }else{
//        UIActivityIndicatorView *aiView = (UIActivityIndicatorView *)[self.view viewWithTag:50];
//        [aiView stopAnimating];
//        [_tipView removeFromSuperview];
//        
//    }
//    
//    
//}


- (void)showStatusTip:(NSString *)title show:(BOOL)show operation:(AFHTTPRequestOperation *)operation{
    
    if (_tipWindow == nil) {
        
        _tipWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        _tipWindow.windowLevel = UIWindowLevelAlert;
        _tipWindow.backgroundColor = [UIColor blackColor];
        
        UILabel *label = [[UILabel alloc] initWithFrame:_tipWindow.bounds];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:12];
        label.tag = 500;
        [_tipWindow addSubview:label];
        
        UIProgressView *progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        progressView.frame = CGRectMake(0, 20 - 3, kScreenWidth, 5);
        progressView.tag = 501;
        progressView.progress = 0.0f;
        [_tipWindow addSubview:progressView];
        
    }
    
    UILabel *label = (UILabel *)[_tipWindow viewWithTag:500];
    label.text = title;
    
    UIProgressView *progressView = (UIProgressView *)[_tipWindow viewWithTag:501];
    
    
    if (show) {
        [_tipWindow setHidden:NO];
        if (operation != nil) {
            progressView.hidden = NO;
            [progressView setProgressWithUploadProgressOfOperation:operation animated:YES];
        }else {
            progressView.hidden = YES;
        }

    }else{
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_tipWindow setHidden:YES];
            _tipWindow = nil;
        });
        
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
