//
//  ZHDetailViewController.m
//  ZhihuDaily
//
//  Created by Madimo on 14-8-2.
//  Copyright (c) 2014 Madimo. All rights reserved.
//

#import "ZHDetailViewController.h"
#import "ZHContentWebView.h"
#import "ZHClient.h"

@interface ZHDetailViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet ZHContentWebView *webview;
@property (strong, nonatomic) ZHContent *content;
@end

@implementation ZHDetailViewController

- (void)setStory:(ZHStory *)story
{
    if (_story != story) {
        _story = story;
        [self refresh];
    }
}

- (void)refresh
{
    ZHClient *client = [ZHClient client];
    [client getContentWithStoryId:self.story.storyId
                          success:^(ZHContent *content) {
                              self.content = content;
                              [self.webview render:content];
                          }
                          failure:^(NSError *error) {
                              
                          }];
}

@end
