//
//  CandidateCell.h
//  00Promise
//
//  Created by Digitalfrog on 13. 9. 25..
//  Copyright (c) 2013년 SocialInovation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CandidateCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView* backImgView;
@property (nonatomic, strong) IBOutlet UIImageView* profileImgView;
@property (nonatomic, strong) IBOutlet UILabel* nameLabel;
@property (nonatomic, strong) IBOutlet UILabel* positionLabel;
@property (nonatomic, strong) IBOutlet UILabel* contentLabel;
@end
