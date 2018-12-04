//
//  SMWebViewManager.m
//  SouMao
//
//  Created by william on 2017/8/30.
//  Copyright © 2017年 搜猫. All rights reserved.
//

#import "SMWebViewManager.h"

@interface SMWebViewManager()<UIWebViewDelegate>

@end

@implementation SMWebViewManager

+ (instancetype)SharedCache{
    
    static SMWebViewManager *webMg = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        webMg = [[self alloc] init];
    });
    return webMg;
}


- (UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
        _webView.delegate = self;
    }
    return _webView;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    if (!self.jsContent) {
        self.jsContent = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    }
    [self.jsContent setObject:self.delegate forKeyedSubscript:@"WebViewJavascriptBridge"];
    
}




@end
