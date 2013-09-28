//
//  Sigungu.h
//  00Promise
//
//  Created by Rangken on 13. 9. 28..
//  Copyright (c) 2013년 SocialInovation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSRails.h"
@interface Sigungu : NSRRemoteObject
@property (nonatomic, strong) NSNumber *ID,*code;
@property (nonatomic, strong) NSString *name, *fullName;
@end
