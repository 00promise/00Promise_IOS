//
//  SearchListViewController.m
//  00Promise
//
//  Created by Rangken on 2015. 1. 29..
//  Copyright (c) 2015년 SocialInovation. All rights reserved.
//

#import "SearchListViewController.h"
#import "CandidateListViewController.h"
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
    }else if (_type == SearchListParty) {
        [self setTitleLabelStr:@"정당으로 지역"];
    }else if (_type == SearchListElection) {
        [self setTitleLabelStr:@"선거로 찾기"];
    }else if (_type == SearchListLocationDetail) {
        [self setTitleLabelStr:@"우리 지역 찾기"];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[AFAppDotNetAPIClient sharedClient] getPath:[NSString stringWithFormat:@"district/sidos/%ld/sigungus.json",_sidoId] parameters:nil success:^(AFHTTPRequestOperation *response, id responseObject) {
#ifdef _SERVER_LOG_
            NSLog(@"district/sidos/@id/sigungus.json: %@",(NSDictionary *)responseObject);
#endif
            NSString* code = [responseObject objectForKey:@"code"];
            if (![code isEqualToString:@"0000"]) {
                
            }else{
                _array = [NSMutableArray new];
                NSMutableArray* sidoArr = [responseObject objectForKey:@"data"];
                for (NSDictionary* dic in sidoArr) {
                    NSDictionary* sidoDic = [NSDictionary dictionaryWithObject:dic forKey:@"sigungu"];
                    Sigungu* sigungu = [Sigungu new];
                    [sigungu setPropertiesUsingRemoteDictionary:sidoDic];
                    [_array addObject:sigungu];
                }
                [_tableView reloadData];
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
#ifdef _SERVER_LOG_
            NSLog(@"district/sidos/@id/sigungus.json [HTTPClient Error]: %@", error.localizedDescription);
#endif
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
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
        Sigungu* sigungu = [_array objectAtIndex:indexPath.row];
        cell.nameLabel.text = sigungu.name;
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
    if (_type == SearchListLocation) {
        Sido* sido = [_array objectAtIndex:indexPath.row];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        SearchListViewController* searchListViewCont = [storyboard instantiateViewControllerWithIdentifier:@"searchListViewController"];
        searchListViewCont.type = SearchListLocationDetail;
        searchListViewCont.sidoId = sido.ID.integerValue;
        [self.navigationController pushViewController:searchListViewCont animated:TRUE];
    }else if (_type == SearchListLocationDetail) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        CandidateListViewController* candidateListViewCont = [storyboard instantiateViewControllerWithIdentifier:@"candidateListViewController"];
        candidateListViewCont.type = CandidateListLocation;
        Sigungu* sigungu = [_array objectAtIndex:indexPath.row];
        candidateListViewCont.ID = sigungu.ID.integerValue;
        candidateListViewCont.titleTxt = sigungu.name;
        [self.navigationController pushViewController:candidateListViewCont animated:TRUE];
    }else if (_type == SearchListParty) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        CandidateListViewController* candidateListViewCont = [storyboard instantiateViewControllerWithIdentifier:@"candidateListViewController"];
        Party* party = [_array objectAtIndex:indexPath.row];
        candidateListViewCont.type = CandidateListParty;
        candidateListViewCont.ID = party.ID.integerValue;
        candidateListViewCont.titleTxt = party.name;
        [self.navigationController pushViewController:candidateListViewCont animated:TRUE];
    }else if (_type == SearchListElection) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        CandidateListViewController* candidateListViewCont = [storyboard instantiateViewControllerWithIdentifier:@"candidateListViewController"];
        candidateListViewCont.type = CandidateListElection;
        Election* election = [_array objectAtIndex:indexPath.row];
        candidateListViewCont.ID = election.ID.integerValue;
        candidateListViewCont.titleTxt = election.name;
        [self.navigationController pushViewController:candidateListViewCont animated:TRUE];
    }
}

@end
