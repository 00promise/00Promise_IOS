//
//  OTCover.h
//  OTMediumCover
//
//  Created by yechunxiao on 14-9-21.
//  Copyright (c) 2014年 yechunxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
//#define OTCoverViewHeight 200

@interface OTCover : UIView

@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) UIView* scrollContentView;
@property (nonatomic, strong) UIView* headerView;
@property (nonatomic, strong) UITableView* tableView;

- (OTCover*)initWithTableViewWithHeaderView:(UIView*)headereView withOTCoverHeight:(CGFloat)height;
- (OTCover*)initWithScrollViewWithHeaderView:(UIView*)headerView withOTCoverHeight:(CGFloat)height withScrollContentViewHeight:(CGFloat)height;
- (void)setHeaderImage:(UIImage *)headerImage;

@end

@interface UIImage (Blur)
-(UIImage *)boxblurImageWithBlur:(CGFloat)blur;
@end

// Copyright belongs to original author
// http://code4app.net (en) http://code4app.com (cn)
// From the most professional code share website: Code4App.net
