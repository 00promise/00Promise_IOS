//
//  SearchView.m
//  00Promise
//
//  Created by Rangken on 13. 9. 19..
//  Copyright (c) 2013년 SocialInovation. All rights reserved.
//

#import "SearchView.h"
#import "SearchPartyCell.h"
#import "CandidateCell.h"
#import "AppDelegate.h"
#import "UIColor+CreateMethods.h"
#import "BaseViewController.h"
#import "CandidateListViewController.h"
#import "CandidateViewController.h"
#import <FSExtendedAlertKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
@implementation SearchView

- (id) initWithCoder:(NSCoder *)aCoder{
    if(self = [super initWithCoder:aCoder]){
        [self initVariable];
        [self initView];
    }
    return self;
}
- (void)awakeFromNib{
    if (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height != 568.0f) {
        [_tableView setFrame:CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y, _tableView.frame.size.width, _tableView.frame.size.height-88)];
    }
    if (IS_UNDER_IOS7) {
        _tableView.frame = CGRectMake(0, 0, 320, 458);
    }
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    // create a new Search Bar and add it to the table view
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
    //[[UISearchBar appearance] setSearchFieldBackgroundImage:[UIImage imageNamed:@"search_bg01.png"] forState:UIControlStateNormal];
    //[[UISearchBar appearance] setImage:[UIImage imageNamed:@"search_icon01"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    _searchBar.backgroundColor = [UIColor clearColor];
    _searchBar.scopeBarBackgroundImage = nil;
    
    //_searchBar.backgroundImage = [UIImage imageNamed:@"search_bg01.png"];
    //[UIColor colorWithPatternImage:[UIImage imageNamed:@"search_icon01"]];
    _searchBar.placeholder = @"정치인 이름을 입력하세요";
    // we need to be the delegate so the cancel button works
    _searchBar.delegate = self.parentViewCont;
    
    // create the Search Display Controller with the above Search Bar
    _searchDisplayCont = [[UISearchDisplayController alloc]initWithSearchBar:_searchBar contentsController:(UIViewController *)self.parentViewCont];
    //_searchDisplayCont.displaysSearchBarInNavigationBar = YES;
    _searchDisplayCont.searchResultsDataSource = (id<UITableViewDataSource>)self.parentViewCont;
    _searchDisplayCont.searchContentsController.view.backgroundColor = [UIColor whiteColor];
    _searchDisplayCont.searchResultsTableView.backgroundColor = [UIColor whiteColor];
    _searchDisplayCont.searchResultsDelegate = (id<UITableViewDelegate>)self.parentViewCont;
    _searchDisplayCont.delegate = self.parentViewCont;
    _searchDisplayCont.searchResultsTableView.separatorColor = [UIColor clearColor];
    _tableView.tableHeaderView = _searchBar;
}
- (void)initVariable{
    _partyArr = [NSMutableArray new];
    _electionArr = [NSMutableArray new];
}
- (void)initView{
    [_partyArr removeAllObjects];
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    [[AFAppDotNetAPIClient sharedClient] getPath:@"parties.json" parameters:nil success:^(AFHTTPRequestOperation *response, id responseObject) {
#ifdef _SERVER_LOG_
        NSLog(@"manifestos/parties.json : %@",(NSDictionary *)responseObject);
#endif
        NSString* code = [responseObject objectForKey:@"code"];
        if (![code isEqualToString:@"0000"]) {
            FSBlockButton *cancelButton = [FSBlockButton blockButtonWithTitle:@"확인" block:^ {
                
            }];
            FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"에러" message:[responseObject objectForKey:@"message"] cancelButton:cancelButton otherButtons: nil];
            [alert show];
        }else{
            NSMutableArray* manifestoArr = [responseObject objectForKey:@"data"];
            for (NSDictionary* dic in manifestoArr) {
                NSDictionary* partyDic = [NSDictionary dictionaryWithObject:dic forKey:@"party"];
                Party* party = [Party new];
                [party setPropertiesUsingRemoteDictionary:partyDic];
                [_partyArr addObject:party];
            }
            [_tableView reloadData];
        }
        [MBProgressHUD hideHUDForView:self animated:YES];
    } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
        NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
        [MBProgressHUD hideHUDForView:self animated:YES];
    }];
    
    [[AFAppDotNetAPIClient sharedClient] getPath:@"elections.json" parameters:nil success:^(AFHTTPRequestOperation *response, id responseObject) {
#ifdef _SERVER_LOG_
        NSLog(@"manifestos/elections.json : %@",(NSDictionary *)responseObject);
#endif
        NSString* code = [responseObject objectForKey:@"code"];
        if (![code isEqualToString:@"0000"]) {
            FSBlockButton *cancelButton = [FSBlockButton blockButtonWithTitle:@"확인" block:^ {
                
            }];
            FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"에러" message:[responseObject objectForKey:@"message"] cancelButton:cancelButton otherButtons: nil];
            [alert show];
        }else{
            NSMutableArray* manifestoArr = [responseObject objectForKey:@"data"];
            for (NSDictionary* dic in manifestoArr) {
                NSDictionary* electionDic = [NSDictionary dictionaryWithObject:dic forKey:@"election"];
                Election* election = [Election new];
                [election setPropertiesUsingRemoteDictionary:electionDic];
                [_electionArr addObject:election];
            }
            [_tableView reloadData];
        }
        [MBProgressHUD hideHUDForView:self animated:YES];
    } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
        NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
        FSBlockButton *cancelButton = [FSBlockButton blockButtonWithTitle:@"예" block:^ {
            [self initView];
        }];
        FSBlockButton *okButton = [FSBlockButton blockButtonWithTitle:@"아니요" block:^ {
            
        }];
        FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"에러" message:@"다시 시도하시겠습니까?." cancelButton:cancelButton otherButtons:okButton, nil];
        [alert show];
        [MBProgressHUD hideHUDForView:self animated:YES];
    }];
}
// 검색에서 클릭했을때
- (void)searchCandidateClick:(int)politicianId{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    CandidateViewController* candidateViewCont = [storyboard instantiateViewControllerWithIdentifier:@"candidateViewController"];
    candidateViewCont.politicianId = politicianId;
    
    [((UIViewController *)self.parentViewCont).navigationController pushViewController:candidateViewCont animated:TRUE];
    
}

