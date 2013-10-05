//
//  SearchView.h
//  00Promise
//
//  Created by Rangken on 13. 9. 19..
//  Copyright (c) 2013년 SocialInovation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"

@interface SearchView : BaseView 
{
    
}
@property (nonatomic, weak) IBOutlet UITextField* searchTextField;
@property (nonatomic, weak) IBOutlet UITableView* tableView;
@property (nonatomic, strong) UISearchDisplayController *searchDisplayCont;
@property (nonatomic, strong) UISearchBar* searchBar;
@property (nonatomic, strong) NSMutableArray* electionArr;
@property (nonatomic, strong) NSMutableArray* partyArr;
- (void)searchCandidateClick:(int)idx;
@end
