//
//  HotIssueView.h
//  00Promise
//
//  Created by Rangken on 2015. 1. 28..
//  Copyright (c) 2015년 SocialInovation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
@interface HotIssueView : BaseView
@property (nonatomic, strong) NSMutableArray* issueArr;
@property (nonatomic, strong) IBOutlet UITableView* tableView;
- (void)initView;
@end
