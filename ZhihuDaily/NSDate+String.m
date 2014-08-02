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

- (NSString *)toDisplayString
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy.MM.dd";
    formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    return [formatter stringFromDate:self];
}

- (NSString *)weekdayString
{
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *components = [calendar components:NSWeekdayCalendarUnit
                                               fromDate:self];
	NSInteger weekday = [components weekday];
    
    NSArray *weekdayArray = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
    return [NSString stringWithFormat:@"星期%@", weekdayArray[weekday - 1]];
}

@end
