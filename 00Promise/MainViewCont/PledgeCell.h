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
@property (nonatomic, weak) IBOutlet UIImageView* bgImgView;
@property (nonatomic, weak) IBOutlet UIImageView* candidateImgView;
@property (nonatomic, weak) IBOutlet UILabel* nameLabel;
@property (nonatomic, weak) IBOutlet UILabel* positionLabel;
@property (nonatomic, weak) IBOutlet UILabel* titleLabel;
@property (nonatomic, weak) IBOutlet UILabel* goodCntLabel;
@property (nonatomic, weak) IBOutlet UILabel* fairCntLabel;
@property (nonatomic, weak) IBOutlet UILabel* poorCntLabel;
@property (nonatomic, weak) IBOutlet UILabel* replyCntLabel;
@property (nonatomic, weak) IBOutlet UILabel* theMoreLabel;
@property (nonatomic, weak) IBOutlet UILabel* manifestoLabel;

@property (nonatomic, weak) IBOutlet UIButton* goodBtn;
@property (nonatomic, weak) IBOutlet UIButton* fairBtn;
@property (nonatomic, weak) IBOutlet UIButton* poorBtn;
@end
