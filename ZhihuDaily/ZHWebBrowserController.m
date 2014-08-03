//
//  ZHWebBrowserController.m
//  ZhihuDaily
//
//  Created by Madimo on 14-8-2.
//  Copyright (c) 2014 Madimo. All rights reserved.
//

#import "ZHWebBrowserController.h"
#import "ZHWebView.h"

@interface ZHWebBrowserController () <UIWebViewDelegate, ZHWebViewProgressDelegate>
@property (nonatomic) UIStatusBarStyle statusBarStyle;
@property (nonatomic) BOOL toolbarHidden;
@property (strong, nonatomic) ZHWebView *webView;
@property (strong, nonatomic) UIProgressView *progressView;
@property (strong, nonatomic) UIBarButtonItem *forwardButton;
@property (strong, nonatomic) UIBarButtonItem *backButton;
@property (strong, nonatomic) UIBarButtonItem *refreshStopButton;
@property (strong, nonatomic) UIBarButtonItem *openInChromeButton;
@property (strong, nonatomic) UIBarButtonItem *openInSafariButton;
@end

@implementation ZHWebBrowserController

#pragma mark - Initialize

- (instancetype)initWithURL:(NSString *)url
{
    self = [super init];
    if (self) {
        self.url = url;
    }
    return self;
}

- (void)initNavigationBar
{
    self.backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"]
                                                       style:UIBarButtonItemStylePlain
                                                      target:self
                                                      action:@selector(goBack:)];
    
    self.forwardButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"forward"]
                                                          style:UIBarButtonItemStylePlain
                                                         target:self
                                                         action:@selector(goForward:)];
    
    self.refreshStopButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reload"]
                                                              style:UIBarButtonItemStylePlain
                                                             target:self
                                                             action:@selector(reload:)];
    
    self.openInChromeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"chrome"]
                                                               style:UIBarButtonItemStylePlain
                                                              target:self
                                                              action:@selector(openInChrome:)];
    self.openInChromeButton.enabled = [[OpenInChromeController sharedInstance] isChromeInstalled];
    
    self.openInSafariButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"safari"]
                                                               style:UIBarButtonItemStylePlain
                                                              target:self
                                                              action:@selector(openInSafari:)];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                          target:self
                                                                          action:@selector(done:)];
    
    self.navigationItem.leftBarButtonItems = @[self.backButton, self.forwardButton, self.refreshStopButton];
    self.navigationItem.rightBarButtonItems = @[doneButton, self.openInSafariButton, self.openInChromeButton];
}

- (void)initWebView
{
    self.webView = [[ZHWebView alloc] initWithFrame:self.view.bounds];
    self.webView.delegate = self;
    self.webView.progressDelegate = self;
    [self.view addSubview:self.webView];
}

- (void)initProgressView
{
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    CGRect frame = self.progressView.frame;
    frame.origin.y = CGRectGetHeight(self.navigationController.navigationBar.frame) - CGRectGetHeight(frame);
    frame.size.width = CGRectGetWidth(self.navigationController.navigationBar.frame);
    self.progressView.frame = frame;
    self.progressView.alpha = 0.0;
    [self.navigationController.navigationBar addSubview:self.progressView];
}

#pragma mark - View lift cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect frame = self.view.frame;
    if (self.interfaceOrientation == UIDeviceOrientationLandscapeRight ||
        self.interfaceOrientation == UIDeviceOrientationLandscapeLeft) {
        if (frame.size.height > frame.size.width) {
            CGFloat height = frame.size.height;
            frame.size.height = frame.size.width;
            frame.size.width = height;
            self.view.frame = frame;
        }
    }
    
    [self initNavigationBar];
    [self initWebView];
    [self initProgressView];
    
    self.title = self.url;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [self.webView loadRequest:request];
    
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration
{
    [UIView animateWithDuration:duration
                     animations:^{
                         self.webView.frame = self.view.bounds;
                     }];
}

#pragma mark - UIWebView delegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [NSTimer scheduledTimerWithTimeInterval:0.5
                                     target:self
                                   selector:@selector(setTitleFromWebView:)
                                   userInfo:nil
                                    repeats:YES];
    
    self.refreshStopButton.image = [UIImage imageNamed:@"stop"];
    [self refreshButtonStatus];
    
    self.progressView.progress = 0.0;
    self.progressView.alpha = 1.0;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.refreshStopButton.image = [UIImage imageNamed:@"reload"];
    [self refreshButtonStatus];
    
    [UIView beginAnimations:nil context:nil];
    self.progressView.alpha = 0.0;
    [UIView commitAnimations];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    self.refreshStopButton.image = [UIImage imageNamed:@"reload"];
    [self refreshButtonStatus];
    
    [UIView beginAnimations:nil context:nil];
    self.progressView.alpha = 0.0;
    [UIView commitAnimations];
}

#pragma mark - Private API

- (void)webView:(ZHWebView *)webView didReceiveResourceNumber:(NSInteger)resourceNumber totalResources:(NSInteger)totalResources
{
    [self.progressView setProgress:(float)resourceNumber / (float)totalResources animated:YES];
}

#pragma mark - Timer action

- (void)setTitleFromWebView:(NSTimer *)timer
{
    NSString *title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (title && ![title isEqualToString:@""]) {
        self.title = title;
    }
    
    if (!self.webView.isLoading) {
        [timer invalidate];
    }
}

#pragma mark - Button item action

- (void)done:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)refreshButtonStatus
{
    self.backButton.enabled = self.webView.canGoBack;
    self.forwardButton.enabled = self.webView.canGoForward;
}

- (void)goBack:(id)sender
{
    [self.webView goBack];
    [self refreshButtonStatus];
}

- (void)goForward:(id)sender
{
    [self.webView goForward];
    [self refreshButtonStatus];
}

- (void)reload:(id)sender
{
    if (self.webView.isLoading)
        [self.webView stopLoading];
    else
        [self.webView reload];
    [self refreshButtonStatus];
}

- (void)openInChrome:(id)sender
{
    [[OpenInChromeController sharedInstance] openInChrome:self.webView.request.URL
                                          withCallbackURL:[NSURL URLWithString:@"zhihunews://"]
                                             createNewTab:NO];
}

- (void)openInSafari:(id)sender
{
    [[UIApplication sharedApplication] openURL:self.webView.request.URL];
}

@end
