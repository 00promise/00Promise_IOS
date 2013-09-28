//
//  PledgeListCell.h
//  00Promise
//
//  Created by Rangken on 13. 9. 27..
//  Copyright (c) 2013년 SocialInovation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PledgeListCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UIImageView* backImgView;
@property (nonatomic, strong) IBOutlet UILabel* titleLabel;
@property (nonatomic, strong) IBOutlet UIImageView* ratingImgView;
@property (nonatomic, strong) IBOutlet UILabel* ratingCntLabel;
@property (nonatomic, strong) IBOutlet UILabel* replyCntLabel;
@end
