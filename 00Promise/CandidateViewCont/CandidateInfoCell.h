//
//  CandidateInfoCell.h
//  00Promise
//
//  Created by Rangken on 13. 9. 27..
//  Copyright (c) 2013년 SocialInovation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CandidateInfoCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIImageView* backImgView;
@property (nonatomic, weak) IBOutlet UIImageView* bgImgView;
@property (nonatomic, weak) IBOutlet UIImageView* politicianImgView;
@property (nonatomic, weak) IBOutlet UILabel* nameLabel;
@property (nonatomic, weak) IBOutlet UILabel* birthLabel;
@property (nonatomic, weak) IBOutlet UILabel* positionLabel;
@property (nonatomic, weak) IBOutlet UILabel* positionHistoryLabel;
@end
