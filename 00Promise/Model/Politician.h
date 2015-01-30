//
//  Politician.h
//  00Promise
//
//  Created by Rangken on 13. 9. 28..
//  Copyright (c) 2013년 SocialInovation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSRails.h"
// :history, :property, :military, :payment, :arrears, :now_arrears, :crime
@interface Politician : NSRRemoteObject
@property (nonatomic, strong) NSNumber *ID,*birthday, *currentAge, *property, *payment, *arrears,*nowArrears;
@property (nonatomic, strong) NSString *name, *memo, *img, *bgImg, *positionName, *partyName, *academic, *history, *military, *crime;
@property (nonatomic, strong) NSMutableArray *manifestos, *links, *replies;
- (BOOL)haveImg;
- (BOOL)haveBgImg;
- (NSString*)birthDayStr;
@end
