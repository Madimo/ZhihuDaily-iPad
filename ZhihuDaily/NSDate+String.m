//
//  NSDate+String.m
//  ZhihuDaily
//
//  Created by Madimo on 8/1/14.
//  Copyright (c) 2014 Madimo. All rights reserved.
//

#import "NSDate+String.h"

@implementation NSDate (String)

- (NSString *)toString
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyyMMdd";
    formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    return [formatter stringFromDate:self];
}

@end
