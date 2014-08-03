//
//  ZHDetailViewController.m
//  ZhihuDaily
//
//  Created by Madimo on 14-8-2.
//  Copyright (c) 2014 Madimo. All rights reserved.
//

#import "ZHDetailViewController.h"
#import "ZHWebBrowserController.h"
#import "ZHContentWebView.h"
#import "ZHClient.h"

@interface ZHDetailViewController () <UISplitViewControllerDelegate, UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet ZHContentWebView *webview;
@property (weak, nonatomic) IBOutlet UIView *loadingMaskView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *actionButton;
@property (strong, nonatomic) NSURLSessionDataTask *task;
@property (strong, nonatomic) ZHContent *content;
@end

@implementation ZHDetailViewController

- (void)awakeFromNib
{
    self.splitViewController.delegate = self;
    [self.view bringSubviewToFront:self.loadingMaskView];
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
    self.loadingMaskView.hidden = NO;
    
    [self.task cancel];
    self.actionButton.enabled = NO;
    
    ZHClient *client = [ZHClient client];
    self.task = [client getContentWithStoryId:self.story.storyId
                                      success:^(ZHContent *content) {
                                          self.content = content;
                                          [self.webview render:content];
                                          self.actionButton.enabled = YES;
                                          self.loadingMaskView.hidden = YES;
                                      }
                                      failure:^(NSError *error) {
                                          self.loadingMaskView.hidden = YES;
                                      }];
}

- (IBAction)openAction:(id)sender
{
    NSArray *activityItems = @[[NSString stringWithFormat:@"%@ （分享自 @知乎日报）", self.content.title],
                               [NSURL URLWithString:self.content.shareUrl]];
    UIActivityViewController *avc = [[UIActivityViewController alloc] initWithActivityItems:activityItems
                                                                      applicationActivities:nil];
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:avc];
    [popover presentPopoverFromBarButtonItem:self.actionButton
                    permittedArrowDirections:UIPopoverArrowDirectionUp
                                    animated:YES];
    [avc setCompletionHandler:^(NSString *activityType, BOOL completed){
        [popover dismissPopoverAnimated:YES];
    }];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url = request.URL.absoluteString;
    
    if ([url isEqualToString:@"about:blank"]) {
        return YES;
    }
    
    ZHWebBrowserController *wbc = [[ZHWebBrowserController alloc] initWithURL:url];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:wbc];
    [self.splitViewController presentViewController:nc animated:YES completion:nil];
    
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
