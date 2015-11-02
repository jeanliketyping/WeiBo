//
//  WeiboAnnotation.m
//  WeiBo
//
//  Created by mac on 15/10/20.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "WeiboAnnotation.h"

@implementation WeiboAnnotation

- (void)setModel:(WeiboModel *)model{
    
    if (_model != model) {
        _model = model;
        
        NSDictionary *geo = model.geo;
        NSArray *coordiates = [geo objectForKey:@"coordinates"];
        if (coordiates.count > 1) {
            
            NSString *longtude = coordiates[0];
            NSString *latitude = coordiates[1];
            
            self.coordinate = CLLocationCoordinate2DMake([longtude floatValue], [latitude floatValue]);
        }
    }
}

@end
