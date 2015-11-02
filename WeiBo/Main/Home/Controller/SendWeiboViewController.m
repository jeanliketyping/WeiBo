//
//  SendWeiboViewController.m
//  WeiBo
//
//  Created by mac on 15/10/19.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "SendWeiboViewController.h"
#import "ThemeManager.h"
#import "ThemeButton.h"
#import "ZoomImageView.h"
#import "MMDrawerController.h"
#import "DataService.h"
#import "AFHTTPRequestOperation.h"
#import <CoreLocation/CoreLocation.h>
#import "FaceScrollView.h"

@interface SendWeiboViewController ()<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITableViewDelegate,CLLocationManagerDelegate,FaceViewDelegate>
{
    //文本编辑栏
    UITextView *_textView;
    
    //工具栏
    UIView *_editorBar;
    
    //显示缩略图
    ZoomImageView *_zoomImageView;
    
    //位置管理
    CLLocationManager *_locationManager;
    UILabel *_locationLabel;
    
    UIImage *_sendImage;
    
    //表情管理
    FaceScrollView *_faceViewPanel;
    
    BOOL _isSelected;
}
@end

@implementation SendWeiboViewController

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    }
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //方法二
//    self.edgesForExtendedLayout = UIRectEdgeNone;

    self.navigationItem.title = @"发送微博";
    [self setNavi];
    [self createEditorView];
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    //弹出键盘
    [_textView becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //导航栏不透明 当导航栏不透明时 子视图的y的0位置在导航栏下面 （方法一）
    self.navigationController.navigationBar.translucent = NO;
    
    _textView.frame = CGRectMake(0, 0, kScreenWidth, 120);
    
    //弹出键盘
    [_textView becomeFirstResponder];
}



- (void)setNavi{
    
    //左侧的取消按钮
    ThemeButton *cancelButton = [[ThemeButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    cancelButton.normalButtonImage = @"button_icon_close.png";
    [cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    self.navigationItem.leftBarButtonItem = cancelItem;
    
    //右侧的点击发送按钮
    ThemeButton *sendButton = [[ThemeButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    sendButton.normalButtonImage = @"button_icon_ok.png";
    [sendButton addTarget:self action:@selector(sendWeiboAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *sendItem = [[UIBarButtonItem alloc] initWithCustomView:sendButton];
    self.navigationItem.rightBarButtonItem = sendItem;
}

- (void)createEditorView{

    //文本输入视图
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 120)];
    _textView.font = [UIFont systemFontOfSize:16.0f];
    _textView.editable = YES;
    
    _textView.backgroundColor = [UIColor lightGrayColor];
    //圆角边框
    _textView.layer.cornerRadius = 10;
    _textView.layer.borderWidth = 2;
    _textView.layer.borderColor = [UIColor blackColor].CGColor;
    
    [self.view addSubview:_textView];
    
    //编辑工具栏
    _editorBar = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 55)];
    _editorBar.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_editorBar];
    //创建多个编辑按钮
    NSArray *images = @[@"compose_toolbar_1.png",
                        @"compose_toolbar_4.png",
                        @"compose_toolbar_3.png",
                        @"compose_toolbar_5.png",
                        @"compose_toolbar_6.png"
                        ];
    for (int i = 0; i < images.count; i ++) {
        
        ThemeButton *button = [[ThemeButton alloc] initWithFrame:CGRectMake(15 + (kScreenWidth / 5)*i, 20, 40, 30)];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 10 + i;
        button.normalButtonImage = images[i];
        [_editorBar addSubview:button];
    }
    
    //创建label显示位置信息
    _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -30, kScreenWidth, 30)];
    _locationLabel.hidden = YES;
    _locationLabel.font = [UIFont systemFontOfSize:14];
    _locationLabel.backgroundColor = [UIColor grayColor];
    [_editorBar addSubview:_locationLabel];
    
    
}


- (void)buttonAction:(UIButton *)button{
    
    if (button.tag == 10) {
        //选择照片
        [self _selectPhoto];
    }else if (button.tag == 13){
        //显示位置
        [self _location];
    }else if (button.tag == 14){//显示、隐藏表情
        _isSelected = !_isSelected;
        if (_isSelected) {
            [_textView resignFirstResponder];
            [self _showFaceView];
        }else{
            [self _hideFaceView];
            [_textView becomeFirstResponder];
        }
        
    }
}

