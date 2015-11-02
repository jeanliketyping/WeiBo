//
//  FollowerModel.h
//  WeiBo
//
//  Created by mac on 15/10/21.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

/*
 "id": 321205008,
 "idstr": "321205008",
 "screen_name": "江湖社***",
 "name": "江湖社***,
 "province": "41",
 "city": "1",
 "location": "河南 郑州",
 "description": "描述。。。",
 "url": "http://www.weibo.com",
 "profile_image_url": "http://tp2.sinaimg.cn/321205008/50/5652109562/1",
 "profile_url": "523438876",
 "domain": "laijianghu",
 "weihao": "523438876",
 "gender": "m",
 "followers_count": 270,
 "friends_count": 364,
 "statuses_count": 23,
 "favourites_count": 0,
 "created_at": "Wed Jan 02 23:56:03 +0800 2013",
 "following": false,
 "allow_all_act_msg": true,
 "geo_enabled": true,
 "verified": false,
 "verified_type": -1,
 "remark": "",
 "status_id": 3532859991713507,
 "allow_all_comment": true,
 "avatar_large": "http://tp2.sinaimg.cn/3212050081/180/5652109562/1",
 "verified_reason": "",
 "follow_me": false,
 "online_status": 0,
 "bi_followers_count": 204,
 "lang": "zh-cn",
 "star": 0,
 "mbtype": 0,
 "mbrank": 0,
 "block_word": 0
 */


#import <Foundation/Foundation.h>

@interface FollowerModel : NSObject

@property (nonatomic,copy)NSString *profile_image_url;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSNumber *followers_count;


@end
