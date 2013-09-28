//
//  MiddleViewController.m
//  00Promise
//
//  Created by Digitalfrog on 13. 9. 12..
//  Copyright (c) 2013년 SocialInovation. All rights reserved.
//

#import "MiddleViewController.h"
#import "MainTableViewCell.h"
#import "LocationViewController.h"
#import "SearchViewController.h"
@interface MiddleViewController ()

@end

@implementation MiddleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}
- (void)initVariable{
}

- (void)initView{
    [_tableView setContentInset:UIEdgeInsetsMake(10.0, 0.0, 0.0, 0.0)];
}

- (void)leftItemClick{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    LocationViewController* locationViewCont = [storyboard instantiateViewControllerWithIdentifier:@"locationViewController"];
    UIViewController *src = (UIViewController *) self;
    UIViewController *dst = (UIViewController *) locationViewCont;
    [UIView transitionFromView:src.view
                        toView:dst.view
                      duration:1
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    completion:nil];
    [UIView transitionFromView:src.navigationItem.titleView
                        toView:dst.navigationItem.titleView
                      duration:1
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    completion:nil];
    [src.navigationController pushViewController:dst animated:NO];

    
    /*
    CATransition *animation = [CATransition animation];
    [self.navigationController pushViewController:locationViewCont animated:NO];
    [animation setDuration:0.45];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromRight];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [locationViewCont.view.layer addAnimation:animation forKey:@"SwitchToView1"];
     */
}

- (void)rightItemClick{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    SearchViewController* locationNaviViewCont = [storyboard instantiateViewControllerWithIdentifier:@"searchViewController"];
    [self.navigationController pushViewController:locationNaviViewCont animated:TRUE];
}

#pragma mark UITableViewDelegate UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 296;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    MainTableViewCell *cell = (MainTableViewCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"MainTableViewCell" owner:nil options:nil];
        cell = [topLevelObjects objectAtIndex:0];
        
    }
    [cell setFrame:CGRectMake(10, 0, 300, 296)];
    return cell;
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
