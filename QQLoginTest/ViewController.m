//
//  ViewController.m
//  QQLoginTest
//
//  Created by 刘杰 on 2017/6/26.
//  Copyright © 2017年 LJ. All rights reserved.
//

#import "ViewController.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>

@interface ViewController ()<TencentSessionDelegate>

@property (nonatomic, strong) TencentOAuth *oauth;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    创建Button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 100, 100, 40);
    [button setTitle:@"login" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.layer.borderWidth = 1;
    [button addTarget:self action:@selector(QQLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *qqShareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    qqShareButton.frame = CGRectMake(100, 180, 100, 40);
    [qqShareButton setTitle:@"好友分享" forState:UIControlStateNormal];
    [qqShareButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    qqShareButton.layer.borderWidth = 1;
    [qqShareButton addTarget:self action:@selector(QQShare:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:qqShareButton];
    
    UIButton *qzShareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    qzShareButton.frame = CGRectMake(100, 270, 100, 40);
    [qzShareButton setTitle:@"空间分享" forState:UIControlStateNormal];
    [qzShareButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    qzShareButton.layer.borderWidth = 1;
    [qzShareButton addTarget:self action:@selector(QZShare:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:qzShareButton];
}

- (void)QQLogin:(UIButton *)sender {
    _oauth = [[TencentOAuth alloc] initWithAppId:@"1106248070" andDelegate:self];
    NSArray *permissions = @[kOPEN_PERMISSION_GET_SIMPLE_USER_INFO, kOPEN_PERMISSION_ADD_SHARE, kOPEN_PERMISSION_GET_INFO, kOPEN_PERMISSION_GET_USER_INFO];
    [_oauth authorize:permissions];
}


/**
 分享App

 @param sender button
 */
- (void)QQShare:(UIButton *)sender {
    _oauth = [[TencentOAuth alloc] initWithAppId:@"1106248070" andDelegate:self];
    QQApiURLObject *urlObject = [QQApiURLObject objectWithURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/id1223932262?mt=8"] title:@"团组发票管理" description:@"很好用的哟我开发的哟哈哈哈哈" previewImageData:UIImageJPEGRepresentation([UIImage imageNamed:@"test"], 1) targetContentType:QQApiURLTargetTypeNews];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:urlObject];
    [QQApiInterface sendReq:req];
}


/**
 分享新闻

 @param sender button
 */
- (void)QZShare:(UIButton *)sender {
    _oauth = [[TencentOAuth alloc] initWithAppId:@"1106248070" andDelegate:self];
    NSString *utf8String = @"http://www.163.com";
    NSString *title = @"新闻标题";
    NSString *description = @"新闻描述";
    NSString *previewImageUrl = @"http://cdni.wired.co.uk/620x413/k_n/NewsForecast%20copy_620x413.jpg";
    QQApiNewsObject *newsObj = [QQApiNewsObject
                                objectWithURL:[NSURL URLWithString:utf8String]
                                title:title
                                description:description
                                previewImageURL:[NSURL URLWithString:previewImageUrl]];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    //将内容分享到qzone
    [QQApiInterface SendReqToQZone:req];
}


/**
 登录成功
 */
- (void)tencentDidLogin {
    NSLog(@"%@",_oauth.accessToken);
    [_oauth getUserInfo];
}

- (void)tencentDidNotLogin:(BOOL)cancelled {
    NSLog(@"登录失败");
}

- (void)tencentDidNotNetWork {
    NSLog(@"网络问题,没网了吧 哈哈哈哈哈");
}

- (void)getUserInfoResponse:(APIResponse *)response {
    NSLog(@"userInfo： response %@",response.jsonResponse);
}

/**
 * 分享到QZone回调
 * \param response API返回结果，具体定义参见sdkdef.h文件中\ref APIResponse
 * \remarks 正确返回示例: \snippet example/addShareResponse.exp success
 *          错误返回示例: \snippet example/addShareResponse.exp fail
 */
- (void)addShareResponse:(APIResponse*) response {
    NSLog(@"%@",response);
}

@end
