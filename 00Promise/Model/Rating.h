//
//  Rating.h
//  00Promise
//
//  Created by Rangken on 13. 9. 28..
//  Copyright (c) 2013년 SocialInovation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSRails.h"
@interface Rating : NSRRemoteObject
@property (nonatomic, strong) NSNumber *ID,*replyCnt,*goodCnt,*fairCnt,*poorCnt;
@property (nonatomic, strong) NSString *title, *descriptionInfo;
@end
