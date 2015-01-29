//
//  CandidateListViewController.h
//  00Promise
//
//  Created by Rangken on 13. 9. 27..
//  Copyright (c) 2013년 SocialInovation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"
typedef enum {
    CandidateListLocation,
    CandidateListParty,
    CandidateListElection,
    CandidateListName
}CandidateListType;
@interface CandidateListViewController : SuperViewController <SuperViewControllerDelegate>
{
    int page;
}
@property (nonatomic, weak) IBOutlet UITableView* tableView;

@property (nonatomic, retain) IBOutlet UIView *activityIndicatorView;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;

@property (nonatomic, strong) NSMutableArray* candidateArr;
@property (nonatomic, assign) CandidateListType type;
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, strong) NSString* titleTxt;
@end
