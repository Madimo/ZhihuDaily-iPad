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
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ContentHTML" ofType:@"html"];
    self.contentHTML = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
}

- (void)render:(ZHContent *)content
{
    NSMutableString *HTML = [self.contentHTML mutableCopy];
    
    // replace css
    
    NSMutableString *cssString;

    if (content.css.count) {
        cssString = [NSMutableString new];
        for (NSString *url in content.css) {
            static NSString *linkString = @"<link rel=\"stylesheet\" type=\"text/css\" href=\"%@\" />\n";
            [cssString appendFormat:linkString, url];
        }
    }
    
    [HTML replaceOccurrencesOfString:@"{{ stylesheet }}"
                          withString:cssString ? cssString : @" "
                             options:NSLiteralSearch
                               range:NSMakeRange(0, HTML.length)];
    
    // replace javascript
    
    NSMutableString *jsString;
    
    if (content.js.count) {
        jsString = [NSMutableString new];
        for (NSString *url in content.js) {
            static NSString *linkString = @"<script type=\"text/javascript\" src=\"%@\"></script>\n";
            [jsString appendFormat:linkString, url];
        }
    }
    
    [HTML replaceOccurrencesOfString:@"{{ javascript }}"
                          withString:jsString ? jsString : @" "
                             options:NSLiteralSearch
                               range:NSMakeRange(0, HTML.length)];
    
    // replace body
    
    [HTML replaceOccurrencesOfString:@"{{ body }}"
                          withString:content.body
                             options:NSLiteralSearch
                               range:NSMakeRange(0, HTML.length)];
    
    // load
    
    NSURL *baseUrl = [NSURL URLWithString:content.shareUrl];
    [self loadHTMLString:HTML baseURL:baseUrl];
}

@end
