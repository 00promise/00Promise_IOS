//
//  Reply.m
//  00Promise
//
//  Created by Rangken on 13. 9. 28..
//  Copyright (c) 2013년 SocialInovation. All rights reserved.
//

#import "Reply.h"

@implementation Reply
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
    if ([property isEqualToString:@"createdAt"])
        return @"createdAt";
    return [super encodeValueForProperty:property remoteKey:remoteKey];
}

- (void) decodeRemoteValue:(id)remoteObject forRemoteKey:(NSString *)remoteKey
{
    if ([remoteKey isEqualToString:@"created_at"]) {
        _createdAt = remoteObject;
        return ;
    }
    [super decodeRemoteValue:remoteObject forRemoteKey:remoteKey];
}
@end
