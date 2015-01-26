//
//  Rating.m
//  00Promise
//
//  Created by Rangken on 13. 9. 28..
//  Copyright (c) 2013년 SocialInovation. All rights reserved.
//

#import "Rating.h"

@implementation Rating
- (NSString *) propertyForRemoteKey:(NSString *)remoteKey
{
    if ([remoteKey isEqualToString:@"id"])
        return @"ID";
    if ([remoteKey isEqualToString:@"description"])
        return @"descriptionInfo";
    
    return [super propertyForRemoteKey:remoteKey];
}

- (id) encodeValueForProperty:(NSString *)property remoteKey:(NSString **)remoteKey
{
    if ([property isEqualToString:@"ID"])
        *remoteKey = @"id";
    if ([property isEqualToString:@"descriptionInfo"])
        *remoteKey = @"description";
    
    return [super encodeValueForProperty:property remoteKey:remoteKey];
}
@end
