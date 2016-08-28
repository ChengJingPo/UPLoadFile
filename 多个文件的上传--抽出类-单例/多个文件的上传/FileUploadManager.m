

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
-(void)uploadFilesWithURLSting:(NSString*)URLString serverName:(NSString*)serverName filePaths:(NSArray*)filePaths
{
    [self uploadFilesWithURLSting:URLString serverName:serverName filePaths:filePaths textDict:nil];
}
-(void)uploadFilesWithURLSting:(NSString*)URLString serverName:(NSString*)serverName filePath:(NSString*)filePath textDict:(NSDictionary*)textDict
{
    
}
@end
