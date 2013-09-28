//
//  SuperViewController.h
//  00Promise
//
//  Created by Digitalfrog on 13. 9. 12..
//  Copyright (c) 2013년 SocialInovation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "AFAppDotNetAPIClient.h"
#import "Models.h"
#import "UIColor+CreateMethods.h"
#import "MBProgressHUD.h"
@protocol SuperViewControllerDelegate <NSObject>
@optional
- (void)initVariable;
- (void)initView;
- (void)leftItemClick;
- (void)rightItemClick;
- (void)backItemClick;
@end

@interface SuperViewController : UIViewController <SuperViewControllerDelegate>
{
    UILabel* titleLabel;
    UIImageView* titleImgView;
}
@property (nonatomic, assign) id<SuperViewControllerDelegate> delegate;
- (void)setTitleLabelStr:(NSString *)str;
@end
