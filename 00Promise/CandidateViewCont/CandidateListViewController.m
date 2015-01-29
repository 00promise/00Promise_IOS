//
//  CandidateListViewController.m
//  00Promise
//
//  Created by Rangken on 13. 9. 27..
//  Copyright (c) 2013년 SocialInovation. All rights reserved.
//

#import "CandidateListViewController.h"
#import "CandidateCell.h"
#import "JYGraphic.h"
#import "CandidateViewController.h"
#import "UIColor+CreateMethods.h"
#import "UIViewController+ScrollingNavbar.h"
#import <FSExtendedAlertKit.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface CandidateListViewController () <AMScrollingNavbarDelegate, UISearchBarDelegate>
@property (nonatomic, strong) UISearchBar* searchBar;
@property (nonatomic, strong) UIView* searchBarContainer;
@property (nonatomic, assign) CGFloat lastContentOffset;
@end

@implementation CandidateListViewController

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
    [self setTitleLabelStr:_titleTxt];
    
    [self followScrollView:self.tableView withDelay:60];
    [self setUseSuperview:YES];
    //[self setScrollableViewConstraint:self.headerConstraint withOffset:45];
    [self setShouldScrollWhenContentFits:NO];
    [self setScrollingNavbarDelegate:self];
    
    if (_type == CandidateListName) {
        _searchBar.delegate = self;
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(5.0, 0.0, 310.0f, 44.0)];
        _searchBar.placeholder = @"Search Files";
        _searchBar.userInteractionEnabled=YES;
        _searchBar.barTintColor = [UIColor whiteColor];
        _searchBar.backgroundColor = [UIColor clearColor];
        _searchBar.tintColor = [UIColor whiteColor];
        _searchBar.layer.borderWidth = 1;
        _searchBar.delegate = self;
        _searchBar.barStyle = UIBarStyleDefault;
        _searchBar.layer.borderColor = [[UIColor clearColor] CGColor];
        [_searchBar setBackgroundImage:[UIImage new]];
        UITextField *searchField = [_searchBar valueForKey:@"_searchField"];
        searchField.placeholder = @"이름으로 입력하세요.";
        searchField.textColor = [UIColor whiteColor];
        searchField.backgroundColor = [UIColor colorWithHex:@"#F06F29" alpha:1.0f];
        [searchField setValue:[UIColor colorWithHex:@"#F9CDBD" alpha:1.0f] forKeyPath:@"_placeholderLabel.textColor"];
        
        UIImageView* iconImgView = (id)searchField.leftView;
        UIImage* image =  [UIImage imageNamed:@"main_icon03.png"];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        iconImgView.tintColor = [UIColor whiteColor];
        iconImgView.image = image;
        [iconImgView setFrame:CGRectMake(iconImgView.frame.origin.x, iconImgView.frame.origin.y, 11, 15)];
        
        //[searchField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
        //UIImage *imgClear = [UIImage imageNamed:@"btn_close01.png"];
        //[_searchBar setImage:imgClear forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
        
        _searchBarContainer = [[UIView alloc] initWithFrame:_searchBar.frame];
        _searchBarContainer.backgroundColor = [UIColor colorWithHex:@"#DC5A14" alpha:1.0f];
        [_searchBarContainer addSubview:_searchBar];
        [self.navigationController.navigationBar addSubview:_searchBarContainer];
        
        [_searchBar becomeFirstResponder];
    }
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"leads_calls_to_detail"])
    {
    }
}
- (void)initVariable{
    page = 1;
    _candidateArr = [NSMutableArray new];
}
- (void)initView{    
    [_tableView setContentInset:UIEdgeInsetsMake(5.0f, 0.0, 0.0, 0.0)];
    
    [_candidateArr removeAllObjects];
    
    NSString *url;
    if (_type == CandidateListElection) {
        url = [NSString stringWithFormat:@"elections/%ld/politicians.json",_ID];
    }else if(_type == CandidateListParty) {
        url = [NSString stringWithFormat:@"parties/%ld/politicians.json",_ID];
    }else if(_type == CandidateListLocation) {
        url = [NSString stringWithFormat:@"politicians/my_district/%ld.json",_ID];
    }
    if (_type != CandidateListName) {
        [[NSBundle mainBundle] loadNibNamed:@"PledgeFooterActivityIndicator" owner:self options:nil];//this gets a new instance from the xib
        self.activityIndicator=self.activityIndicator;
        [[self tableView] setTableFooterView:[self activityIndicatorView]];
        [[self activityIndicatorView] setHidden:TRUE];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[AFAppDotNetAPIClient sharedClient] getPath:url parameters:nil success:^(AFHTTPRequestOperation *response, id responseObject) {
    #ifdef _SERVER_LOG_
            NSLog(@"%@ : %@",url, (NSDictionary *)responseObject);
    #endif
            NSString* code = [responseObject objectForKey:@"code"];
            if (![code isEqualToString:@"0000"]) {
                FSBlockButton *cancelButton = [FSBlockButton blockButtonWithTitle:@"확인" block:^ {
                    [[UIApplication sharedApplication] finalize];
                }];
                FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"에러" message:[responseObject objectForKey:@"message"] cancelButton:cancelButton otherButtons: nil];
                [alert show];
            }else{
                NSMutableArray* manifestoArr = [responseObject objectForKey:@"data"];
                for (NSDictionary* dic in manifestoArr) {
                    NSDictionary* politicianDic = [NSDictionary dictionaryWithObject:dic forKey:@"politician"];
                    Politician* politician = [Politician new];
                    [politician setPropertiesUsingRemoteDictionary:politicianDic];
                    [_candidateArr addObject:politician];
                }
                [_tableView reloadData];
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
    #ifdef _SERVER_LOG_
            NSLog(@"%@ : [HTTPClient Error]: %@", url, error.localizedDescription);
    #endif
        
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
}
- (void)backItemClick{
    [self.navigationController popViewControllerAnimated:TRUE];
}
- (void)loadMore{
    page++;
    NSString *url;
    if (_type == CandidateListElection) {
        url = [NSString stringWithFormat:@"elections/%ld/politicians.json",_ID];
    }else if(_type == CandidateListParty) {
        url = [NSString stringWithFormat:@"parties/%ld/politicians.json",_ID];
    }else if(_type == CandidateListLocation) {
        url = [NSString stringWithFormat:@"politicians/my_district/%ld.json",_ID];
    }
    if (_type != CandidateListName) {
        NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
        [params setObject:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
        [[AFAppDotNetAPIClient sharedClient] getPath:url parameters:params success:^(AFHTTPRequestOperation *response, id responseObject) {
#ifdef _SERVER_LOG_
            NSLog(@"%@ : %@",url, (NSDictionary *)responseObject);
#endif
            NSString* code = [responseObject objectForKey:@"code"];
            NSUInteger tmpIdx;
            if (![code isEqualToString:@"0000"]) {
                page--;
            }else{
                tmpIdx = [_candidateArr count];
                NSMutableArray* manifestoArr = [responseObject objectForKey:@"data"];
                for (NSDictionary* dic in manifestoArr) {
                    NSDictionary* politicianDic = [NSDictionary dictionaryWithObject:dic forKey:@"politician"];
                    Politician* politician = [Politician new];
                    [politician setPropertiesUsingRemoteDictionary:politicianDic];
                    [_candidateArr addObject:politician];
                }
                [_tableView reloadData];
            }
            if (_tableView.contentOffset.y > _tableView.contentSize.height - _tableView.frame.size.height-_activityIndicatorView.frame.size.height) {
                [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:tmpIdx-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:TRUE];
            }
            [[self activityIndicatorView] setHidden:TRUE];
            [[self activityIndicator] stopAnimating];
        } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
#ifdef _SERVER_LOG_
            NSLog(@"%@ : [HTTPClient Error]: %@", url, error.localizedDescription);
#endif
            page--;
        }];
    }
}

#pragma mark UITableViewDelegate UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 20;
    }
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    int height = 0;
    if (section == 0) {
        height = 0;
    }else{
        height = 10;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, height)];
    [view setBackgroundColor:[UIColor clearColor]];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return 10;
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    int height = 0;
    if (section == 0) {
        height = 0;
    }else{
        height = 10;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, height)];
    [view setBackgroundColor:[UIColor clearColor]];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_candidateArr count];;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    CandidateCell *cell = (CandidateCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CandidateCell" owner:nil options:nil];
        cell = [topLevelObjects objectAtIndex:0];
        
    }
    Politician* politician = [_candidateArr objectAtIndex:indexPath.row];
    //UIImage *backImage = [UIImage imageNamed:@"search_bg02.png"];
    //cell.backImgView.image = [backImage stretchableImageWithLeftCapWidth:3 topCapHeight:3];
    
    cell.nameLabel.text = politician.name;
    cell.positionLabel.text = politician.positionName;
    if ([politician haveImg]) {
        [cell.profileImgView setImageWithURL:[NSURL URLWithString:[politician img]] placeholderImage:[UIImage imageNamed:@"default_image.png"] options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){
            
        }];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
    Politician* politician = [_candidateArr objectAtIndex:indexPath.row];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    CandidateViewController* candidateViewCont = [storyboard instantiateViewControllerWithIdentifier:@"candidateViewController"];
    candidateViewCont.politicianId = politician.ID.integerValue;
    [self.navigationController pushViewController:candidateViewCont animated:TRUE];
     */
}
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UITextField *searchField = [_searchBar valueForKey:@"_searchField"];
    [searchField resignFirstResponder];
    if (_lastContentOffset < (int)scrollView.contentOffset.y) {
        [searchField resignFirstResponder];
    }
    else if (_lastContentOffset > (int)scrollView.contentOffset.y) {
        [searchField becomeFirstResponder];
    }
    
    if ([_candidateArr count] < 10) {
        return ;
    }
	if (([scrollView contentOffset].y + scrollView.frame.size.height) + 10 > [scrollView contentSize].height) {
        if (![[self activityIndicator] isAnimating]) {
            [self loadMore];
        }
        [[self activityIndicator] startAnimating];
        [[self activityIndicatorView] setHidden:FALSE];
	}
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _lastContentOffset = scrollView.contentOffset.x;
}

