//
//  BaseViewController.h
//  00Promise
//
//  Created by Rangken on 13. 9. 18..
//  Copyright (c) 2013년 SocialInovation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"
#import "LocationView.h"
#import "MainView.h"
#import "SearchView.h"
@interface BaseViewController : SuperViewController <SuperViewControllerDelegate, UIScrollViewDelegate,  UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate >
{
    NSInteger searchBarY;
}
@property (nonatomic, weak) IBOutlet UIView* bottomNaviBarView;
@property (nonatomic, weak) IBOutlet UIScrollView* scrollView;
@property (nonatomic, weak) IBOutlet UIImageView* backBarImgView;
@property (nonatomic, weak) IBOutlet UIImageView* highlightBarImgView;
@property (nonatomic, strong) IBOutlet LocationView* locationView;
@property (nonatomic, strong) IBOutlet MainView* mainView;
@property (nonatomic, strong) IBOutlet SearchView* searchView;

@property (nonatomic, strong) NSMutableArray* searchArr;
@end
