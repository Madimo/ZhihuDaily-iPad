//
//  ZHCacheControl.h
//  ZhihuDaily
//
//  Created by Madimo on 14-8-5.
//  Copyright (c) 2014 Madimo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZHStory;

@interface ZHCacheControl : NSObject

@property (nonatomic, readonly) NSInteger readCount;

+ (instancetype)cacheControl;

- (BOOL)isRead:(ZHStory *)story;
- (void)setRead:(ZHStory *)story;
- (void)clearAllReadMark;

@end
