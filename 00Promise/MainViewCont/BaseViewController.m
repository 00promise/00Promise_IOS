//
//  BaseViewController.m
//  00Promise
//
//  Created by Rangken on 13. 9. 18..
//  Copyright (c) 2013년 SocialInovation. All rights reserved.
//

#import "BaseViewController.h"
#import "CandidateCell.h"
#import <FSExtendedAlertKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
@interface BaseViewController ()

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
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(centerItemClick)];
    gestureRecognizer.numberOfTapsRequired = 1;
    [self.navigationController.navigationBar setUserInteractionEnabled:YES];
    [self.navigationController.navigationBar addGestureRecognizer:gestureRecognizer];
    
    [_scrollView setContentOffset:CGPointMake(320, 0)];
}

- (void)viewDidAppear:(BOOL)animated{
    if (IS_UNDER_IOS7) {
        //[_bottomNaviBarView setFrame:CGRectMake(0, 5, 320, 3)];
        [_scrollView setFrame:CGRectMake(0, 3, 320, _scrollView.frame.size.height)];
    }
}

- (void)initVariable{
    _searchArr = [NSMutableArray new];
}
- (void)initView{
    //    CGFloat navBarHeight = [self.navigationController.navigationBar sizeThatFits:self.view.bounds.size].height;
    //
    //    // Resizing navigationBar
    //    self.navigationController.navigationBar.frame = CGRectMake(0, 0, self.view.bounds.size.width, navBarHeight);
    [self centerItemClick];
    _scrollView.contentSize = CGSizeMake(320*3, 568);
    _scrollView.pagingEnabled = YES;
    
    _locationView = [[[NSBundle mainBundle] loadNibNamed:@"LocationView" owner:nil options:nil] objectAtIndex:0];
    _locationView.parentViewCont = self;
    [_locationView setFrame:CGRectMake(0, 0, 320, 568)];
    [_scrollView addSubview:_locationView];
    
    _mainView = [[[NSBundle mainBundle] loadNibNamed:@"MainView" owner:nil options:nil] objectAtIndex:0];
    _mainView.parentViewCont = self;
    [_mainView setFrame:CGRectMake(320, 0, 320, 568)];
    [_scrollView addSubview:_mainView];
    
    _searchView = [[[NSBundle mainBundle] loadNibNamed:@"SearchView" owner:nil options:nil] objectAtIndex:0];
    _searchView.parentViewCont = self;
    [_searchView setBackgroundColor:[UIColor clearColor]];
    [_searchView setFrame:CGRectMake(640, 0, 320, 568)];
    [_scrollView addSubview:_searchView];
    if (IS_IOS7 && IS_IPHONE_5) {
        UIView* view = _searchView.searchDisplayCont.searchBar.subviews[0];
        searchBarY = view.frame.origin.y;
    }
    //[self.view addSubview:_scrollView];
}

- (IBAction)leftSwipeGesutre:(id)sender{
    if (_scrollView.contentOffset.x == 0 || _scrollView.contentOffset.x == 320) {
        [_scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x+320, 0) animated:TRUE];
    }
}

- (IBAction)rightSwipeGesture:(id)sender{
    if (_scrollView.contentOffset.x == 320 || _scrollView.contentOffset.x == 640) {
        [_scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x-320, 0) animated:TRUE];
    }
}

- (void)leftItemClick{
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:TRUE];
    //[self topImgBarSetting];
    /*
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    LocationViewController* locationViewCont = [storyboard instantiateViewControllerWithIdentifier:@"locationViewController"];
    
    UIView *theParentView = [self.view superview];
    
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.3];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromLeft];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    for (UIView* view in self.view.subviews) {
        [view removeFromSuperview];
    }
    [self.view addSubview:locationViewCont.view];
    
    [theParentView.layer addAnimation:animation forKey:@"showLocationViewController"];
     */
}
- (void)centerItemClick{
    [_scrollView setContentOffset:CGPointMake(320, 0) animated:TRUE];
    //[self topImgBarSetting];
    /*
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    MainViewController* mainViewCont = [storyboard instantiateViewControllerWithIdentifier:@"mainViewController"];
    UIView *theParentView = [self.view superview];
    
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.3];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromRight];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    for (UIView* view in self.view.subviews) {
        [view removeFromSuperview];
    }
    [self.view addSubview:mainViewCont.view];
    
    [theParentView.layer addAnimation:animation forKey:@"showMainViewController"];
     */
}

- (void)rightItemClick{
    [_scrollView setContentOffset:CGPointMake(640, 0) animated:TRUE];
    //[self topImgBarSetting];
    /*
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    SearchViewController* searchViewCont = [storyboard instantiateViewControllerWithIdentifier:@"searchViewController"];
    
    UIView *theParentView = [self.view superview];
    
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.3];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromRight];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    for (UIView* view in self.view.subviews) {
        [view removeFromSuperview];
    }
    [self.view addSubview:searchViewCont.view];
    
    [theParentView.layer addAnimation:animation forKey:@"showSearchViewController"];
     */
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self topImgBarSetting];
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
    [self topImgBarSetting];
}

- (void)topImgBarSetting{
    int targetX = 0;
    if (_scrollView.contentOffset.x < 320) {
        targetX = -80;
        [_locationView viewDidSlide];
    }else if(_scrollView.contentOffset.x < 640){
        targetX = 80;
        [_mainView viewDidSlide];
    }else {
        targetX = 240;
        [_searchView viewDidSlide];
    }
    _highlightBarImgView.frame = CGRectMake(targetX,
                                           _highlightBarImgView.frame.origin.y, _highlightBarImgView.frame.size.width, _highlightBarImgView.frame.size.height);
//    [UIView animateWithDuration:0.3f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
//                     animations:^{
//                         _highlightBarImgView.frame = CGRectMake(targetX,
//                                                                 _highlightBarImgView.frame.origin.y, _highlightBarImgView.frame.size.width, _highlightBarImgView.frame.size.height);
//                     }
//                     completion:nil];
}

#pragma mark UITableViewDelegate UITableViewDataSource
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
#pragma mark UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self.bottomNaviBarView setHidden:TRUE];
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
    
    /*
    CGRect statusBarFrame =  [[UIApplication sharedApplication] statusBarFrame];
    UIView *topView = _searchView.searchDisplayCont.searchBar.subviews[0];
    if (IS_IOS7 && IS_IPHONE_5) {
        topView = _searchView.searchDisplayCont.searchBar.subviews[0];
        topView.frame = CGRectMake(topView.frame.origin.x, searchBarY+statusBarFrame.size.height, topView.frame.size.width, topView.frame.size.height);
    }
    */
    if (cancelButton){
        //Set the new title of the cancel button
        [cancelButton setTitle:@"취소" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor colorWithHex:@"#FF4723" alpha:1.0f] forState:UIControlStateNormal];
        
        //[cancelButton setBackgroundColor:[UIColor colorWithHex:@"#FF4723" alpha:1.0f]];
        //[cancelButton setImage:[UIImage imageNamed:@"cancel_btn.png"] forState:UIControlStateNormal];
    }
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar; {
    [self.bottomNaviBarView setHidden:FALSE];
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
            //[_tableView reloadData];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
        NSLog(@"politicians/search.json [HTTPClient Error]: %@", error.localizedDescription);
        [_searchView.searchDisplayCont.searchResultsTableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.bottomNaviBarView setHidden:FALSE];
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

@end
