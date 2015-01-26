//
//  Manifesto.h
//  00Promise
//
//  Created by Rangken on 13. 9. 28..
//  Copyright (c) 2013년 SocialInovation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSRails.h"
#import "Politician.h"
#import "Reply.h"
@interface Manifesto : NSRRemoteObject
@property (nonatomic, strong) NSNumber *ID,*replyCnt,*goodCnt,*fairCnt,*poorCnt,*ratingStatus;
@property (nonatomic, strong) NSString *title, *descriptionInfo;
@property (nonatomic, strong) Politician*  politician;
@property (nonatomic, strong) Reply* reply;
@property (nonatomic, strong) NSMutableArray* replies;

@end
