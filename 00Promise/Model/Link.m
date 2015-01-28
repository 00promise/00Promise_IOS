//
//  Link.m
//  00Promise
//
//  Created by Rangken on 2015. 1. 28..
//  Copyright (c) 2015년 SocialInovation. All rights reserved.
//

#import "Link.h"

@implementation Link
- (Class)nestedClassForProperty:(NSString *)property
{
    return [super nestedClassForProperty:property];
}
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
