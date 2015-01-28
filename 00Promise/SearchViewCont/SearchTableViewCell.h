//
//  SearchTableViewCell.h
//  00Promise
//
//  Created by Rangken on 2015. 1. 28..
//  Copyright (c) 2015년 SocialInovation. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SearchView;
@interface SearchTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView* imgView;
@property (nonatomic, weak) IBOutlet UILabel* label;
@property (nonatomic, weak) IBOutlet UILabel* addressLabel;
@property (nonatomic, weak) IBOutlet UIButton* btn;
@property (nonatomic, weak) SearchView* searchView;
@end
