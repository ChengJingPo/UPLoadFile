//
//  ViewController.m
//  多个文件的上传
//
//  Created by mac on 16/8/27.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ViewController.h"
#import "FileUploadManager.h"
@interface ViewController ()

@end
/*
 多个文件的上传原理
 多个文件上传需要注意的问题
 处理原始的请求信息
 --ithm\r\n
 Content-Disposition: form-data; name="userfile[]"; filename="dog.jpg"\r\n
 Content-Type: image/jpeg\r\n
 \r\n
 data\r\n
 --ithm\r\n
 Content-Disposition: form-data; name="userfile[]"; filename="car.jpg"\r\n
 Content-Type: image/jpeg\r\n
 \r\n
 data\r\n
 --ithm\r\n
 Content-Disposition: form-data; name="status"\r\n
 \r\n
 今天和宝宝的女神在一起了!好开心!\r\n
 --ithm--

 */
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //参数1
   // NSString *URLString = @"http://127.0.0.1/php/upload/upload-m.html";
    NSString *URLString = @"http://localhost/php/upload/upload-m.php";
    //参数2
    NSString *serverName =@"userfile[]";
    //参数3
    NSString *filePath01 = [[NSBundle mainBundle]pathForResource:@"car.jpg" ofType:nil];
    //只有一个文件上传，没有附带文本
    [[FileUploadManager sharedManager]uploadFilesWithURLSting:URLString serverName:serverName filePath:filePath01 textDict:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