//关闭窗口
- (void)cancelAction:(UIButton *)button{
    NSLog( @"关闭");
    //键盘隐藏
    [_textView resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
//发送微博
- (void)sendWeiboAction:(UIButton *)button{
    NSLog( @"发送");
    NSString *text = _textView.text;
    NSString *error = nil;
    if (text.length == 0) {
        error = @"微内容为空";
    }else if (text.length > 140){
        error = @"微博内容大于140字符";
    }
    //弹出提示错误信息
    if (error != nil) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }

    AFHTTPRequestOperation *operation = [DataService sendWeibo:text image:_sendImage block:^(id result) {
        NSLog(@"%@",result);
        [self showStatusTip:@"发送成功" show:NO operation:nil];
    }];
    [self showStatusTip:@"正在发送" show:YES operation:operation];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 键盘弹出通知
- (void)keyBoardWillShow:(NSNotification *)notification{
    
    //1.取出键盘frame 这个frame 相对于window的
    NSValue *boundsValue = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect frame = [boundsValue CGRectValue];
    //2.键盘高度
    CGFloat height = frame.size.height;
    //调整视图的高度
    _editorBar.bottom = kScreenHeight - 64 - height;
    
}

#pragma mark - 选择照片
- (void)_selectPhoto{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
    
    [actionSheet showInView:self.view];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    UIImagePickerControllerSourceType sourceType;
    //选择相机 或者相册
    if (buttonIndex == 0) {//拍照
        
        sourceType = UIImagePickerControllerSourceTypeCamera;
        
        BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
        if (!isCamera) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"摄像头无法使用" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
    }else if (buttonIndex == 1){//选择相册
        
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }else{
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = sourceType;
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];
}


//照片选择代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    //弹出相册控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    //取出照片
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //显示缩略图
    
    if (_zoomImageView == nil) {
        _zoomImageView = [[ZoomImageView alloc] init];
        _zoomImageView.frame = CGRectMake(10, _textView.bottom + 10, 80, 80);
        [self.view addSubview:_zoomImageView];
    }
    
    _zoomImageView.image = image;
    _sendImage = image;
}



- (void)_location{
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
        
        //判断系统版本逆袭，如果大于8.0 则调用以下方法获取授权
        if (kVersion > 8.0) {
            [_locationManager requestAlwaysAuthorization];
        }
    }
    
    //设置定位精度
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    _locationManager.delegate = self;
    
    //开始定位
    [_locationManager startUpdatingLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    NSLog(@"已经更新位置信息");
    [_locationManager stopUpdatingLocation];
    
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D coordinate = location.coordinate;
    
    NSLog(@"经度：%lf 纬度：%lf",coordinate.longitude,coordinate.latitude);
    
    //地理位置反编码
    //一 新浪位置反编码 接口说明  http://open.weibo.com/wiki/2/location/geo/geo_to_address

    NSString *coordinateStr = [NSString stringWithFormat:@"%f,%f",coordinate.longitude,coordinate.latitude];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:coordinateStr forKey:@"coordinate"];
    
    __weak __typeof(self) weakSelf = self;
    [DataService requestAFUrl:geo_to_address httpMethod:@"GET" params:params data:nil block:^(id result) {
        NSArray *geos = [result objectForKey:@"geos"];
        if (geos.count > 0){
            NSDictionary *geoDic = [geos lastObject];
            
            NSString *addr = [geoDic objectForKey:@"address"];
            NSLog(@"地址 %@",addr);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong __typeof(self) strongSelf = weakSelf;
                strongSelf->_locationLabel.text = addr;
                strongSelf->_locationLabel.hidden = NO;
            });
        }
    }];

    
    
    //iOS内置
//    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
//    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
//        CLPlacemark *place = [placemarks lastObject];
//        NSLog(@"%@",place.name);
//    }];
}

#pragma mark - 表情处理
- (void)_showFaceView{
    
    //创建表情面板
    if (_faceViewPanel == nil) {
        _faceViewPanel = [[FaceScrollView alloc] init];
        [_faceViewPanel setFaceViewDelegate:self];
        //放到底部
        _faceViewPanel.top = kScreenHeight - 64;
        [self.view addSubview:_faceViewPanel];
    }
    
    //显示表情
    [UIView animateWithDuration:0.3 animations:^{
        _faceViewPanel.bottom = kScreenHeight - 64;
        //重新布局工具栏、输入框
        _editorBar.bottom = _faceViewPanel.top;
    }];
    
    
}

//隐藏表情
-(void)_hideFaceView{
    
    //隐藏表情
    [UIView animateWithDuration:0.3 animations:^{
        _faceViewPanel.top = kScreenHeight - 64;
    }];
}


- (void)faceDidSelect:(NSString *)text{
    NSLog(@"选中了%@",text);
    
    _textView.text = [NSString stringWithFormat:@"%@%@",_textView.text,text];
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
