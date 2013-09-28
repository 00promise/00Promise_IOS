//
//  MainTableViewCell.h
//  00Promise
//
//  Created by Digitalfrog on 13. 9. 12..
//  Copyright (c) 2013년 SocialInovation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTableViewCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UIImageView* backImgView1;
@property (nonatomic, strong) IBOutlet UIImageView* backImgView2;
@property (nonatomic, strong) IBOutlet UIImageView* bgImgView;
@property (nonatomic, strong) IBOutlet UIImageView* candidateImgView;
@property (nonatomic, strong) IBOutlet UILabel* nameLabel;
@property (nonatomic, strong) IBOutlet UILabel* positioNameLabel;
@property (nonatomic, strong) IBOutlet UILabel* titleLabel;
@property (nonatomic, strong) IBOutlet UILabel* userNameLabel;
@property (nonatomic, strong) IBOutlet UILabel* createdAtLabel;
@property (nonatomic, strong) IBOutlet UILabel* contentLabel;
@property (nonatomic, strong) IBOutlet UILabel* replyCntLabel;

@property (nonatomic, strong) IBOutlet UIImageView* bannerImgView;
@property (nonatomic, strong) IBOutlet UILabel* bannerLabel;
@end
