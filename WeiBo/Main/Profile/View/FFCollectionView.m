//
//  FFCollectionView.m
//  WeiBo
//
//  Created by mac on 15/10/21.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "FFCollectionView.h"
#import "FFCell.h"
#import "UIImageView+WebCache.h"
#import "FollowerModel.h"

@implementation FFCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {

        self.dataSource = self;
        self.delegate = self;
        self.backgroundColor = [UIColor clearColor];
        //设置分页
        self.pagingEnabled = YES;
        //隐藏滑动条
        self.showsHorizontalScrollIndicator = NO;
        //注册一个类
        UINib *nib = [UINib nibWithNibName:@"FFCell" bundle:nil];
        [self registerNib:nib forCellWithReuseIdentifier:@"FFCell"];
        
    }
    return self;
}

- (void)setData:(NSArray *)data{
    
    if (_data != data) {
        _data = data;
        [self reloadData];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.data.count;
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FFCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FFCell" forIndexPath:indexPath];

    cell.backgroundColor = [UIColor whiteColor];
    FollowerModel *model = [[FollowerModel alloc] init];
    model = self.data[indexPath.row];
    
    
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.profile_image_url]];
    cell.nickNameLabel.text = model.name;
    cell.followerCountLabel.text = [NSString stringWithFormat:@"%@粉丝",model.followers_count];
    
    return cell;
}

@end
