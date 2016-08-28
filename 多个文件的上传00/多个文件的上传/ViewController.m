//
//  ViewController.m
//  多个文件的上传
//
//  Created by mac on 16/8/27.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ViewController.h"

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
    // Do any additional setup after loading the view, typically from a nib.
    //http://localhost/php/upload/upload-m.php
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
//    [NSBundle mainBundle]pathForResource:<#(nullable NSString *)#> ofType:<#(nullable NSString *)#>
    NSString *filePath02 = [[NSBundle mainBundle]pathForResource:@"dog.jpg" ofType:nil];
    NSArray *filePaths =@[filePath01,filePath02];
    NSDictionary *textDict = [NSDictionary dictionaryWithObject:@"jigjeig在一起了!好开心" forKey:@"status"];
    [self uploadFilesWithURLSting:URLString serverName:serverName filePaths:filePaths textDict:textDict];
}
//文件上传的主方法
-(void)uploadFilesWithURLSting:(NSString*)URLString serverName:(NSString*)serverName filePaths:(NSArray*)filePaths textDict:(NSDictionary*)textDict
{
    NSURL *url = [NSURL URLWithString:URLString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    //[request setValue:@" " forKey:@" "];
    [request setValue:@"multipart/form-data; boundary=ithm" forHTTPHeaderField:@"Content-Type"];
    NSData *fromData =[self getfromDataWithServerName:serverName filePaths:filePaths textDict:textDict];
    [[[NSURLSession sharedSession]uploadTaskWithRequest:request fromData:fromData completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil &&data != nil) {
            NSArray *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"%@",result);
        }else {
            NSLog(@"%@",error);
        }
    }]resume];
}
//获取fromData
-(NSData*)getfromDataWithServerName:(NSString*)serverName filePaths:(NSArray*)filePaths textDict:(NSDictionary*)textDict
{
    NSMutableData *dataM = [NSMutableData data];
    //循环拼接
    [filePaths enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //定义可变字符串，拼接
        NSMutableString *stringM = [NSMutableString string ];
        //开始拼接开始分隔符
        [stringM appendString:@"--ithm\r\n"];
        //拼接表单数据
//        [stringM appendFormat:@"Content-Disposition: form-data; name=%@; filename=%@\r\n",serverName,[obj lastObject]];
        [stringM appendFormat:@"Content-Disposition: form-data; name=%@; filename=%@\r\n",serverName,[obj lastPathComponent]];
        //拼接文件类型
        [stringM appendString:@"Content-Type: image/jpeg\r\n"];
        //拼接单纯的换行
        [stringM appendString:@"\r\n"];
        //把以上的内容拼接进请求体
        [dataM appendData:[stringM dataUsingEncoding:NSUTF8StringEncoding]];
        //拼接文件的
       // NSData *fileData = [NSData dataWithContentsOfFile:obj];
        NSData *fileData = [NSData dataWithContentsOfFile:obj];
        [dataM appendData:fileData];
        //拼接尾巴
        [dataM appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    //上传文件时的附带的文本信息
    [textDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        //定义容器
        NSMutableString *stringM = [NSMutableString string ];
        [stringM appendString:@"--ithm\r\n"];
        //拼接表单数据
        [stringM appendFormat:@"Content-Disposition: form-data; name=%@\r\n",key];
        //拼接单纯的换行
        [stringM appendString:@"\r\n"];
        //拼接附带的文本信息
        [stringM appendFormat:@"%@\r\n",obj ];
        //把附带的文本信息的二进制拼接进请求体dataM
        
        [dataM appendData:[stringM dataUsingEncoding:NSUTF8StringEncoding]];
        
    }];
    //最后拼接尾巴
    [dataM appendData:[@"--ithm--" dataUsingEncoding:NSUTF8StringEncoding]];
    return dataM.copy;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
