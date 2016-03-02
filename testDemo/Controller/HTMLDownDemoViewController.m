//
//  HTMLDownDemoViewController.m
//  testDemo
//
//  Created by dasheng on 16/1/5.
//  Copyright © 2016年 dasheng. All rights reserved.
//

#import "HTMLDownDemoViewController.h"
#import "ZipArchive.h"

@interface HTMLDownDemoViewController()<UIWebViewDelegate>{
    
    UIWebView  *_web;
}

@end

@implementation HTMLDownDemoViewController

-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    _web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height)];
    _web.scalesPageToFit = YES;//自动对网页进行缩放以适应屏幕;
    _web.dataDetectorTypes = UIDataDetectorTypeAll;//自动检测网页上的电话号码,网页链接,邮箱;
    _web.delegate = self;
    [self.view addSubview:_web];
    
    
    /*这里是测试用的，为了看的清晰点，所以第一次打开还没下载好的时候页面是没显示的。
     （传上去的是个js,css,html的压缩文件）
     */
    
    [self DownloadTextFile:@"http://7xj2go.com2.z0.glb.qiniucdn.com/www.zip" fileName:@"www.zip"];
}


-(void)DownloadTextFile:(NSString*)fileUrl   fileName:(NSString*)_fileName{
    
    
    dispatch_queue_t queue = dispatch_get_global_queue(
                                                       DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    __weak __typeof(self)weakSelf = self;
    dispatch_async(queue, ^{
        
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        NSURL *url = [NSURL URLWithString:fileUrl];
        NSError *error = nil;
        // 2
        NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
        
        if(!error)
        {
            /*得到要保存zip的路径*/
            NSString *sandboxPath = NSHomeDirectory();
            NSString *path = [sandboxPath  stringByAppendingPathComponent:@"Library/Caches"];//将Documents
            NSString *zipPath = [path stringByAppendingPathComponent:_fileName];
            
            
            /*把zip文件放入路径中*/
            [data writeToFile:zipPath options:0 error:&error];
            
            if(!error)
            {
                //解压zip文件
                ZipArchive* zip = [[ZipArchive alloc] init];
                if( [zip UnzipOpenFile:zipPath] )  //解压文件成功
                {
                    //把解压的文件放入对应的路径中
                    BOOL ret = [zip UnzipFileTo:path overWrite:YES];
                    if( NO==ret )
                    {
                        NSLog(@"error");
                    }
                    [zip UnzipCloseFile];
                    
                    //下载完成后加载页面（可以根据实际业务来，下载成功一次之后弄个标记，以后就不用再下载了，直接执行下面这句代码）
                    [strongSelf loadWebView];
                }
            }
            else
            {
                NSLog(@"Error saving file %@",error);
            }
        }
        else
        {
            NSLog(@"Error downloading zip file: %@", error);
        }
    });
}

- (void)loadWebView{
    
    //得到zip存储位置
    NSString *sandboxPath = NSHomeDirectory();
    NSString *path = [sandboxPath  stringByAppendingPathComponent:@"Library/Caches"];//将Documents
    
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSString *indexPath = [path stringByAppendingPathComponent:@"index.html"];
    
    NSString * htmlCont = [NSString stringWithContentsOfFile:indexPath
                                                    encoding:NSUTF8StringEncoding
                                                       error:nil];
    [_web loadHTMLString:htmlCont baseURL:baseURL];
}


#pragma mark - UIWebViewDelegate
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"开始加载网页");
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"加载网页完成");
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType //这个方法是网页中的每一个请求都会被触发的
{
    
    NSURL* url = [request URL];
    NSString* urlstring = [NSString stringWithFormat:@"%@",url];
    NSLog(@"url = >%@",url);
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
