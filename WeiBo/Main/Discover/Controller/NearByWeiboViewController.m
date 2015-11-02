//
//  NearByWeiboViewController.m
//  WeiBo
//
//  Created by mac on 15/10/20.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "NearByWeiboViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "WeiboAnnotation.h"
#import "WeiboAnnotationView.h"
#import "DataService.h"
#import "WeiboModel.h"
#import "WeiboDetailViewController.h"
/**
 *  1 定义(遵循MKAnnotation协议 )annotation类-->MODEL
 2 创建 annotation对象，并且把对象加到mapView;
 3 实现mapView 的协议方法 ,创建标注视图
 */

@interface NearByWeiboViewController ()<CLLocationManagerDelegate,MKMapViewDelegate>{
//    CLLocationManager *_locationManager;
    MKMapView *_mapView;
}

@end

@implementation NearByWeiboViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _createViews];
    
//    CLLocationCoordinate2D coordinate = {30.3066,120.3484};
//    
//    WeiboAnnotation *annotation = [[WeiboAnnotation alloc] init];
//    
//    annotation.coordinate = coordinate;
//    annotation.title = @"江干区";
//    annotation.subtitle = @"一所学校";
//    
//    [_mapView addAnnotation:annotation];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_createViews{
    
    _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    //显示用户位置
    _mapView.showsUserLocation = YES;
    //地图种类
    _mapView.mapType = MKMapTypeStandard;
    //用户跟踪模式
//    _mapView.userTrackingMode = MKUserTrackingModeFollow;
    
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    
}

#pragma mark - mapView代理
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    
    NSLog(@"选中");
    if (![view.annotation isKindOfClass:[WeiboAnnotation class]]) {
        return;
    }
    
    WeiboAnnotation *weiboAnnotation = (WeiboAnnotation *)view.annotation;
    WeiboModel *model = weiboAnnotation.model;
    
    WeiboDetailViewController *vc = [[WeiboDetailViewController alloc] init];
    vc.model = model;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    CLLocation *location = userLocation.location;
    CLLocationCoordinate2D coordinate = location.coordinate;
    
    NSLog(@"经度：%lf 纬度：%lf",coordinate.longitude,coordinate.latitude);
    
    NSString *longitude = [NSString stringWithFormat:@"%lf",coordinate.longitude];
    NSString *latitude = [NSString stringWithFormat:@"%lf",coordinate.latitude];
    [self _loadNearByData:longitude lat:latitude];

    //    typedef struct {
    //        CLLocationDegrees latitudeDelta;
    //        CLLocationDegrees longitudeDelta;
    //    } MKCoordinateSpan;
    //
    //    typedef struct {
    //        CLLocationCoordinate2D center;
    //        MKCoordinateSpan span;
    //    } MKCoordinateRegion;
    
    //设置地图的现实区域
    CLLocationCoordinate2D center = coordinate;
    //数值越小 精度越高
    MKCoordinateSpan span = {0.1,0.1};
    MKCoordinateRegion region = {center,span};
    
    mapView.region = region;

}

//标注视图
//- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
//    
//    //处理用户当前位置
//    if ([annotation isKindOfClass:[MKUserLocation class]]) {
//        return nil;
//    }
//    
//    //大头针
//    MKPinAnnotationView *pin = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"view"];
//    if (pin == nil) {
//        pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"view"];
//        //颜色
//        pin.pinColor = MKPinAnnotationColorPurple;
//        //从天而降
//        pin.animatesDrop = YES;
//        //设置显示标题
//        pin.canShowCallout = YES;
//        
//        pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeContactAdd];
//    }
//    return pin;
//}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }else if ([annotation isKindOfClass:[WeiboAnnotation class]]){
        
        WeiboAnnotationView *view = [mapView dequeueReusableAnnotationViewWithIdentifier:@"view"];
        if (view == nil) {
            view = [[WeiboAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"view"];
        }
        
        view.annotation = annotation;
        
        [view setNeedsLayout];
        
        return view;
    }
    return nil;
}


-(void)_loadNearByData:(NSString *)lon lat:(NSString *)lat{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:lon forKey:@"long"];
    [params setObject:lat forKey:@"lat"];
    
    [DataService requestAFUrl:nearby_timeline httpMethod:@"GET" params:params data:nil block:^(id result) {
        NSArray *statuses = [result objectForKey:@"statuses"];
        NSMutableArray *annotationArray = [[NSMutableArray alloc] initWithCapacity:statuses.count];
        for (NSDictionary *dic in statuses) {
            
            WeiboModel *model = [[WeiboModel alloc] initWithDataDic:dic];
            WeiboAnnotation *annotation = [[WeiboAnnotation alloc] init];
            annotation.model = model;
            
            [annotationArray addObject: annotation];
        }
        
        [_mapView addAnnotations:annotationArray];
    }];
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
