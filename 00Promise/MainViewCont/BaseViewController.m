//
//  BaseViewController.m
//  00Promise
//
//  Created by Rangken on 13. 9. 18..
//  Copyright (c) 2013년 SocialInovation. All rights reserved.
//

#import "BaseViewController.h"
#import "CandidateCell.h"
#import "UIViewController+ScrollingNavbar.h"
#import <FSExtendedAlertKit/FSExtendedAlertKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
@interface BaseViewController () <SuperViewControllerDelegate, UIScrollViewDelegate, AMScrollingNavbarDelegate>
@property (nonatomic, weak) IBOutlet UIButton* issueBtn;
@property (nonatomic, weak) IBOutlet UIButton* politicianBtn;
@property (nonatomic, weak) IBOutlet UIScrollView* scrollView;

@property (nonatomic, strong) NSMutableArray* searchArr;
@end

@implementation BaseViewController

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
    /*
    [self followScrollView:self.scrollView withDelay:60];
    [self setUseSuperview:YES];
    [self setScrollableViewConstraint:self.headerConstraint withOffset:45];
    [self setShouldScrollWhenContentFits:NO];
    [self setScrollingNavbarDelegate:self];
    */
    /*
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(navBarClick)];
    gestureRecognizer.numberOfTapsRequired = 1;
    [self.navigationController.navigationBar setUserInteractionEnabled:YES];
    [self.navigationController.navigationBar addGestureRecognizer:gestureRecognizer];
    */
    //[_scrollView setContentOffset:CGPointMake(0, 0)];
}
- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    
}
- (void)viewWillAppear:(BOOL)animated{
    // TODO : 네이게이션에서 루트로 돌아오면 스크롤뷰 오프셋이 0으로 바뀜 - 이유를 몰라서 땜빵이로
    if (_type == BaseViewIssue) {
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:FALSE];
    }else if(_type == BaseViewSearch) {
        [_scrollView setContentOffset:CGPointMake(320, 0) animated:FALSE];
    }
}
- (void)viewDidAppear:(BOOL)animated{
    
    if (IS_UNDER_IOS7) {
        //[_bottomNaviBarView setFrame:CGRectMake(0, 5, 320, 3)];
        //[_scrollView setFrame:CGRectMake(0, 3, 320, _scrollView.frame.size.height)];
    }
}

- (void)initVariable{
    _type = BaseViewIssue;
    _searchArr = [NSMutableArray new];
}
- (void)initView{
    _scrollView.contentSize = CGSizeMake(320, 460);
    //_scrollView.pagingEnabled = YES;
    /*
    _locationView = [[[NSBundle mainBundle] loadNibNamed:@"LocationView" owner:nil options:nil] objectAtIndex:0];
    _locationView.parentViewCont = self;
    [_locationView setFrame:CGRectMake(0, 0, 320, 568)];
    [_scrollView addSubview:_locationView];
    
    _mainView = [[[NSBundle mainBundle] loadNibNamed:@"MainView" owner:nil options:nil] objectAtIndex:0];
    _mainView.parentViewCont = self;
    [_mainView setFrame:CGRectMake(320, 0, 320, 568)];
    [_scrollView addSubview:_mainView];
    */
   
    _hotIssueView = [[[NSBundle mainBundle] loadNibNamed:@"HotIssueView" owner:nil options:nil] objectAtIndex:0];
    _hotIssueView.parentViewCont = self;
    [_hotIssueView setFrame:CGRectMake(0, 0, 320, 568)];
    [_scrollView addSubview:_hotIssueView];
    
    _searchView = [[[NSBundle mainBundle] loadNibNamed:@"SearchView" owner:nil options:nil] objectAtIndex:0];
    _searchView.parentViewCont = self;
    [_searchView setBackgroundColor:[UIColor clearColor]];
    [_searchView setFrame:CGRectMake(320, 0, 320, 568)];
    [_scrollView addSubview:_searchView];
    
}

- (IBAction)leftSwipeGesutre:(id)sender{
    if (_scrollView.contentOffset.x == 0) {
        [self moveToIdx:1];
    }
}

- (IBAction)rightSwipeGesture:(id)sender{
    if (_scrollView.contentOffset.x == 320) {
        [self moveToIdx:0];
    }
}

// 네이게이션 바를 클릭했을때!
- (void)navBarClick{
    
}

- (IBAction)hotIssueClick{
    [self moveToIdx:0];
}


- (IBAction)politicianClick{
    [self moveToIdx:1];
}

- (void)moveToIdx:(NSInteger)idx{
    if (idx == 0) {
        _type = BaseViewIssue;
        [_issueBtn setSelected:TRUE];
        [_politicianBtn setSelected:FALSE];
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:TRUE];
        [_hotIssueView viewDidSlide];
        [_searchView viewUnSilde];
    }else if (idx == 1) {
        _type = BaseViewSearch;
        [_issueBtn setSelected:FALSE];
        [_politicianBtn setSelected:TRUE];
        [_scrollView setContentOffset:CGPointMake(320, 0) animated:TRUE];
        [_hotIssueView viewUnSilde];
        [_searchView viewDidSlide];
    }
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 메인뷰의 스크롤을 고정시키기 위함
    /*
    if (scrollView == _scrollView) {
        [scrollView setContentOffset: CGPointMake(scrollView.contentOffset.x, 0)];
    }
    if (scrollView.contentOffset.x == 0) {
        [_locationView startLocationManager];
    }
     */
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
}