#pragma mark BaseViewDelegate
- (void)viewDidSlide{
    NSLog(@"viewDidSlide");
}

- (void)viewUnSilde{
}

#pragma mark UITableViewDelegate UITableViewDataSource
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 14, tableView.frame.size.width, 18)];
    [label setFont:[UIFont boldSystemFontOfSize:18]];
    label.textColor = [UIColor colorWithHex:@"#ed3917" alpha:1.0f];
    if (section == 0) {
        label.text = @"선거";
    }else if(section == 1){
        label.text = @"정당";
    }
    [view addSubview:label];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 43+1;
        }else if(indexPath.row == 1){
            return 44+1;
        }else{
            return 42+1;
        }
    }else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            return 43+1;
        }else if(indexPath.row == 4){
            return 44+1;
        }else{
            return 42+2;
        }
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return [_electionArr count];
    }
    return [_partyArr count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    SearchPartyCell *cell = (SearchPartyCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil){
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SearchPartyCell" owner:nil options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    UIImage *backImage;
    if (indexPath.row == 0) {
        backImage = [UIImage imageNamed:@"area_bg01.png"];
    }else if(indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1){
        backImage = [UIImage imageNamed:@"area_bg03.png"];
    }else{
        backImage = [UIImage imageNamed:@"area_bg02.png"];
    }
    cell.backImgView.image = [backImage stretchableImageWithLeftCapWidth:3 topCapHeight:3];
    
    if (indexPath.section == 0) {
        Election* election = [_electionArr objectAtIndex:indexPath.row];
        cell.partyLabel.text = election.name;
    }else{
        Party* party = [_partyArr objectAtIndex:indexPath.row];
        cell.partyLabel.text = party.name;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        CandidateListViewController* candidateListViewCont = [storyboard instantiateViewControllerWithIdentifier:@"candidateListViewController"];
        candidateListViewCont.electionId = 0;
        candidateListViewCont.candidateId = 0;
        Election* election = [_electionArr objectAtIndex:indexPath.row];
        candidateListViewCont.electionId = election.ID.integerValue;
        
        [((UIViewController *)self.parentViewCont).navigationController pushViewController:candidateListViewCont animated:TRUE];
    }else if (indexPath.section == 1){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        CandidateListViewController* candidateListViewCont = [storyboard instantiateViewControllerWithIdentifier:@"candidateListViewController"];
        candidateListViewCont.electionId = 0;
        candidateListViewCont.candidateId = 0;
        Party* party = [_partyArr objectAtIndex:indexPath.row];
        candidateListViewCont.candidateId =  party.ID.integerValue;
        [((UIViewController *)self.parentViewCont).navigationController pushViewController:candidateListViewCont animated:TRUE];
        //[(UIViewController *)self.parentViewCont performSegueWithIdentifier:@"GoCandidateListPush" sender:self];
    }
}
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    /*
     if (textField == _emailTextField) {
     [_scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x, 99.5f) animated:YES];
     }
     else if (textField == _passwordTextField) {
     [_scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x, 128.0f) animated:YES];
     }*/
//    if (_type == eSearchParty) {
//        _type = eSearchCandidate;
//        [_tableView reloadData];
//    }
    return TRUE;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{return YES;}
- (void)textFieldDidEndEditing:(UITextField *)textField
{}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{return YES;}
- (BOOL)textFieldShouldClear:(UITextField *)textField
{return YES;}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_searchTextField resignFirstResponder];
    return TRUE;
}


@end
