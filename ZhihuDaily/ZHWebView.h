//
//  ZHWebView.h
//  ZhihuDaily
//
//  Created by Madimo on 14-8-2.
//  Copyright (c) 2014 Madimo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZHWebView;

@protocol ZHWebViewProgressDelegate <NSObject>
@optional
- (void)webView:(ZHWebView *)webView didReceiveResourceNumber:(NSInteger)resourceNumber totalResources:(NSInteger)totalResources;
@end

@interface ZHWebView : UIWebView

@property (nonatomic, weak) id<ZHWebViewProgressDelegate> progressDelegate;

@property (nonatomic) NSInteger resourceCount;
@property (nonatomic) NSInteger resourceCompletedCount;

@end
