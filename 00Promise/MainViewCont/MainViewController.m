//
//  MainViewController.m
//  00Promise
//
//  Created by Digitalfrog on 13. 9. 12..
//  Copyright (c) 2013년 SocialInovation. All rights reserved.
//

#import "MainViewController.h"
#import "MainTableViewCell.h"
@interface MainViewController ()

@end

@implementation MainViewController


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

- (void)viewDidAppear:(BOOL)animated{

}

- (void)initVariable{
    
}
- (void)initView{
    //    CGFloat navBarHeight = [self.navigationController.navigationBar sizeThatFits:self.view.bounds.size].height;
    //
    //    // Resizing navigationBar
    //    self.navigationController.navigationBar.frame = CGRectMake(0, 0, self.view.bounds.size.width, navBarHeight);
    [_tableView setContentInset:UIEdgeInsetsMake(10.0, 0.0, 0.0, 0.0)];
    
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
