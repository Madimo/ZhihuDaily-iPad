//
//  ZHContent.h
//  ZhihuDaily
//
//  Created by Madimo on 14-8-2.
//  Copyright (c) 2014 Madimo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHContent : NSObject

@property (nonatomic) NSInteger type;
@property (strong, nonatomic) NSString *storyId;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *shareUrl;
@property (strong, nonatomic) NSString *gaPrefix;
@property (strong, nonatomic) NSArray *css;
@property (strong, nonatomic) NSArray *js;

// type == 0
@property (strong, nonatomic) NSString *body;
@property (strong, nonatomic) NSString *imageSource;
@property (strong, nonatomic) NSString *imageUrl;

// type == 1
@property (strong, nonatomic) NSString *themeName;
@property (strong, nonatomic) NSString *editorName;
@property (strong, nonatomic) NSString *themeId;

+ (instancetype)contentWithContentDict:(NSDictionary *)dict;
- (instancetype)initWithContentDict:(NSDictionary *)dict;

@end
