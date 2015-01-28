//
//  Link.h
//  00Promise
//
//  Created by Rangken on 2015. 1. 28..
//  Copyright (c) 2015년 SocialInovation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSRails.h"
#import "Politician.h"
@interface Link : NSRRemoteObject
@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, strong) NSString *titlel, *press, *title, *url;
@property (nonatomic, strong) Politician* politician;
@end
