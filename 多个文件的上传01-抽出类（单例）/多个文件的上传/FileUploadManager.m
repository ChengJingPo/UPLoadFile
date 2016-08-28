

//
//  FileUploadManager.m
//  多个文件的上传
//
//  Created by mac on 16/8/27.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "FileUploadManager.h"

@implementation FileUploadManager
+(instancetype)sharedManager
{
    static id instance ;
    dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}
//多文件+文本信息
-(void)uploadFilesWithURLSting:(NSString*)URLString serverName:(NSString*)serverName filePaths:(NSArray*)filePaths textDict:(NSDictionary*)textDict{
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
//上传多文件的主方法，只有数组文件，没有附带文本信息
-(void)uploadFilesWithURLSting:(NSString*)URLString serverName:(NSString*)serverName filePaths:(NSArray*)filePaths
{
    [self uploadFilesWithURLSting:URLString serverName:serverName filePaths:filePaths textDict:nil];
}
//上传一个文件的主方法，还附带有文本信息
-(void)uploadFilesWithURLSting:(NSString*)URLString serverName:(NSString*)serverName filePath:(NSString*)filePath textDict:(NSDictionary*)textDict
{
    [self uploadFilesWithURLSting:URLString serverName:serverName filePaths:@[filePath] textDict:textDict];
}
//上传没有文件，只有文本信息的主方法
-(void)uploadFilesWithURLSting:(NSString*)URLString serverName:(NSString*)serverName  textDict:(NSDictionary*)textDict
{
    [self uploadFilesWithURLSting:URLString serverName:serverName filePaths:nil textDict:textDict];

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

@end
