//
//  ZHWebBrowserController.h
//  ZhihuDaily
//
//  Created by Madimo on 14-8-2.
//  Copyright (c) 2014 Madimo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHWebBrowserController : UIViewController

@property (strong, nonatomic) NSString *url;

- (instancetype)initWithURL:(NSString *)url;

@end
