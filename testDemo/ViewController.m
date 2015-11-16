//
//  ViewController.m
//  testDemo
//
//  Created by YMY on 15/11/16.
//  Copyright © 2015年 dasheng. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIWebViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIWebView   *web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height)];
    web.scalesPageToFit = YES;//自动对网页进行缩放以适应屏幕;
    web.dataDetectorTypes = UIDataDetectorTypeAll;//自动检测网页上的电话号码,网页链接,邮箱;
    web.delegate = self;
    [self.view addSubview:web];
    
    //NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.baidu.com"]];
    //[web loadRequest:request];
    
    
    /*html字符串
    NSString *_htmlStr = @"<!DOCTYPE html><html><head lang=\"zh\"><meta charset=\"UTF-8\"><title>第一个HTML</title><link rel=\"stylesheet\" type=\"text/css\" href=\"index.css\"><script type=\"text/javascript\" src=\"index.js\"></script></head><body><h1>我是HTML</h1><p id = \"p\">p标签</p><img id = \"img\" src = \"2.pic_hd.jpg\" alt = \"百度LOGO\"><br/><a id = \"a\" href=\"http://baidu.com\">我要到百度</a><br/><br/><br/><button onclick = \"hello()\">点击我弹出hello</button></body></html>";
    NSLog(@"%@",[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath] isDirectory: YES]);
    [web loadHTMLString:_htmlStr baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath] isDirectory: YES]];
    */
    
    //本地html
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"index"
                                                          ofType:@"html"];
    NSString * htmlCont = [NSString stringWithContentsOfFile:htmlPath
                                                    encoding:NSUTF8StringEncoding
                                                       error:nil];
    [web loadHTMLString:htmlCont baseURL:baseURL];
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
