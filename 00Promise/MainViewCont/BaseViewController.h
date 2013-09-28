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
@property (nonatomic, strong) IBOutlet UIView* bottomNaviBarView;
@property (nonatomic, strong) IBOutlet UIScrollView* scrollView;
@property (nonatomic, strong) IBOutlet UIImageView* backBarImgView;
@property (nonatomic, strong) IBOutlet UIImageView* highlightBarImgView;
@property (nonatomic, strong) IBOutlet LocationView* locationView;
@property (nonatomic, strong) IBOutlet MainView* mainView;
@property (nonatomic, strong) IBOutlet SearchView* searchView;

@property (nonatomic, strong) NSMutableArray* searchArr;
@end
