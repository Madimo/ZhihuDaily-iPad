//
//  NSString+Date.m
//  ZhihuDaily
//
//  Created by Madimo on 8/1/14.
//  Copyright (c) 2014 Madimo. All rights reserved.
//

#import "NSString+Date.h"

@implementation NSString (Date)

- (NSDate *)toDate
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyyMMdd";
    formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    return [formatter dateFromString:self];
}

@end
