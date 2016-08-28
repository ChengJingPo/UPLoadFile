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
//文件上传的主方法
-(void)uploadFilesWithURLSting:(NSString*)URLString serverName:(NSString*)serverName filePaths:(NSArray*)filePaths textDict:(NSDictionary*)textDict;
//上传多文件的主方法
-(void)uploadFilesWithURLSting:(NSString*)URLString serverName:(NSString*)serverName filePaths:(NSArray*)filePaths;
//
-(void)uploadFilesWithURLSting:(NSString*)URLString serverName:(NSString*)serverName filePath:(NSString*)filePath textDict:(NSDictionary*)textDict;

@end
