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
@property (nonatomic, weak) IBOutlet UILabel* nameLabel;
@property (nonatomic, weak) IBOutlet UILabel* createdAtLabel;
@property (nonatomic, weak) IBOutlet UILabel* contentLabel;
@property (nonatomic, weak) IBOutlet UILabel* ratingAgreeLabel;
@property (nonatomic, weak) IBOutlet UILabel* ratingDisAgreeLabel;
@property (nonatomic, weak) IBOutlet UIButton* agreeBtn;
@property (nonatomic, weak) IBOutlet UIButton* disAgreeBtn;
@end
