//
//  ZHStory.m
//  ZhihuDaily
//
//  Created by Madimo on 8/1/14.
//  Copyright (c) 2014 Madimo. All rights reserved.
//

#import "ZHStory.h"

@implementation ZHStory

- (instancetype)initWithStoryDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.storyId = [NSString stringWithFormat:@"%@", dict[@"id"]];
        self.title = dict[@"title"];
        self.shareUrl = dict[@"share_url"];
        self.GaPrefix = dict[@"ga_prefix"];
        self.type = [dict[@"type"] integerValue];
        
        NSMutableArray *imageUrls = [NSMutableArray new];
        for (NSString *url in dict[@"images"]) {
            [imageUrls addObject:url];
        }
        self.imageUrls = imageUrls;
    }
    return self;
}

+ (instancetype)storyWithStoryDict:(NSDictionary *)dict
{
    return [[self alloc] initWithStoryDict:dict];
}

@end
