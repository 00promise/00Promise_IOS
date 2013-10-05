//
//  FavoriteLocationViewController.m
//  00Promise
//
//  Created by Rangken on 13. 9. 28..
//  Copyright (c) 2013년 SocialInovation. All rights reserved.
//

#import "FavoriteLocationViewController.h"
#import "SearchViewController.h"
#import "SearchPartyCell.h"
#import "BaseViewController.h"
#import <FSExtendedAlertKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
@interface FavoriteLocationViewController ()

@end

@implementation FavoriteLocationViewController

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
	// Do any additional setup after loading the view.
}
- (void)initVariable{
    _sigunguArr = [NSMutableArray new];
    _searchArr = [NSMutableArray new];
}
- (void)initView{
    [self setTitleLabelStr:@"서울특별시"];
    if (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height != 568.0f) {
        //[_tableView setFrame:CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y, _tableView.frame.size.width, _tableView.frame.size.height-88)];
    }
    if (IS_UNDER_IOS7) {
        //_tableView.frame = CGRectMake(0, 0, 320, 478);
    }
    // create a new Search Bar and add it to the table view
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
    //[[UISearchBar appearance] setSearchFieldBackgroundImage:[UIImage imageNamed:@"search_bg01.png"] forState:UIControlStateNormal];
    //[[UISearchBar appearance] setImage:[UIImage imageNamed:@"search_icon01"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    _searchBar.backgroundColor = [UIColor clearColor];
    _searchBar.scopeBarBackgroundImage = nil;
    
    //_searchBar.backgroundImage = [UIImage imageNamed:@"search_bg01.png"];
    //[UIColor colorWithPatternImage:[UIImage imageNamed:@"search_icon01"]];
    _searchBar.placeholder = @"시군구를 입력하세요";
    // we need to be the delegate so the cancel button works
    _searchBar.delegate = self;
    
    // create the Search Display Controller with the above Search Bar
    _searchDisplayCont = [[UISearchDisplayController alloc]initWithSearchBar:_searchBar contentsController:self];
    //_searchDisplayCont.displaysSearchBarInNavigationBar = YES;
    _searchDisplayCont.searchResultsDataSource = (id<UITableViewDataSource>)self;
    _searchDisplayCont.searchContentsController.view.backgroundColor = [UIColor whiteColor];
    _searchDisplayCont.searchResultsTableView.backgroundColor = [UIColor whiteColor];
    _searchDisplayCont.searchResultsDelegate = (id<UITableViewDelegate>)self;
    _searchDisplayCont.delegate = self;
    _searchDisplayCont.searchResultsTableView.separatorColor = [UIColor clearColor];
    _tableView.tableHeaderView = _searchBar;
    
    [_sigunguArr removeAllObjects];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[AFAppDotNetAPIClient sharedClient] getPath:[NSString stringWithFormat:@"district/sidos/%d/sigungus.json",_sidoId] parameters:nil success:^(AFHTTPRequestOperation *response, id responseObject) {
#ifdef _SERVER_LOG_
        NSLog(@"api/district/sidos/@id/sigungus.json: %@",(NSDictionary *)responseObject);
#endif
        NSString* code = [responseObject objectForKey:@"code"];
        if (![code isEqualToString:@"0000"]) {
            FSBlockButton *cancelButton = [FSBlockButton blockButtonWithTitle:@"확인" block:^ {
            }];
            FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"에러" message:[responseObject objectForKey:@"message"] cancelButton:cancelButton otherButtons: nil];
            [alert show];
        }else{
            NSMutableArray* sidoArr = [responseObject objectForKey:@"data"];
            for (NSDictionary* dic in sidoArr) {
                NSDictionary* sidoDic = [NSDictionary dictionaryWithObject:dic forKey:@"sigungu"];
                Sigungu* sigungu = [Sigungu new];
                [sigungu setPropertiesUsingRemoteDictionary:sidoDic];
                [_sigunguArr addObject:sigungu];
            }
            [_tableView reloadData];
        }
        [_tableView setHidden:FALSE];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
        NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
        FSBlockButton *cancelButton = [FSBlockButton blockButtonWithTitle:@"확인" block:^ {
            [self.navigationController popViewControllerAnimated:TRUE];
        }];
        FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"에러" message:@"정보를 가져올수 없습니다." cancelButton:cancelButton otherButtons: nil];
        [alert show];
        [_tableView setHidden:FALSE];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
- (void)backItemClick{
    [self.navigationController popViewControllerAnimated:TRUE];
}

