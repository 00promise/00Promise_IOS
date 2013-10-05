//
//  DateUtil.m
//  00Promise
//
//  Created by Rangken on 13. 9. 28..
//  Copyright (c) 2013년 SocialInovation. All rights reserved.
//

#import "DateUtil.h"

@implementation DateUtil
+ (NSString*)dateStringByTimestamp:(long)timestamp{
    NSDate* date = [[NSDate alloc] initWithTimeIntervalSince1970:timestamp];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
    
    int year = [components year];
    int month = [components month];
    int day = [components day];
    
    return [NSString stringWithFormat:@"%d.%02d,%02d",year,month,day];
}

+ (NSString*)timeDateStringByTimestamp:(long)timestamp{
    NSDate* date = [[NSDate alloc] initWithTimeIntervalSince1970:timestamp];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:kCFCalendarUnitYear|kCFCalendarUnitMonth|kCFCalendarUnitDay|kCFCalendarUnitHour|kCFCalendarUnitMinute|kCFCalendarUnitSecond fromDate:date];
    
    int year = [components year];
    int month = [components month];
    int day = [components day];
    int hour = [components hour];
    int minute = [components minute];
    int second = [components second];
    if (hour >= 12) {
        return [NSString stringWithFormat:@"%d.%02d,%02d 오후 %02d:%02d:%02d",year,month,day,hour,minute,second];
    }
    return [NSString stringWithFormat:@"%d.%02d.%02d 오전 %02d:%02d:%02d",year,month,day,hour,minute,second];
}
@end
