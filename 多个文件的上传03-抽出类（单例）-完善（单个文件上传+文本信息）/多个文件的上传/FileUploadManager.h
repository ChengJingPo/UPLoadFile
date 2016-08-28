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

//上传一个文件的主方法，还附带有文本信息
/**
 *  上传多文件的主方法 : 单个文件+文本信息
 *
 *  @param URLString  文件上传的地址
 *  @param serverName 服务器接收文件的字段名
 *  @param filePath   单个文件的路径
 *  @param textDict   上传的文本信息
 */

-(void)uploadFilesWithURLSting:(NSString*)URLString serverName:(NSString*)serverName filePath:(NSString*)filePath textDict:(NSDictionary*)textDict;

@end
