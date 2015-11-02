//
//  ThemeViewController.h
//  WeiBo
//
//  Created by mac on 15/10/9.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NSString* (^ThemeNameBlock) (NSString*);
@interface ThemeViewController : UIViewController

@property(nonatomic,copy)ThemeNameBlock block;


@end
