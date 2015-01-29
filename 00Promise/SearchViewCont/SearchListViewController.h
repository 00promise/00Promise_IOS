//
//  SearchListViewController.h
//  00Promise
//
//  Created by Rangken on 2015. 1. 29..
//  Copyright (c) 2015년 SocialInovation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"
typedef enum{
    SearchListLocation,
    SearchListLocationDetail,
    SearchListParty,
    SearchListElection
} SearListType;
@interface SearchListViewController :  SuperViewController <SuperViewControllerDelegate>
@property (nonatomic, assign) SearListType type;
@property (nonatomic, strong) NSMutableArray* array;
@property (nonatomic, assign) NSInteger sidoId;
@end
