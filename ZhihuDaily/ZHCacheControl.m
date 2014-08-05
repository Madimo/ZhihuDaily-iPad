//
//  ZHCacheControl.m
//  ZhihuDaily
//
//  Created by Madimo on 14-8-5.
//  Copyright (c) 2014 Madimo. All rights reserved.
//

#import "ZHCacheControl.h"
#import "ZHStory.h"

@interface ZHCacheControl ()
@property (strong, nonatomic) NSMutableSet *readList;
@end

@implementation ZHCacheControl

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        self.readList = [NSMutableSet setWithArray:[defaults objectForKey:kUDReadListKey]];
        if (!self.readList) {
            self.readList = [NSMutableSet new];
        }
    }
    return self;
}

- (BOOL)isRead:(ZHStory *)story
{
    return [self.readList containsObject:story.storyId];
}

- (void)setRead:(ZHStory *)story
{
    if (![self.readList containsObject:story.storyId]) {
        [self.readList addObject:story.storyId];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:self.readList.allObjects forKey:kUDReadListKey];
        [defaults synchronize];
    }
}

- (NSInteger)readCount
{
    return self.readList.count;
}

- (void)clearAllReadMark
{
    [self.readList removeAllObjects];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:kUDReadListKey];
    [defaults synchronize];
}

#pragma mark - Singleton

+ (instancetype)cacheControl
{
    static ZHCacheControl *sharedObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObject = [[super allocWithZone:NULL] init];
    });
    
    return sharedObject;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [self cacheControl];
}

@end
