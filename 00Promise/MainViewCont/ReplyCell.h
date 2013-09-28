//
//  ReplyCell.h
//  00Promise
//
//  Created by Digitalfrog on 13. 9. 25..
//  Copyright (c) 2013년 SocialInovation. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PledgeViewController;
@interface ReplyCell : UITableViewCell
@property (nonatomic, strong) PledgeViewController* parent;
@property (nonatomic, strong) IBOutlet UIImageView* bestImgView;
@property (nonatomic, strong) IBOutlet UILabel* nameLabel;
@property (nonatomic, strong) IBOutlet UILabel* createdAtLabel;
@property (nonatomic, strong) IBOutlet UILabel* contentLabel;
@property (nonatomic, strong) IBOutlet UILabel* ratingAgreeLabel;
@property (nonatomic, strong) IBOutlet UILabel* ratingDisAgreeLabel;
@end
