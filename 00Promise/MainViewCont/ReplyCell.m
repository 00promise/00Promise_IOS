//
//  ReplyCell.m
//  00Promise
//
//  Created by Digitalfrog on 13. 9. 25..
//  Copyright (c) 2013년 SocialInovation. All rights reserved.
//

#import "ReplyCell.h"
#import "PledgeViewController.h"
@implementation ReplyCell

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

- (IBAction)reportClick:(id)sender
{
    [_parent reportClick:sender];
}
- (IBAction)agreeClick:(id)sender
{
    [_parent agreeClick:sender];
}
- (IBAction)disAgreeClick:(id)sender
{
    [_parent disAgreeClick:sender];
}
@end
