//
//  CandidateInfoCell.h
//  00Promise
//
//  Created by Rangken on 13. 9. 27..
//  Copyright (c) 2013년 SocialInovation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CandidateInfoCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UIImageView* backImgView;
@property (nonatomic, strong) IBOutlet UIImageView* bgImgView;
@property (nonatomic, strong) IBOutlet UIImageView* politicianImgView;
@property (nonatomic, strong) IBOutlet UILabel* nameLabel;
@property (nonatomic, strong) IBOutlet UILabel* birthLabel;
@property (nonatomic, strong) IBOutlet UILabel* positionLabel;
@property (nonatomic, strong) IBOutlet UILabel* positionHistoryLabel;
@end
