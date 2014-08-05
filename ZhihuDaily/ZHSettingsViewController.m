//
//  ZHSettingsViewController.m
//  ZhihuDaily
//
//  Created by Madimo on 14-8-3.
//  Copyright (c) 2014 Madimo. All rights reserved.
//

#import "ZHSettingsViewController.h"

#define kActionSheetTagClearCache 1

@interface ZHSettingsViewController () <UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UISwitch *nightModeSwitch;
@property (weak, nonatomic) IBOutlet UITableViewCell *cacheCell;
@property (strong, nonatomic) UITapGestureRecognizer *gestureRecognizer;
@property (strong, nonatomic) NSUserDefaults *defaults;
@end

@implementation ZHSettingsViewController

- (void)viewDidLoad
{
    self.defaults = [NSUserDefaults standardUserDefaults];
    self.nightModeSwitch.on = [self.defaults boolForKey:kUDNightModeKey];
    
    [self reloadCacheUsage];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (!self.gestureRecognizer) {
        self.gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                         action:@selector(handleTapGesture:)];
        self.gestureRecognizer.numberOfTapsRequired = 1;
        self.gestureRecognizer.cancelsTouchesInView = NO;
        [self.view.window addGestureRecognizer:self.gestureRecognizer];
    }
}

- (IBAction)nightModeChanged:(id)sender
{
    [self.defaults setBool:self.nightModeSwitch.on forKey:kUDNightModeKey];
    [self.defaults synchronize];
    
    nightMode = self.nightModeSwitch.on;
    [[NSNotificationCenter defaultCenter] postNotificationName:kThemeChangedNotification
                                                        object:@(nightMode)
                                                      userInfo:nil];
}

- (void)reloadCacheUsage
{
    NSInteger currentDiskUsage = [NSURLCache sharedURLCache].currentDiskUsage;
    self.cacheCell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f MB", currentDiskUsage / 1024.0 / 1024.0];
}

- (void)clearCache
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [self reloadCacheUsage];
}

#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return nil;
    }
    
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 1: {
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"清除缓存"
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                 destructiveButtonTitle:@"清除缓存"
                                                      otherButtonTitles:nil];
            sheet.tag = kActionSheetTagClearCache;
            [sheet showInView:self.cacheCell];
            break;
        }
        default:
            break;
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    
    if (actionSheet.tag == kActionSheetTagClearCache) {
        [self clearCache];
    }
}

- (IBAction)onDoneButtonTapped:(id)sender
{
    [self dismissViewController];
}

- (void)handleTapGesture:(UITapGestureRecognizer *)recognizer
{
    CGPoint touchPoint = [recognizer locationInView:nil];
    CGPoint convertPoint = [self.view convertPoint:touchPoint fromView:recognizer.view];
    if (!CGRectContainsPoint(self.view.bounds, convertPoint)) {
        [self dismissViewController];
    }
}

- (void)dismissViewController
{
    [self.view.window removeGestureRecognizer:self.gestureRecognizer];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
