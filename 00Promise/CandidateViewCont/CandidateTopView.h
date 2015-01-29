//
//  CandidateTopView.h
//  00Promise
//
//  Created by Rangken on 2015. 1. 29..
//  Copyright (c) 2015년 SocialInovation. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CandidateViewController;
@interface CandidateTopView : UIView
@property (nonatomic, weak) IBOutlet CandidateViewController* parent;
@property (nonatomic, weak) IBOutlet UIImageView* backImgView;
@property (nonatomic, weak) IBOutlet UIImageView* profileImgView;
@property (nonatomic, weak) IBOutlet UILabel* nameLabel;
@property (nonatomic, weak) IBOutlet UILabel* positionLabel;
@end
