//
//  CandidateTopView.m
//  00Promise
//
//  Created by Rangken on 2015. 1. 29..
//  Copyright (c) 2015년 SocialInovation. All rights reserved.
//

#import "CandidateTopView.h"
#import "CandidateViewController.h"
@implementation CandidateTopView

- (IBAction)backItemClick:(id)sender
{
    [_parent backItemClick:sender];
}
- (IBAction)shareClick:(id)sender
{
    [_parent shareClick:sender];
}
@end
