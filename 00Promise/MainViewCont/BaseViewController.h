//
//  BaseViewController.h
//  00Promise
//
//  Created by Rangken on 13. 9. 18..
//  Copyright (c) 2013년 SocialInovation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"

#import "HotIssueView.h"
#import "SearchView.h"
typedef enum{
    BaseViewIssue,
    BaseViewSearch
}BaseViewType;
@interface BaseViewController : SuperViewController
{
}
@property (nonatomic, strong) IBOutlet HotIssueView* hotIssueView;
@property (nonatomic, strong) IBOutlet SearchView* searchView;
@property (nonatomic, assign) BaseViewType type;
@end
