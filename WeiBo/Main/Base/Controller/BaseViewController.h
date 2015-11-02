//
//  BaseViewController.h
//  WeiBo
//
//  Created by mac on 15/10/8.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFHTTPRequestOperation.h"

@interface BaseViewController : UIViewController

- (void)showHud:(NSString *)title;
- (void)hideHud;
- (void)completeHud:(NSString *)title;
- (void)showLoading:(BOOL)show;
- (void)setNavi;

- (void)showStatusTip:(NSString *)title show:(BOOL)show operation:(AFHTTPRequestOperation *)operation;
@end
