//
//  CandidateListViewController.h
//  00Promise
//
//  Created by Rangken on 13. 9. 27..
//  Copyright (c) 2013년 SocialInovation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"
@interface CandidateListViewController : SuperViewController <SuperViewControllerDelegate>
{
    int page;
}
@property (nonatomic, weak) IBOutlet UITableView* tableView;

@property (nonatomic, retain) IBOutlet UIView *activityIndicatorView;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;

@property (nonatomic, strong) NSMutableArray* candidateArr;
@property (nonatomic, assign) NSInteger electionId;
@property (nonatomic, assign) NSInteger candidateId;
@end
