//
//  Politician.m
//  00Promise
//
//  Created by Rangken on 13. 9. 28..
//  Copyright (c) 2013년 SocialInovation. All rights reserved.
//

#import "Politician.h"
#import "Manifesto.h"
#import "Link.h"
#import "Reply.h"
@implementation Politician
- (Class)nestedClassForProperty:(NSString *)property
{
    if ([property isEqualToString:@"manifestos"])
        return [Manifesto class];
    if ([property isEqualToString:@"links"])
        return [Link class];
    if ([property isEqualToString:@"replies"])
        return [Reply class];
    return [super nestedClassForProperty:property];
}
- (NSString *) propertyForRemoteKey:(NSString *)remoteKey
{
    if ([remoteKey isEqualToString:@"id"])
    return @"ID";
    
    return [super propertyForRemoteKey:remoteKey];
}

- (id) encodeValueForProperty:(NSString *)property remoteKey:(NSString **)remoteKey
{
    if ([property isEqualToString:@"ID"])
    *remoteKey = @"id";
    
    return [super encodeValueForProperty:property remoteKey:remoteKey];
}

- (BOOL)haveImg{
    if ([_img rangeOfString:@"missing"].location == NSNotFound)
        return TRUE;
    return FALSE;
}
- (BOOL)haveBgImg{
    if ([_bgImg rangeOfString:@"missing"].location == NSNotFound)
        return TRUE;
    return FALSE;
}
- (NSString*)birthDayStr{
    NSDate* date = [[NSDate alloc] initWithTimeIntervalSince1970:_birthday.longLongValue];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:kCFCalendarUnitYear|kCFCalendarUnitMonth|kCFCalendarUnitDay|kCFCalendarUnitHour|kCFCalendarUnitMinute|kCFCalendarUnitSecond fromDate:date];
    
    NSInteger year = [components year];
    NSInteger month = [components month];
    NSInteger day = [components day];

    return [NSString stringWithFormat:@"%ld/%ld/%ld",year,month,day];
}
@end
