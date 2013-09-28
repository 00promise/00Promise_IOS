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
@property (nonatomic, strong) IBOutlet UIImageView* backImgView;
@property (nonatomic, strong) IBOutlet UILabel* partyLabel;
@property (nonatomic, strong) IBOutlet UIImageView* arrowImgView;
@property (nonatomic, strong) IBOutlet UIImageView* checkImgView;

@end
