//
//  Issue.h
//  00Promise
//
//  Created by Rangken on 2015. 1. 28..
//  Copyright (c) 2015년 SocialInovation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSRails.h"
#import "Link.h"
@interface Issue : NSRRemoteObject
@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) Link* link;
@end
