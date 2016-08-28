//
//  ViewController.m
//  单个文件的上传
//
//  Created by mac on 16/8/27.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end
/*单个文件上的原理
 注意：文件上传的重点是，怎样把请求发送出去
 单个文件上传需要注意的2点
 1.Content-Typey （请求头里面的Content-Type）
   -1.请求头里面的Content-Type：是告诉服务器客户端想要做什么，是想做普通的请求还是文件上传
   boundary ：边界，分割线；是文件上传的分割线；可以自定义，必须是以非中文的字符组成；前面的4个中划线可以省略
 自定义boundary :boundary=ithm
 自定义boundary 之后的Content-Type:
 2.请求体
 第一行：文件上传时开始的分隔符，前面两个中划线不能省略（需要跟请求头里面的Content-Type保持一致）
 第二行：需要处理的表单数据
 name="userfile";前面的name是系统固定的，后面的'userfile'是服务器提供的，不能改；开发中跟后台要，作用是服务器接收文件的字段；客户端会规定不同的一些字段，表示传图片的作用
 filename="mm01.jpg" 前面的filename是系统规定的；后面的‘mm01.jpg’shi wenjina 保存到服务器的名字，可发中一般使用原始名字
 第三行：文件类型
 第四行：单纯的换行
 第五行：文件的二进制信息
 第六行：文件结束的分隔符
 2.处理请求体信息
 --ithm\r\n
 Content-Disposition: form-data; name="userfile"; filename="mm01.jpg"\r\n
 Content-Type: image/jpeg\r\n
 \r\n
 data\r\n
 --ithm--

 
 文件上传的步骤
 1.设置请求头里面的Content-Type
 2.拼接请求体里面的信息，发送出去
 
 *
 */
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //参数1 ：
    NSString *URLString = @"http://localhost/php/upload/upload.php";
    //参数2
    NSString *serverString = @"userfile";
    //参数3
    NSString *fielPath = [[NSBundle mainBundle]pathForResource:@"car.jpg" ofType:nil];
    //调用文件上传的主方法
    [self uploadFileWithURLString:URLString serverName:serverString filePath:fielPath];

}
/* 文件上传的主方法
  serverName 服务器接收文件的字段（开发时向后台要）
 filePath：文件的路径（可以获取文件的名字和文件的二进制信息）????都用什么方法？二进制可以转化为字符串：[[NSSting alloc]initWithData:];
 */
-(void)uploadFileWithURLString:(NSString*)URLString serverName:(NSString*)serverName filePath:(NSString*)filePath
{
    //URL
    NSURL *url = [NSURL URLWithString:URLString];
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod =@"POST";
    //设置请求头里面的Content-Type
    //[request setValue:@"multipart/from-data; boundary=ithm" forKey:@"Content-Type"];
    [request setValue:@"multipart/form-data; boundary=ithm"  forHTTPHeaderField:@"Content-Type"];
    
    NSData *fromData = [self getfromDataWithServerName:serverName filePath:filePath];
    //session发起和启动任务
//    [NSURLSession sharedSession]uploadTaskWithRequest:request fromFile: completionHandler://
    [[[NSURLSession sharedSession]uploadTaskWithRequest:request fromData:fromData completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil &&data !=nil) {
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"%@",result);
        }else {
            NSLog(@"%@",error);
        }
    }]resume];
    
}
-(NSData*)getfromDataWithServerName:(NSString*)serverName filePath:(NSString*)filePath
{
   //定义一个dataM ,专门拼接完整的亲球体信息（二进制）
    NSMutableData *dataM =[NSMutableData data];
    //定义可变的字符窜，拼接‘文件二进制’前面额字符窜信息
    NSMutableString *stringM = [NSMutableString string ];
    //拼接起始分隔符
    [stringM appendString:@"--ithm\r\n"];
    //拼接表单数据
    [stringM appendFormat:@"Content-Disposition: form-data; name=%@; filename=%@\r\n",serverName,[filePath lastPathComponent]];
    //拼接文件类型
    [stringM appendString:@"Content-Type: image/jpeg\r\n"];
    
    //拼接单纯的换行
    [stringM appendString:@"\r\n"];
    //把前面额信息转换为二进制
    [dataM appendData:[stringM dataUsingEncoding:NSUTF8StringEncoding]];
    //拼接文件的二进制信息
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    [dataM appendData:fileData];
    //拼接尾巴
    NSString *end = @"\r\n--ithm--";
    [dataM appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    return dataM.copy;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
