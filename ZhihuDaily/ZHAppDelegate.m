//
//  ZHAppDelegate.m
//  ZhihuDaily
//
//  Created by Madimo on 8/1/14.
//  Copyright (c) 2014 Madimo. All rights reserved.
//

#import "ZHAppDelegate.h"
#import "ZHStoryCell.h"
#import <AFNetworkActivityIndicatorManager.h>

@interface ZHAppDelegate ()
@end

@implementation ZHAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    lightModeContentBackgroundColor = [UIColor colorWithRed:249.0 / 255.0
                                                      green:249.0 / 255.0
                                                       blue:249.0 / 255.0
                                                      alpha:1.0];
    nightModeContentBackgroundColor = [UIColor colorWithRed:52.0 / 255.0
                                                      green:52.0 / 255.0
                                                       blue:52.0 / 255.0
                                                      alpha:1.0];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    nightMode = [defaults boolForKey:kUDNightModeKey];
    if (nightMode) {
        [self switchToNightMode];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(themeChanged:)
                                                 name:kThemeChangedNotification
                                               object:nil];
    
    return YES;
}

- (void)themeChanged:(NSNotification *)notification
{
    if (nightMode) {
        [self switchToNightMode];
    } else {
        [self switchToLightMode];
    }
    [self refreshAppearance];
}

- (void)switchToNightMode
{
    UINavigationBar.appearance.barTintColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    UINavigationBar.appearance.titleTextAttributes = @{ NSForegroundColorAttributeName : [UIColor lightGrayColor] };
    UIBarButtonItem.appearance.tintColor = [UIColor whiteColor];
    UITableView.appearance.backgroundColor = nightModeContentBackgroundColor;
    UIWebView.appearance.backgroundColor = nightModeContentBackgroundColor;
    UISwitch.appearance.thumbTintColor = [UIColor darkGrayColor];
    UISwitch.appearance.onTintColor = [UIColor lightGrayColor];
    UITableViewCell.appearance.backgroundColor = nightModeContentBackgroundColor;
    UILabel.appearance.textColor = [UIColor lightGrayColor];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)switchToLightMode
{
    UINavigationBar.appearance.barTintColor = nil;
    UINavigationBar.appearance.titleTextAttributes = nil;
    UIBarButtonItem.appearance.tintColor = nil;
    UITableView.appearance.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UIWebView.appearance.backgroundColor = nil;
    UISwitch.appearance.thumbTintColor = nil;
    UISwitch.appearance.onTintColor = nil;
    UITableViewCell.appearance.backgroundColor = lightModeContentBackgroundColor;
    UILabel.appearance.textColor = nil;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)refreshAppearance
{
    NSArray *windows = [UIApplication sharedApplication].windows;
    for (UIWindow *window in windows) {
        for (UIView *view in window.subviews) {
            [view removeFromSuperview];
            [window addSubview:view];
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
