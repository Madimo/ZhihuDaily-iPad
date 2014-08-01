//
//  ZHClient.h
//  ZhihuDaily
//
//  Created by Madimo on 8/1/14.
//  Copyright (c) 2014 Madimo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ZHStory.h"

typedef NS_ENUM(NSUInteger, StartImageSize) {
    StartImageSize320by432,
    StartImageSize480by728,
    StartImageSize720by1184,
    StartImageSize1080by1776
};

@interface ZHClient : NSObject

+ (instancetype)client;

- (NSURLSessionDataTask *)getStartImagePathWithSize:(StartImageSize)size
                                            success:(void (^)(NSString *path, NSString *text))success
                                            failure:(void (^)(NSError *error))failure;

- (NSURLSessionDataTask *)getLatestStoriesWithSuccess:(void (^)(NSString *date, NSArray *stories, NSArray *topStories))success
                                              failure:(void (^)(NSError *error))failure;

- (NSURLSessionDataTask *)getPastStoriesWithDate:(NSString *)date
                                         success:(void (^)(NSString *date, NSArray *stories))success
                                         failure:(void (^)(NSError *error))failure;

@end