#pragma mark UITableViewDelegate UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 12;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 12)];
    [view setBackgroundColor:[UIColor clearColor]];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 12;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 12)];
    [view setBackgroundColor:[UIColor clearColor]];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 44;
    }else{
        if (indexPath.row == 0) {
            return 43+1;
        }else if(indexPath.row == 9){
            return 44+1;
        }else{
            return 42+2;
        }
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [_searchArr count];
    }else{
        return [_sigunguArr count];
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        SearchPartyCell *cell = (SearchPartyCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil){
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SearchPartyCell" owner:nil options:nil];
            cell = [topLevelObjects objectAtIndex:0];
        }
        Sigungu* sigungu = [_searchArr objectAtIndex:indexPath.row];
        
        UIImage *backImage;
        if (indexPath.row == 0) {
            backImage = [UIImage imageNamed:@"area_bg01.png"];
        }else if(indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1){
            backImage = [UIImage imageNamed:@"area_bg03.png"];
        }else{
            backImage = [UIImage imageNamed:@"area_bg02.png"];
        }
        cell.backImgView.image = [backImage stretchableImageWithLeftCapWidth:3 topCapHeight:3];
        
        cell.partyLabel.text = sigungu.fullName;
        [cell.arrowImgView setHidden:TRUE];
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"locationCode"] == sigungu.code.integerValue &&
            [[[NSUserDefaults standardUserDefaults] objectForKey:@"locationName"] isEqualToString:sigungu.name]) {
            [cell.checkImgView setHidden:FALSE];
        }else{
            [cell.checkImgView setHidden:TRUE];
        }
        return cell;
    }else{
        SearchPartyCell *cell = (SearchPartyCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil){
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SearchPartyCell" owner:nil options:nil];
            cell = [topLevelObjects objectAtIndex:0];
        }
        Sigungu* sigungu = [_sigunguArr objectAtIndex:indexPath.row];
        
        UIImage *backImage;
        if (indexPath.row == 0) {
            backImage = [UIImage imageNamed:@"area_bg01.png"];
        }else if(indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1){
            backImage = [UIImage imageNamed:@"area_bg03.png"];
        }else{
            backImage = [UIImage imageNamed:@"area_bg02.png"];
        }
        cell.backImgView.image = [backImage stretchableImageWithLeftCapWidth:3 topCapHeight:3];
        
        cell.partyLabel.text = sigungu.fullName;
        [cell.arrowImgView setHidden:TRUE];
        
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"locationCode"] == sigungu.code.integerValue &&
            [[[NSUserDefaults standardUserDefaults] objectForKey:@"locationName"] isEqualToString:sigungu.name]) {
            [cell.checkImgView setHidden:FALSE];
        }else{
            [cell.checkImgView setHidden:TRUE];
        }
        return cell;
    }
    
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Sigungu* sigungu = NULL;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
         sigungu = [_searchArr objectAtIndex:indexPath.row];
    }else{
         sigungu = [_sigunguArr objectAtIndex:indexPath.row];
    }
    
    [[NSUserDefaults standardUserDefaults] setInteger:sigungu.code.integerValue forKey:@"locationCode"];
    [[NSUserDefaults standardUserDefaults] setValue:sigungu.fullName forKey:@"locationName"];
    BaseViewController* baseViewCont = [[self.navigationController viewControllers] objectAtIndex:0];
    [[NSUserDefaults standardUserDefaults] setInteger:sigungu.ID.integerValue forKey:@"sigunguId"];
    [baseViewCont.locationView reloadLocation:sigungu.ID.integerValue :sigungu.fullName];
    [self.navigationController popToRootViewControllerAnimated:TRUE];
}
#pragma mark UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    _tableView.allowsSelection = NO;
    _tableView.scrollEnabled = NO;
    
    searchBar.scopeButtonTitles = nil;
    searchBar.showsScopeBar = NO;
    
    UIButton *cancelButton;
    if (IS_IOS7) {
        UIView *topView = _searchDisplayCont.searchBar.subviews[0];
        for (UIView *subView in topView.subviews) {
            if ([subView isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
                cancelButton = (UIButton*)subView;
            }
        }
    }else{
        for (UIView *subView in _searchDisplayCont.searchBar.subviews) {
            if ([subView isKindOfClass:NSClassFromString(@"UIButton")]) {
                cancelButton = (UIButton*)subView;
            }
        }
    }
    if (cancelButton){
        //Set the new title of the cancel button
        [cancelButton setTitle:@"취소" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor colorWithHex:@"#FF4723" alpha:1.0f] forState:UIControlStateNormal];
        
        //[cancelButton setBackgroundColor:[UIColor colorWithHex:@"#FF4723" alpha:1.0f]];
        //[cancelButton setImage:[UIImage imageNamed:@"cancel_btn.png"] forState:UIControlStateNormal];
    }
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar; {
    
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"SEARCH TEXT :%@",searchText);
    
    [[[AFAppDotNetAPIClient sharedClient] operationQueue] cancelAllOperations];
    [_searchArr removeAllObjects];
    NSDictionary* params = [NSDictionary dictionaryWithObject:searchText forKey:@"q"];
    [[AFAppDotNetAPIClient sharedClient] getPath:@"district/search.json" parameters:params success:^(AFHTTPRequestOperation *response, id responseObject) {
#ifdef _SERVER_LOG_
        NSLog(@"district/search.json: %@",(NSDictionary *)responseObject);
#endif
        NSString* code = [responseObject objectForKey:@"code"];
        if (![code isEqualToString:@"0000"]) {
            FSBlockButton *cancelButton = [FSBlockButton blockButtonWithTitle:@"확인" block:^ {
            }];
            FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"에러" message:[responseObject objectForKey:@"message"] cancelButton:cancelButton otherButtons: nil];
            [alert show];
        }else{
            NSMutableArray* sidoArr = [responseObject objectForKey:@"data"];
            for (NSDictionary* dic in sidoArr) {
                NSDictionary* sidoDic = [NSDictionary dictionaryWithObject:dic forKey:@"sigungu"];
                Sigungu* sigungu = [Sigungu new];
                [sigungu setPropertiesUsingRemoteDictionary:sidoDic];
                [_searchArr addObject:sigungu];
            }
            [_searchDisplayCont.searchResultsTableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
        NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
        [_searchDisplayCont.searchResultsTableView reloadData];
    }];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text=@"";
    
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    _tableView.allowsSelection = YES;
    _tableView.scrollEnabled = YES;
    
}

#pragma mark UISearchDisplayDelegate
- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    [[UIApplication sharedApplication] setStatusBarHidden:TRUE];
}
- (void) searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller{
    if (IS_UNDER_IOS7) {
        
    }
}
- (void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller{
    if (IS_UNDER_IOS7) {
        
    }
    [[UIApplication sharedApplication] setStatusBarHidden:FALSE];
}
- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller{
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