#pragma mark 
/*
- (void)navigationBarDidChangeToExpanded:(BOOL)expanded
{
    if (expanded) {
        NSLog(@"Nav changed to expanded");
    }
}

- (void)navigationBarDidChangeToCollapsed:(BOOL)collapsed
{
    if (collapsed) {
        NSLog(@"Nav changed to collapsed");
    }
}
 */

#pragma mark UITableViewDelegate UITableViewDataSource
/*
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        int height = 20;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, height)];
        [view setBackgroundColor:[UIColor clearColor]];
        return view;
    }
    return NULL;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 20;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_searchArr count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    CandidateCell *cell = (CandidateCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil){
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CandidateCell" owner:nil options:nil];
        cell = [topLevelObjects objectAtIndex:0];
        
    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        
    }
    Politician* politician = [_searchArr objectAtIndex:indexPath.row];
    UIImage *backImage = [UIImage imageNamed:@"search_bg02.png"];
    cell.backImgView.image = [backImage stretchableImageWithLeftCapWidth:3 topCapHeight:3];
    
    cell.nameLabel.text = politician.name;
    cell.contentLabel.text = politician.memo;
    cell.positionLabel.text = politician.positionName;
    if ([politician haveImg]) {
        [cell.profileImgView setImageWithURL:[NSURL URLWithString:[politician img]] placeholderImage:nil options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){
            
        }];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        
    }
    Politician* politician = [_searchArr objectAtIndex:indexPath.row];
    [_searchView searchCandidateClick:politician.ID.integerValue];
}
 */
#pragma mark UISearchBarDelegate
/*
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    _searchView.tableView.allowsSelection = NO;
    _searchView.tableView.scrollEnabled = NO;
    
    searchBar.scopeButtonTitles = nil;
    searchBar.showsScopeBar = NO;
    
    UIButton *cancelButton;
    if (IS_IOS7) {
        UIView *topView = _searchView.searchDisplayCont.searchBar.subviews[0];
        for (UIView *subView in topView.subviews) {
            if ([subView isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
                cancelButton = (UIButton*)subView;
            }
        }
    }else{
        for (UIView *subView in _searchView.searchDisplayCont.searchBar.subviews) {
            if ([subView isKindOfClass:NSClassFromString(@"UIButton")]) {
                cancelButton = (UIButton*)subView;
            }
        }
    }
    

    if (cancelButton){
        //Set the new title of the cancel button
        [cancelButton setTitle:@"취소" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor colorWithHex:@"#FF4723" alpha:1.0f] forState:UIControlStateNormal];
    }
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar; {
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if ([searchText length] < 2) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        return ;
    }
    NSLog(@"SEARCH TEXT :%@",searchText);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[[AFAppDotNetAPIClient sharedClient] operationQueue] cancelAllOperations];
    [_searchArr removeAllObjects];
    NSDictionary* params = [NSDictionary dictionaryWithObject:searchText forKey:@"q"];
    [[AFAppDotNetAPIClient sharedClient] getPath:@"politicians/search.json" parameters:params success:^(AFHTTPRequestOperation *response, id responseObject) {
#ifdef _SERVER_LOG_
        NSLog(@"politicians/search.json: %@",(NSDictionary *)responseObject);
#endif
        NSString* code = [responseObject objectForKey:@"code"];
        if (![code isEqualToString:@"0000"]) {
            FSBlockButton *cancelButton = [FSBlockButton blockButtonWithTitle:@"확인" block:^ {
            }];
            FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"에러" message:[responseObject objectForKey:@"message"] cancelButton:cancelButton otherButtons: nil];
            [alert show];
        }else{
            NSMutableArray* politicianArr = [responseObject objectForKey:@"data"];
            for (NSDictionary* dic in politicianArr) {
                NSDictionary* politicianDic = [NSDictionary dictionaryWithObject:dic forKey:@"politician"];
                Politician* politician = [Politician new];
                [politician setPropertiesUsingRemoteDictionary:politicianDic];
                [_searchArr addObject:politician];
            }
            [_searchView.searchDisplayCont.searchResultsTableView reloadData];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
        NSLog(@"politicians/search.json [HTTPClient Error]: %@", error.localizedDescription);
        [_searchView.searchDisplayCont.searchResultsTableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text=@"";
    
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    _searchView.tableView.allowsSelection = YES;
    _searchView.tableView.scrollEnabled = YES;
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

#pragma mark UISearchDisplayDelegate
- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    
}
- (void) searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller{
    if (IS_UNDER_IOS7) {
        
    }
}
- (void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller{
    
}
- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller{
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
 */

@end
