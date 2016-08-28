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
 
 */
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //参数1
    NSString *URLString = @"";
    //参数2
    NSString *serverName =@"";
    //参数3
    NSString *filePath01 = @" ";
//    [NSBundle mainBundle]pathForResource:<#(nullable NSString *)#> ofType:<#(nullable NSString *)#>
    NSString *filePath02 = @" ";
    NSArray *filePaths =@[filePath01,filePath02];
    NSDictionary *textDict = [NSDictionary dictionaryWithObject:@"jigjeig" forKey:@"status"];
//    [self uploadFilesWithURLSting:URLString serverName:serverName filePaths:filePaths textDict:textDict];
    
    [[FileUploadManager sharedManager]uploadFilesWithURLSting:URLString serverName:serverName filePaths:filePaths ];
    [[FileUploadManager sharedManager]uploadFilesWithURLSting:URLString serverName:serverName filePaths:filePaths textDict:textDict];
}
//文件上传的主方法
-(void)uploadFilesWithURLSting:(NSString*)URLString serverName:(NSString*)serverName filePaths:(NSArray*)filePaths textDict:(NSDictionary*)textDict
{
    NSURL *url = [NSURL URLWithString:URLString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@" " forKey:@" "];
    NSData *fromData =[self getfromDataWithServerName:serverName filePaths:filePaths textDict:textDict];
    [[NSURLSession sharedSession]uploadTaskWithRequest:request fromData:fromData completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil &&data != nil) {
            NSArray *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"%@",result);
        }else {
            NSLog(@"%@",error);
        }
    }];
}
-(NSData*)getfromDataWithServerName:(NSString*)serverName filePaths:(NSArray*)filePaths textDict:(NSDictionary*)textDict
{
    NSMutableData *dataM = [NSMutableData data];
    //循环拼接
    [filePaths enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //定义可变字符串，拼接
        NSMutableString *stringM = [NSMutableString string ];
        //开始拼接开始分隔符
        [stringM appendString:@""];
        //拼接表单数据
        [stringM appendFormat:@" "];
        [stringM appendString:@""];
        //拼接单纯的换行
        [stringM appendString:@""];
        //把以上的内容拼接进请求体
        [dataM appendData:[stringM dataUsingEncoding:NSUTF8StringEncoding]];
        //拼接文件的
        //NSData *fileData = [obj lastPathComponent];
        NSData *fileData = [NSData dataWithContentsOfURL:obj];
        [dataM appendData:fileData];
        //拼接尾巴
        [dataM appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    //上传文件时的附带的文本信息
    [textDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        //定义容器
        NSMutableString *stringM = [NSMutableString string ];
        [stringM appendString:@" "];
        //拼接表单数据
        [stringM appendFormat:@""];
        //
        [stringM appendString:@""];
        [stringM appendFormat:@"%@\r\n",obj ];
        [dataM appendData:[stringM dataUsingEncoding:NSUTF8StringEncoding]];
        
    }];
    //拼接
    [dataM appendData:[@"--ithm\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    return dataM.copy;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
