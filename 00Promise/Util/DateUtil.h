//
//  DateUtil.h
//  00Promise
//
//  Created by Rangken on 13. 9. 28..
//  Copyright (c) 2013년 SocialInovation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtil : NSObject
+ (NSString*)dateStringByTimestamp:(long)timestamp;
+ (NSString*)timeDateStringByTimestamp:(long)timestamp;
@end
