//
//  SearchTableViewCell.m
//  00Promise
//
//  Created by Rangken on 2015. 1. 28..
//  Copyright (c) 2015년 SocialInovation. All rights reserved.
//

#import "SearchTableViewCell.h"
#import "SearchView.h"
@implementation SearchTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)addressReloadClick:(id)sender{
    [_searchView addressReloadClick:sender];
}

@end
