//
//  FavoriteLocationViewController.h
//  00Promise
//
//  Created by Rangken on 13. 9. 28..
//  Copyright (c) 2013년 SocialInovation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"
@interface FavoriteLocationViewController : SuperViewController <SuperViewControllerDelegate, UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) IBOutlet UITableView* tableView;
@property (nonatomic, strong) UISearchDisplayController *searchDisplayCont;
@property (nonatomic, strong) UISearchBar* searchBar;
@property (nonatomic, assign) NSInteger sidoId;
@property (nonatomic, strong) NSMutableArray* sigunguArr;
@property (nonatomic, strong) NSMutableArray* searchArr;
@end