#pragma mark UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    
    searchBar.scopeButtonTitles = nil;
    searchBar.showsScopeBar = NO;
    
    UIButton *cancelButton;
    if (IS_IOS7) {
        UIView *topView = _searchBar.subviews[0];
        for (UIView *subView in topView.subviews) {
            if ([subView isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
                cancelButton = (UIButton*)subView;
            }
        }
    }else{
        for (UIView *subView in _searchBar.subviews) {
            if ([subView isKindOfClass:NSClassFromString(@"UIButton")]) {
                cancelButton = (UIButton*)subView;
            }
        }
    }
    
    
    if (cancelButton){
        cancelButton.titleLabel.font = [UIFont fontWithName:@"System" size:13];
        [cancelButton setTitle:@"취소" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }

}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if ([searchText length] < 2) {
        //[MBProgressHUD hideHUDForView:self.view animated:YES];
        return ;
    }
    NSLog(@"SEARCH TEXT :%@",searchText);
    
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[[AFAppDotNetAPIClient sharedClient] operationQueue] cancelAllOperations];
    [_candidateArr removeAllObjects];
    
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
                [_candidateArr addObject:politician];
            }
            [_tableView reloadData];
        }
        //[MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
#ifdef _SERVER_LOG_
        NSLog(@"politicians/search.json [HTTPClient Error]: %@", error.localizedDescription);
#endif
        //[MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
     
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text=@"";
    
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    [_searchBarContainer removeFromSuperview];
    [self.navigationController popViewControllerAnimated:TRUE];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
