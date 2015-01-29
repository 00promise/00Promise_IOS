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
    
    NSInteger year = [components year];
    NSInteger month = [components month];
    NSInteger day = [components day];
    
    return [NSString stringWithFormat:@"%d.%02ld,%02ld",year,month,day];
}

+ (NSString*)timeDateStringByTimestamp:(long)timestamp{
    NSDate* date = [[NSDate alloc] initWithTimeIntervalSince1970:timestamp];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:kCFCalendarUnitYear|kCFCalendarUnitMonth|kCFCalendarUnitDay|kCFCalendarUnitHour|kCFCalendarUnitMinute|kCFCalendarUnitSecond fromDate:date];
    
    NSInteger year = [components year];
    NSInteger month = [components month];
    NSInteger day = [components day];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    NSInteger second = [components second];
    if (hour >= 12) {
        return [NSString stringWithFormat:@"%ld.%02ld,%02ld 오후 %02ld:%02ld:%02ld",year,month,day,hour,minute,second];
    }
    return [NSString stringWithFormat:@"%ld.%02ld.%02ld 오전 %02ld:%02ld:%02ld",year,month,day,hour,minute,second];
}
@end
