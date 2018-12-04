//
//  SMWebViewManager.h
//  SouMao
//
//  Created by william on 2017/8/30.
//  Copyright © 2017年 搜猫. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import <UIKit/UIKit.h>

@protocol SMJavaScriptBridgeModelDelegate <JSExport>

@optional
JSExportAs(openCamera, - (void)openCamera:(id )value);

JSExportAs(uploadImage, - (void)uploadImage:(id)value);

JSExportAs(showMessage, - (void)showMessage:(id)value);

JSExportAs(callHandler, - (void)callHandler:(id)value);

JSExportAs(uploadFile, - (void)uploadFile:(id)value);

@end

@interface SMWebViewManager : NSObject

//webView
@property (nonatomic,strong) UIWebView *webView;

@property (nonatomic,strong) JSContext *jsContent;

@property (nonatomic,weak) id<SMJavaScriptBridgeModelDelegate> delegate;

+ (instancetype)SharedCache;

@end
