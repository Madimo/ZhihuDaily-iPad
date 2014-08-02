//
//  ZHContentWebView.h
//  ZhihuDaily
//
//  Created by Madimo on 14-8-2.
//  Copyright (c) 2014 Madimo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZHContent;

@interface ZHContentWebView : UIWebView

- (void)render:(ZHContent *)content;

@end
