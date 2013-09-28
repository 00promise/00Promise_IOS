//
//  Politician.h
//  00Promise
//
//  Created by Rangken on 13. 9. 28..
//  Copyright (c) 2013년 SocialInovation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSRails.h"

@interface Politician : NSRRemoteObject
@property (nonatomic, strong) NSNumber *ID,*birthday;
@property (nonatomic, strong) NSString *name, *memo, *img, *bgImg, *positionName, *partyName;
@property (nonatomic, strong) NSMutableArray *manifestos;
- (BOOL)haveImg;
- (BOOL)haveBgImg;
@end
