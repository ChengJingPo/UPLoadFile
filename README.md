# UPLoadFile
文件上传，多文件上传，多文件（抽出一个管理类--管理上传）
(1)此管理类（FileUploadManager）提供4个接口：
*  @param URLString  文件上传的地址
 *  @param serverName 服务器接收文件的字段名
 *  @param filePaths  文件的路径集合
 *  @param textDict   上传的文本信息
 
(2)“多个文件的上传02-抽出类（单例）-完善”这个项目中的管理类（FileUploadManager ）包含了文件上传的4种情况：
 a.多个文件 + 文本信息 :-(void)uploadFilesWithURLSting:(NSString*)URLString serverName:(NSString*)serverName filePaths:(NSArray*)filePaths textDict:(NSDictionary*)textDict;
 b.单个文件 + 文本信息 :-(void)uploadFilesWithURLSting:(NSString*)URLString serverName:(NSString*)serverName filePath:(NSString*)filePath textDict:(NSDictionary*)textDict;
 c.多个文件（ 也可是 单个文件）:-(void)uploadFilesWithURLSting:(NSString*)URLString serverName:(NSString*)serverName filePaths:(NSArray*)filePaths;
 
 d.文本信息:   -(void)uploadFilesWithURLSting:(NSString*)URLString serverName:(NSString*)serverName  textDict:(NSDictionary*)textDict;
 
 
 
 
 可以根据需求，调用相应对象的方法
 以上4种情况都是以a为基础的，b,c,d中，每个.m文件中都有a 的方法，在实际应用中根据需求，调用相应的方法，
 （单文件+文本上传 ，文本信息上传 作为例子）
 
