//
//  MainViewController.h
//  00Promise
//
//  Created by Digitalfrog on 13. 9. 12..
//  Copyright (c) 2013년 SocialInovation. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface MainViewController : UIViewController < UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView* tableView;
@end
