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
@property (strong, nonatomic) UITapGestureRecognizer *gestureRecognizer;
@property (strong, nonatomic) NSUserDefaults *defaults;
@end

@implementation ZHSettingsViewController

- (void)viewDidLoad
{
    self.defaults = [NSUserDefaults standardUserDefaults];
    self.nightModeSwitch.on = [self.defaults boolForKey:kUDNightModeKey];
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
