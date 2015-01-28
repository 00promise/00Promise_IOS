//
//  SearchListViewController.m
//  00Promise
//
//  Created by Rangken on 2015. 1. 29..
//  Copyright (c) 2015년 SocialInovation. All rights reserved.
//

#import "SearchListViewController.h"
#import "SearchCell.h"
#import "Models.h"
@interface SearchListViewController ()
@property (nonatomic, weak) IBOutlet UITableView* tableView;
@end

@implementation SearchListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_type == SearchListLocation) {
        [self setTitleLabelStr:@"우리 지역 찾기"];
    }else if (_type == SearchListLocationDetail) {
        [self setTitleLabelStr:@"우리 지역 찾기"];
    }else if (_type == SearchListParty) {
        [self setTitleLabelStr:@"정당으로 지역"];
    }else if (_type == SearchListElection) {
        [self setTitleLabelStr:@"선거로 찾기"];
    }
    [self setTitleLabelStr:@"다른 지역"];
}
- (void)backItemClick{
    [self.navigationController popViewControllerAnimated:TRUE];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark UITableViewDelegate UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_array count];;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    SearchCell *cell = (SearchCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SearchCell" owner:nil options:nil];
        cell = [topLevelObjects objectAtIndex:0];
        
    }
    if (_type == SearchListLocation) {
        Sido* sido = [_array objectAtIndex:indexPath.row];
        cell.nameLabel.text = sido.name;
    }else if (_type == SearchListLocationDetail) {
        
    }else if (_type == SearchListParty) {
        Party* party = [_array objectAtIndex:indexPath.row];
        cell.nameLabel.text = party.name;
    }else if (_type == SearchListElection) {
        Election* election = [_array objectAtIndex:indexPath.row];
        cell.nameLabel.text = election.name;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

@end
