//
//  LocationViewController.h
//  00Promise
//
//  Created by Rangken on 13. 9. 18..
//  Copyright (c) 2013년 SocialInovation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"
@interface LocationViewController : SuperViewController <SuperViewControllerDelegate, UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) IBOutlet UITableView* tableView;
@property (nonatomic, strong) UISearchDisplayController *searchDisplayCont;
@property (nonatomic, strong) UISearchBar* searchBar;

@property (nonatomic, strong) NSMutableArray* sidoArr;
@property (nonatomic, strong) NSMutableArray* searchArr;
@end
