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
    if ([property isEqualToString:@"createdAt"])
        return @"createdAt";
    if ([property isEqualToString:@"updatedAt"])
        return @"updatedAt";
    return [super encodeValueForProperty:property remoteKey:remoteKey];
}
- (void) decodeRemoteValue:(id)remoteObject forRemoteKey:(NSString *)remoteKey
{
    if ([remoteKey isEqualToString:@"created_at"]) {
        _createdAt = remoteObject;
        return ;
    }if ([remoteKey isEqualToString:@"updated_at"]) {
        _updatedAt = remoteObject;
        return ;
    }
    [super decodeRemoteValue:remoteObject forRemoteKey:remoteKey];
}
@end
