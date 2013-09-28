//
//  PledgeCell.h
//  00Promise
//
//  Created by Digitalfrog on 13. 9. 26..
//  Copyright (c) 2013년 SocialInovation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PledgeViewController.h"
@interface PledgeCell : UITableViewCell
@property (nonatomic, strong) PledgeViewController* parent;
@property (nonatomic, strong) IBOutlet UIImageView* bgImgView;
@property (nonatomic, strong) IBOutlet UIImageView* candidateImgView;
@property (nonatomic, strong) IBOutlet UILabel* nameLabel;
@property (nonatomic, strong) IBOutlet UILabel* positionLabel;
@property (nonatomic, strong) IBOutlet UILabel* titleLabel;
@property (nonatomic, strong) IBOutlet UILabel* goodCntLabel;
@property (nonatomic, strong) IBOutlet UILabel* fairCntLabel;
@property (nonatomic, strong) IBOutlet UILabel* poorCntLabel;
@property (nonatomic, strong) IBOutlet UILabel* replyCntLabel;

@property (nonatomic, strong) IBOutlet UILabel* manifestoLabel;


@end
