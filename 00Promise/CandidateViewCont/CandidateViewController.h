//
//  CandidateViewController.h
//  00Promise
//
//  Created by Rangken on 13. 9. 27..
//  Copyright (c) 2013년 SocialInovation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"
@interface CandidateViewController : SuperViewController <SuperViewControllerDelegate>
{
    NSInteger memoHeight;
}

@property (nonatomic, weak) IBOutlet UITableView* tableView;

@property (nonatomic, assign) NSInteger politicianId;
@property (nonatomic, strong) Politician* politician;

@end
