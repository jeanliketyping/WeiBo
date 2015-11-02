//
//  WeiboModel.m
//  WeiBo
//
//  Created by mac on 15/10/12.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//


#import "WeiboModel.h"
#import "RegexKitLite.h"

@implementation WeiboModel

-(NSDictionary *)attributeMapDictionary{
    
    //@"属性名"：@"数据字典的key"
    NSDictionary *mapAtt = @{
                             @"createDate":@"created_at",
                             @"weiboId":@"id",
                             @"text":@"text",
                             @"source":@"source",
                             @"favorited":@"favorited",
                             @"thumbnailImage":@"thumbnail_pic",
                             @"bmiddlelImage":@"bmiddle_pic",
                             @"originalImage":@"original_pic",
                             @"geo":@"geo",
                             @"repostsCount":@"reposts_count",
                             @"commentsCount":@"comments_count",
                             @"weiboIdStr":@"idstr"
                             };
    
    
    return mapAtt;
    
}

- (void)setAttributes:(NSDictionary *)dataDic{
    
    //调用父类的设置方法
    [super setAttributes:dataDic];
    
    if (_source != nil) {
        
        NSString *regex = @">.+<";
        NSArray *array = [_source componentsMatchedByRegex:regex];
        if (array.count != 0) {
            NSString *str = array[0];
            //>微博<
            str = [str substringWithRange:NSMakeRange(1, str.length - 2)];
            _source = [NSString stringWithFormat:@"%@",str];
        }
    }
    
    //用户信息解析
    NSDictionary *userDic = [dataDic objectForKey:@"user"];
    if (userDic != nil) {
        _userModel = [[UserModel alloc] initWithDataDic:userDic];
    }
    
    //被转发的微博
    NSDictionary *reWeiboDic = [dataDic objectForKey: @"retweeted_status"];
    if (reWeiboDic != nil) {
        _reWeiboModel = [[WeiboModel alloc] initWithDataDic:reWeiboDic];
        
        //转发微博的用户的名字处理，拼接字符串
        NSString *name = _reWeiboModel.userModel.name;
        _reWeiboModel.text = [NSString stringWithFormat:@"@%@:%@",name,_reWeiboModel.text];
    }
    
    
    NSString *regex = @"\\[\\w+\\]";
    NSArray *faceItems = [_text componentsMatchedByRegex:regex];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"emoticons" ofType:@"plist"];
    NSArray *faceConfigArray = [NSArray arrayWithContentsOfFile:filePath];
    
    for (NSString *faceName in faceItems) {
        
        NSString *t = [NSString stringWithFormat:@"self.chs='%@'",faceName];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:t];
        
        NSArray *items = [faceConfigArray filteredArrayUsingPredicate:predicate];
        if (items.count > 0) {
            
            NSString *imageName = [items[0] objectForKey:@"png"];
            
            NSString *urlStr = [NSString stringWithFormat:@"<image url = '%@'>",imageName];
            
            _text = [_text stringByReplacingOccurrencesOfString:faceName withString:urlStr];
        }
        
    }
}

@end
