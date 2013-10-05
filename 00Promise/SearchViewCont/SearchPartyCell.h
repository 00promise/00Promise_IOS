//
//  SearchPartyCell.h
//  00Promise
//
//  Created by Digitalfrog on 13. 9. 25..
//  Copyright (c) 2013년 SocialInovation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchView.h"
@interface SearchPartyCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIImageView* backImgView;
@property (nonatomic, weak) IBOutlet UILabel* partyLabel;
@property (nonatomic, weak) IBOutlet UIImageView* arrowImgView;
@property (nonatomic, weak) IBOutlet UIImageView* checkImgView;

@end
