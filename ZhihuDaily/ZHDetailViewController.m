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
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) NSURLSessionDataTask *task;
@property (strong, nonatomic) ZHContent *content;
@end

@implementation ZHDetailViewController

- (void)awakeFromNib
{
    self.splitViewController.delegate = self;
    [self.view bringSubviewToFront:self.loadingMaskView];
}

- (void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(themeChanged:)
                                                 name:kThemeChangedNotification
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self themeChanged:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)themeChanged:(NSNotification *)notification
{
    self.view.backgroundColor = nightMode ? nightModeContentBackgroundColor : lightModeContentBackgroundColor;

    self.loadingMaskView.backgroundColor = nightMode ? [UIColor colorWithWhite:0.3 alpha:0.6] :
                                                       [UIColor colorWithWhite:1.0 alpha:0.6];
    self.activityIndicator.color = nightMode ? [UIColor whiteColor] : [UIColor grayColor];
    
    if (!self.story) {
        if (nightMode) {
            [self.webview loadHTMLString:@"<body bgcolor=\"#343434\"></body>" baseURL:nil];
        }
    }
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
                                          self.webview.hidden = NO;
                                          self.actionButton.enabled = YES;
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
    NSLog(@"%@", url);
    
    if ([url hasPrefix:@"file:///"]) {
        return YES;
    }
    
    if ([url isEqualToString:@"about:blank"]) {
        return YES;
    }
    
    if ([url isEqualToString:@"zhihunews:loadimg"]) {
        return NO;
    }
    
    if ([url isEqualToString:@"zhihunews:ready"]) {
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.loadingMaskView.alpha = 0.0;
                         }
                         completion:^(BOOL finished) {
                             self.loadingMaskView.hidden = YES;
                             self.loadingMaskView.alpha = 1.0;
                         }];
        return NO;
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
