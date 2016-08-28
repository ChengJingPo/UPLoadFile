//
//  FileUploadManager.h
//  多个文件的上传
//
//  Created by mac on 16/8/27.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileUploadManager : NSObject
+(instancetype)sharedManager;
//文件上传的主方法 既有有数组文件及附带文本信息
-(void)uploadFilesWithURLSting:(NSString*)URLString serverName:(NSString*)serverName filePaths:(NSArray*)filePaths textDict:(NSDictionary*)textDict;
//上传多文件的主方法，只有数组文件，没有附带文本信息
-(void)uploadFilesWithURLSting:(NSString*)URLString serverName:(NSString*)serverName filePaths:(NSArray*)filePaths;
//上传一个文件的主方法，还附带有文本信息
-(void)uploadFilesWithURLSting:(NSString*)URLString serverName:(NSString*)serverName filePath:(NSString*)filePath textDict:(NSDictionary*)textDict;
//上传没有文件，只有文本信息的主方法
-(void)uploadFilesWithURLSting:(NSString*)URLString serverName:(NSString*)serverName  textDict:(NSDictionary*)textDict;

@end
