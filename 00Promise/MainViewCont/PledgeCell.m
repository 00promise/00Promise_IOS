//
//  PledgeCell.m
//  00Promise
//
//  Created by Digitalfrog on 13. 9. 26..
//  Copyright (c) 2013년 SocialInovation. All rights reserved.
//

#import "PledgeCell.h"

@implementation PledgeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)theMoreClick:(id)sender
{
    [_parent theMoreClick:sender];
}

- (IBAction)ratingClick:(id)sender
{
    [_parent ratingClick:sender];
}
@end
