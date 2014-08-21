//
//  ZHContentWebView.m
//  ZhihuDaily
//
//  Created by Madimo on 14-8-2.
//  Copyright (c) 2014 Madimo. All rights reserved.
//

#import "ZHContentWebView.h"
#import "ZHContent.h"

@interface ZHContentWebView ()
@property (strong, nonatomic) NSString *contentHTML;
@property (strong, nonatomic) NSString *contentStyle;
@property (strong, nonatomic) NSString *contentScript;
@end

@implementation ZHContentWebView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{    
    NSString *path;
    
    path = [[NSBundle mainBundle] pathForResource:@"ContentHTML" ofType:@"html"];
    self.contentHTML = [NSString stringWithContentsOfFile:path
                                                 encoding:NSUTF8StringEncoding
                                                    error:nil];
    
    path = [[NSBundle mainBundle] pathForResource:@"ContentStyle" ofType:@"css"];
    self.contentStyle = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:nil];
    
    path = [[NSBundle mainBundle] pathForResource:@"ContentScript" ofType:@"js"];
    self.contentScript = [NSString stringWithContentsOfFile:path
                                                   encoding:NSUTF8StringEncoding
                                                      error:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(themeChanged:)
                                                 name:kThemeChangedNotification
                                               object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)themeChanged:(NSNotification *)notification
{
    NSString *script = nightMode ? @"set_night_mode(true);" : @"set_night_mode(false);";
    [self stringByEvaluatingJavaScriptFromString:script];
}

- (void)render:(ZHContent *)content
{
    NSMutableString *HTML = [self.contentHTML mutableCopy];
    
    // replace css
    [HTML replaceOccurrencesOfString:@"{{ stylesheet }}"
                          withString:self.contentStyle
                             options:NSLiteralSearch
                               range:NSMakeRange(0, HTML.length)];
    
    // replace javascript
    [HTML replaceOccurrencesOfString:@"{{ javascript }}"
                          withString:self.contentScript
                             options:NSLiteralSearch
                               range:NSMakeRange(0, HTML.length)];
    
    // replace body_class
    NSString *classString = nightMode ? @"class=\"night\"" : @" ";
    [HTML replaceOccurrencesOfString:@"{{ body_class }}"
                          withString:classString
                             options:NSLiteralSearch
                               range:NSMakeRange(0, HTML.length)];
    
    // replace body
    [HTML replaceOccurrencesOfString:@"{{ body }}"
                          withString:content.body
                             options:NSLiteralSearch
                               range:NSMakeRange(0, HTML.length)];
    
    // load
    [self loadHTMLString:HTML baseURL:[NSBundle mainBundle].resourceURL];
}

@end
