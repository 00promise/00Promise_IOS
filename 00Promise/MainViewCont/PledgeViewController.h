//
//  PledgeViewController.h
//  00Promise
//
//  Created by Digitalfrog on 13. 9. 25..
//  Copyright (c) 2013년 SocialInovation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"
@interface PledgeViewController : SuperViewController <SuperViewControllerDelegate, UITextViewDelegate>
{
    int theMoreHeight;
    float keyboardY;
}
@property (nonatomic, strong) UIView* keyboardView;
@property (nonatomic, strong) IBOutlet UITableView* tableView;
@property (nonatomic,retain) IBOutlet UIView *activityIndicatorView;
@property (nonatomic,retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) IBOutlet UITextView* textView;
@property (nonatomic, assign) NSInteger manifestoId;
@property (nonatomic, strong) Manifesto* manifesto;
@property (nonatomic, strong) NSMutableArray* replyArr;
- (IBAction)theMoreClick:(id)sender;
- (IBAction)ratingClick:(id)sender;
- (IBAction)reportClick:(id)sender;
@end
