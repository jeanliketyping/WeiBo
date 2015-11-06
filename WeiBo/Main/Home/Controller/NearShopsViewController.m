//
//  NearShopsViewController.m
//  WeiBo
//
//  Created by mac on 15/10/20.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "NearShopsViewController.h"
#import "DataService.h"
#import "UIImageView+WebCache.h"

@interface NearShopsViewController ()

@end

@implementation NearShopsViewController

- (instancetype)init{
    self = [super init];
    if (self) {
        self.title = @"附近商圈";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //初始化自视图
    [self _initViews];
    
    //定位
    _locationManager = [[CLLocationManager alloc] init];
//    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
        
        //判断系统版本，如果大于8.0 则调用以下方法获取授权
        if (kVersion > 8.0) {
            [_locationManager requestAlwaysAuthorization];
        }
//    }
    
    //设置定位精度
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    _locationManager.delegate = self;
    
    //开始定位
    [_locationManager startUpdatingLocation];

}


//初始化子视图
- (void)_initViews{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
}


//开始加载网络
-(void)loadNearShopsByPoisWithlongitude:(NSString *)longitude latitude:(NSString *)latitude{
    //01配置参数
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:latitude  forKey:@"lat"];//纬度
    [params setObject:longitude forKey:@"long"];//经度
    [params setObject:@50 forKey:@"count"];//最大请求数量
    //获取附近商家
    __weak __typeof(self) weakSelf = self;
    [DataService requestAFUrl:nearby_pois httpMethod:@"GET" params:params data:nil block:^(id result) {
        NSArray *pois = [result objectForKey:@"pois"];
        NSMutableArray *dataList = [NSMutableArray array];
        for (NSDictionary *dic in pois) {
            //创建商业圈模型对象
            PoiModel *poi = [[PoiModel alloc] initWithDataDic:dic];
            [dataList addObject:poi];
        }
        __strong __typeof(self) strongSelf = weakSelf;
        strongSelf.dataList = dataList;
        [strongSelf->_tableView reloadData];
    }];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    //停止定位
    [_locationManager stopUpdatingLocation];
    CLLocation *location = [locations lastObject];
    //获取附近商圈
    NSString *latitude = [NSString stringWithFormat:@"%lf",location.coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%lf",location.coordinate.longitude];
    //开始加载数据
    [self loadNearShopsByPoisWithlongitude:longitude latitude:latitude];
}

#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *locCellId = @"locCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:locCellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:locCellId];
    }
    //获取当前单元格所对应的商圈对象
    PoiModel *poi = self.dataList[indexPath.row];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:poi.icon] placeholderImage:[UIImage imageNamed:@"icon"]];
    cell.textLabel.text = poi.title;
    return cell;
}

- (void)backAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
