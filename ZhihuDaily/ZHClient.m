//
//  ZHClient.m
//  ZhihuDaily
//
//  Created by Madimo on 8/1/14.
//  Copyright (c) 2014 Madimo. All rights reserved.
//

#import "ZHClient.h"

#define kUrlPath @"http://news-at.zhihu.com/api/3"

@implementation ZHClient

- (NSURLSessionDataTask *)getPath:(NSString *)path
                       parameters:(NSDictionary *)parameters
                          success:(void (^)(NSURLSessionDataTask *task, NSDictionary *responseDict))success
                          failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    return [[AFHTTPSessionManager manager] GET:[NSString stringWithFormat:@"%@%@", kUrlPath, path]
                                    parameters:parameters
                                       success:success
                                       failure:failure];
}

- (NSURLSessionDataTask *)getStartImagePathWithSize:(StartImageSize)size
                                            success:(void (^)(NSString *path, NSString *text))success
                                            failure:(void (^)(NSError *error))failure
{
    NSString *sizeString;
    switch (size) {
        case StartImageSize320by432:
            sizeString = @"320*432";
            break;
        case StartImageSize480by728:
            sizeString = @"480*728";
            break;
        case StartImageSize720by1184:
            sizeString = @"720*1184";
            break;
        case StartImageSize1080by1776:
            sizeString = @"1080*1776";
        default:
            break;
    }
    
    return [self getPath:[NSString stringWithFormat:@"/start-image/%@", sizeString]
              parameters:nil
                 success:^(NSURLSessionDataTask *task, NSDictionary *responseDict) {
                     if (success) {
                         success(responseDict[@"img"], responseDict[@"text"]);
                     }
                 }
                 failure:^(NSURLSessionDataTask *task, NSError *error) {
                     if (failure) {
                         failure(error);
                     }
                 }];
}

- (NSURLSessionDataTask *)getLatestStoriesWithSuccess:(void (^)(NSString *date, NSArray *stories, NSArray *topStories))success
                                              failure:(void (^)(NSError *error))failure
{
    return [self getPath:@"/news/latest"
              parameters:nil
                 success:^(NSURLSessionDataTask *task, NSDictionary *responseDict) {
                     if (success) {
                         NSString *date = responseDict[@"date"];
                         NSMutableArray *stories = [NSMutableArray new];
                         NSMutableArray *topStories = [NSMutableArray new];
                         
                         for (NSDictionary *dict in responseDict[@"stories"]) {
                             ZHStory *story = [ZHStory storyWithStoryDict:dict];
                             [stories addObject:story];
                         }
                         
                         for (NSDictionary *dict in responseDict[@"top_stories"]) {
                             ZHStory *story = [ZHStory storyWithStoryDict:dict];
                             [topStories addObject:story];
                         }
                         
                         success(date, stories, topStories);
                     }
                 }
                 failure:^(NSURLSessionDataTask *task, NSError *error) {
                     if (failure) {
                         failure(error);
                     }
                 }];
}

- (NSURLSessionDataTask *)getPastStoriesWithDate:(NSString *)date
                                         success:(void (^)(NSString *date, NSArray *stories))success
                                         failure:(void (^)(NSError *error))failure
{
    NSLog(@"%@", [NSString stringWithFormat:@"/news/before/%@", date]);
    return [self getPath:[NSString stringWithFormat:@"/news/before/%@", date]
              parameters:nil
                 success:^(NSURLSessionDataTask *task, NSDictionary *responseDict) {
                     if (success) {
                         NSString *date = responseDict[@"date"];
                         NSMutableArray *stories = [NSMutableArray new];
                         
                         for (NSDictionary *dict in responseDict[@"stories"]) {
                             ZHStory *story = [ZHStory storyWithStoryDict:dict];
                             [stories addObject:story];
                         }
                         
                         success(date, stories);
                     }
                 }
                 failure:^(NSURLSessionDataTask *task, NSError *error) {
                     if (failure) {
                         failure(error);
                     }
                 }];
}

- (NSURLSessionDataTask *)getContentWithStoryId:(NSString *)storyId
                                        success:(void (^)(ZHContent *content))success
                                        failure:(void (^)(NSError *error))failure
{
    return [self getPath:[NSString stringWithFormat:@"/news/%@", storyId]
              parameters:nil
                 success:^(NSURLSessionDataTask *task, NSDictionary *responseDict) {
                     if (success) {
                         ZHContent *content = [ZHContent contentWithContentDict:responseDict];
                         success(content);
                     }
                 }
                 failure:^(NSURLSessionDataTask *task, NSError *error) {
                     if (failure) {
                         failure(error);
                     }
                 }];
}

#pragma mark - Singleton

+ (instancetype)client
{
    static ZHClient *sharedObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObject = [[super allocWithZone:NULL] init];
    });
    return sharedObject;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [self client];
}


@end
