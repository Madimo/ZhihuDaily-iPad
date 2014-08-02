//
//  ZHStory.h
//  ZhihuDaily
//
//  Created by Madimo on 8/1/14.
//  Copyright (c) 2014 Madimo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHStory : NSObject

@property (strong, nonatomic) NSString *storyId;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *shareUrl;
@property (strong, nonatomic) NSString *GaPrefix;
@property (strong, nonatomic) NSArray *imageUrls;
@property (nonatomic) NSInteger type;

+ (instancetype)storyWithStoryDict:(NSDictionary *)dict;
- (instancetype)initWithStoryDict:(NSDictionary *)dict;

@end