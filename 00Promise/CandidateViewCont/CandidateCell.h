//
//  CandidateCell.h
//  00Promise
//
//  Created by Digitalfrog on 13. 9. 25..
//  Copyright (c) 2013년 SocialInovation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CandidateCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView* profileImgView;
@property (nonatomic, weak) IBOutlet UILabel* nameLabel;
@property (nonatomic, weak) IBOutlet UILabel* positionLabel;
@end
