//
//  IssueBigTableViewCell.h
//  00Promise
//
//  Created by Rangken on 2015. 1. 28..
//  Copyright (c) 2015년 SocialInovation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IssueBigTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView* imgView;
@property (nonatomic, weak) IBOutlet UILabel* nameLabel;
@property (nonatomic, weak) IBOutlet UILabel* positionLabel;
@property (nonatomic, weak) IBOutlet UILabel* issueLabel;
@end
