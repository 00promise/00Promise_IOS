//
//  Sido.m
//  00Promise
//
//  Created by Rangken on 13. 9. 28..
//  Copyright (c) 2013년 SocialInovation. All rights reserved.
//

#import "Sido.h"

@implementation Sido
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
@end
