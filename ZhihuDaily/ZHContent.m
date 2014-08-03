//
//  ZHContent.m
//  ZhihuDaily
//
//  Created by Madimo on 14-8-2.
//  Copyright (c) 2014 Madimo. All rights reserved.
//

#import "ZHContent.h"

@implementation ZHContent

- (instancetype)initWithContentDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.type = [dict[@"type"] integerValue];
        self.storyId = [NSString stringWithFormat:@"%@", dict[@"id"]];
        self.title = dict[@"title"];
        
        // convert share link to faceair's zhihudaily.net
        self.shareUrl = dict[@"share_url"];
        if ([self.shareUrl hasPrefix:@"http://daily.zhihu.com/"]) {
            self.shareUrl = [self.shareUrl stringByReplacingOccurrencesOfString:@"http://daily.zhihu.com/"
                                                                     withString:@"http://www.zhihudaily.net/"];
        }
        
        self.gaPrefix = dict[@"ga_prefix"];
        
        NSMutableArray *csses = [NSMutableArray new];
        for (NSString *css in dict[@"css"]) {
            [csses addObject:css];
        }
        self.css = csses;
        
        NSMutableArray *jses = [NSMutableArray new];
        for (NSString *js in dict[@"js"]) {
            [jses addObject:js];
        }
        self.js = jses;
        
        if (self.type == 0) {
            self.body = dict[@"body"];
            self.imageSource = dict[@"image_source"];
            self.imageUrl = dict[@"image_url"];
        } else if (self.type == 1) {
            self.themeName = dict[@"theme_name"];
            self.editorName = dict[@"editorName"];
            self.themeId = [NSString stringWithFormat:@"%@", dict[@"themeId"]];;
        }
    }
    return self;
}

+ (instancetype)contentWithContentDict:(NSDictionary *)dict
{
    return [[self alloc] initWithContentDict:dict];
}

@end
