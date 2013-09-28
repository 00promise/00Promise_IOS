//
//  MainView.h
//  00Promise
//
//  Created by Rangken on 13. 9. 19..
//  Copyright (c) 2013년 SocialInovation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
@interface MainView : BaseView < UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView* tableView;

@property (nonatomic, strong) NSMutableArray* mainManifestoArr;
@end
