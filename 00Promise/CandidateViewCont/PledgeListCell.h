//
//  PledgeListCell.h
//  00Promise
//
//  Created by Rangken on 13. 9. 27..
//  Copyright (c) 2013년 SocialInovation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PledgeListCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIImageView* backImgView;
@property (nonatomic, weak) IBOutlet UILabel* titleLabel;
@property (nonatomic, weak) IBOutlet UIImageView* ratingImgView;
@property (nonatomic, weak) IBOutlet UILabel* ratingCntLabel;
@property (nonatomic, weak) IBOutlet UILabel* replyCntLabel;
@end
