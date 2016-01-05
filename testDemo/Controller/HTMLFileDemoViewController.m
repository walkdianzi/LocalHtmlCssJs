//
//  HTMLFileDemoViewController.m
//  testDemo
//
//  Created by dasheng on 16/1/5.
//  Copyright © 2016年 dasheng. All rights reserved.
//

#import "HTMLFileDemoViewController.h"

@interface HTMLFileDemoViewController()<UIWebViewDelegate>

@end

@implementation HTMLFileDemoViewController

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    UIWebView   *web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height)];
    web.scalesPageToFit = YES;//自动对网页进行缩放以适应屏幕;
    web.dataDetectorTypes = UIDataDetectorTypeAll;//自动检测网页上的电话号码,网页链接,邮箱;
    web.delegate = self;
    [self.view addSubview:web];
    
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
