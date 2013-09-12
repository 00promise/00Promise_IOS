//
//  SuperViewController.h
//  00Promise
//
//  Created by Digitalfrog on 13. 9. 12..
//  Copyright (c) 2013년 SocialInovation. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SuperViewControllerDelegate <NSObject>
@optional
- (void)initVariable;
- (void)initView;
@end

@interface SuperViewController : UIViewController

@property (nonatomic, assign) id<SuperViewControllerDelegate> delegate;
@end
