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

@interface ZHDetailViewController () <UISplitViewControllerDelegate, UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet ZHContentWebView *webview;
@property (strong, nonatomic) ZHContent *content;
@end

@implementation ZHDetailViewController

- (void)awakeFromNib
{
    self.splitViewController.delegate = self;
}

- (void)setStory:(ZHStory *)story
{
    if (_story != story) {
        _story = story;
        self.title = story.title;
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

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url = request.URL.absoluteString;
    
    if ([url isEqualToString:@"about:blank"]) {
        return YES;
    }
    
    return NO;
}

#pragma mark - UISplitViewControllerDelegate

- (BOOL)splitViewController:(UISplitViewController *)svc
   shouldHideViewController:(UIViewController *)vc
              inOrientation:(UIInterfaceOrientation)orientation
{
    return UIInterfaceOrientationIsPortrait(orientation);
}

- (void)splitViewController:(UISplitViewController *)svc
     willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{

}

- (void)splitViewController:(UISplitViewController *)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)pc
{

}

@end
