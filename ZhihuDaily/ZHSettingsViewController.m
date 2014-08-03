//
//  ZHSettingsViewController.m
//  ZhihuDaily
//
//  Created by Madimo on 14-8-3.
//  Copyright (c) 2014 Madimo. All rights reserved.
//

#import "ZHSettingsViewController.h"

@interface ZHSettingsViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *nightModeSwitch;
@property (strong, nonatomic) NSUserDefaults *defaults;
@end

@implementation ZHSettingsViewController

- (void)viewDidLoad
{
    NSLog(@"%@", NSStringFromCGRect(self.view.frame));
    NSLog(@"%@", NSStringFromCGRect(self.view.bounds));
    
    self.defaults = [NSUserDefaults standardUserDefaults];
    self.nightModeSwitch.on = [self.defaults boolForKey:kUDNightModeKey];
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

- (IBAction)onDoneButtonTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
