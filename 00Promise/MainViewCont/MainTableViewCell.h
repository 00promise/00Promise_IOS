//
//  MainTableViewCell.h
//  00Promise
//
//  Created by Digitalfrog on 13. 9. 12..
//  Copyright (c) 2013년 SocialInovation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIImageView* backImgView1;
@property (nonatomic, weak) IBOutlet UIImageView* backImgView2;
@property (nonatomic, weak) IBOutlet UIImageView* bgImgView;
@property (nonatomic, weak) IBOutlet UIImageView* candidateImgView;
@property (nonatomic, weak) IBOutlet UILabel* nameLabel;
@property (nonatomic, weak) IBOutlet UILabel* positioNameLabel;
@property (nonatomic, weak) IBOutlet UILabel* titleLabel;
@property (nonatomic, weak) IBOutlet UILabel* userNameLabel;
@property (nonatomic, weak) IBOutlet UILabel* createdAtLabel;
@property (nonatomic, weak) IBOutlet UILabel* contentLabel;
@property (nonatomic, weak) IBOutlet UILabel* replyCntLabel;

@property (nonatomic, weak) IBOutlet UIImageView* bannerImgView;
@property (nonatomic, weak) IBOutlet UILabel* bannerLabel;
@property (nonatomic, weak) IBOutlet UIImageView* lineImgView;
@property (nonatomic, weak) IBOutlet UIView* bottomView;
@end
