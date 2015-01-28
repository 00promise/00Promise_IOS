//
//  SearchView.m
//  00Promise
//
//  Created by Rangken on 13. 9. 19..
//  Copyright (c) 2013년 SocialInovation. All rights reserved.
//

#import "SearchView.h"
#import "SearchTableViewCell.h"
#import "AppDelegate.h"
#import "UIColor+CreateMethods.h"
#import "BaseViewController.h"
#import "CandidateListViewController.h"
#import "SearchListViewController.h"
#import "CandidateViewController.h"
#import <FSExtendedAlertKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
@interface SearchView() <UIActionSheetDelegate>
@property (nonatomic, strong) NSString* address;
@property (nonatomic, strong) NSMutableArray* sidoArr;
@property (nonatomic, strong) NSMutableArray* partyArr;
@property (nonatomic, strong) NSMutableArray* electionArr;
@end
    
@implementation SearchView

- (id) initWithCoder:(NSCoder *)aCoder{
    if(self = [super initWithCoder:aCoder]){
        [self initVariable];
        [self initView];
    }
    return self;
}

- (void)awakeFromNib{
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    /*
    if (IS_IOS7 ) {
        [_tableView setFrame:CGRectMake(0, 0, 320, _tableView.frame.size.height)];
    }
     */
    /*
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
     */
}
- (void)initVariable{
    _address = @"";
    _sidoArr = [NSMutableArray new];
    _partyArr = [NSMutableArray new];
    _electionArr = [NSMutableArray new];
    
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    [_locationManager setDistanceFilter:kCLDistanceFilterNone];
    [_locationManager setDelegate:self];
    
    [_locationManager setPausesLocationUpdatesAutomatically:YES];
}
- (void)initView{
    [[AFAppDotNetAPIClient sharedClient] getPath:@"district/sidos.json" parameters:nil success:^(AFHTTPRequestOperation *response, id responseObject) {
#ifdef _SERVER_LOG_
        NSLog(@"district/sidos.json : %@",(NSDictionary *)responseObject);
#endif
        NSString* code = [responseObject objectForKey:@"code"];
        if (![code isEqualToString:@"0000"]) {
            
        }else{
            NSMutableArray* sidoArr = [responseObject objectForKey:@"data"];
            for (NSDictionary* dic in sidoArr) {
                NSDictionary* sidoDic = [NSDictionary dictionaryWithObject:dic forKey:@"sido"];
                Sido* sido = [Sido new];
                [sido setPropertiesUsingRemoteDictionary:sidoDic];
                [_sidoArr addObject:sido];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
#ifdef _SERVER_LOG_
        NSLog(@"district/sidos.json [HTTPClient Error]: %@", error.localizedDescription);
#endif
    }];
    
    [[AFAppDotNetAPIClient sharedClient] getPath:@"parties.json" parameters:nil success:^(AFHTTPRequestOperation *response, id responseObject) {
#ifdef _SERVER_LOG_
        NSLog(@"parties.json : %@",(NSDictionary *)responseObject);
#endif
        NSString* code = [responseObject objectForKey:@"code"];
        if (![code isEqualToString:@"0000"]) {
            
        }else{
            NSMutableArray* manifestoArr = [responseObject objectForKey:@"data"];
            for (NSDictionary* dic in manifestoArr) {
                NSDictionary* partyDic = [NSDictionary dictionaryWithObject:dic forKey:@"party"];
                Party* party = [Party new];
                [party setPropertiesUsingRemoteDictionary:partyDic];
                [_partyArr addObject:party];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
#ifdef _SERVER_LOG_
        NSLog(@"parties.json [HTTPClient Error]: %@", error.localizedDescription);
#endif
    }];
    
    [[AFAppDotNetAPIClient sharedClient] getPath:@"elections.json" parameters:nil success:^(AFHTTPRequestOperation *response, id responseObject) {
#ifdef _SERVER_LOG_
        NSLog(@"elections.json : %@",(NSDictionary *)responseObject);
#endif
        NSString* code = [responseObject objectForKey:@"code"];
        if (![code isEqualToString:@"0000"]) {
            
        }else{
            NSMutableArray* manifestoArr = [responseObject objectForKey:@"data"];
            for (NSDictionary* dic in manifestoArr) {
                NSDictionary* electionDic = [NSDictionary dictionaryWithObject:dic forKey:@"election"];
                Election* election = [Election new];
                [election setPropertiesUsingRemoteDictionary:electionDic];
                [_electionArr addObject:election];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
#ifdef _SERVER_LOG_
        NSLog(@"elections.json [HTTPClient Error]: %@", error.localizedDescription);
#endif
    }];
}
- (void)startLocationManager{
    [_locationManager requestWhenInUseAuthorization];
    if([CLLocationManager locationServicesEnabled]){
        [_locationManager startUpdatingLocation];
    }
    else{
        _address = @"";
    }
}

- (IBAction)addressReloadClick:(id)sender{
    [self startLocationManager];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations{
    
    [manager stopUpdatingLocation];
    
    CLLocation* location = [locations lastObject];
    CLGeocoder *myGeocoder = [[CLGeocoder alloc]init];
    CLLocation *cl = [[CLLocation alloc]initWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    [myGeocoder reverseGeocodeLocation:cl completionHandler:^(NSArray *placemarks, NSError *error)
     {
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         _address = [NSString stringWithFormat:@"%@ %@ %@", placemark.administrativeArea,placemark.locality, placemark.thoroughfare];
         [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
     }];
}
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{

}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if (status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusNotDetermined) {
        _address = @"위치검색을 허가해주세요.";
    }
}
#pragma mark BaseViewDelegate
- (void)viewDidSlide{
    [self startLocationManager];
}

- (void)viewUnSilde{
}
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        
    }else if(buttonIndex == 1) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        SearchListViewController* searchListViewCont = [storyboard instantiateViewControllerWithIdentifier:@"searchListViewController"];
        searchListViewCont.type = SearchListLocation;
        searchListViewCont.array = _sidoArr;
        [((UIViewController *)self.parentViewCont).navigationController pushViewController:searchListViewCont animated:TRUE];
    }
}
- (void)actionSheetCancel:(UIActionSheet *)actionSheet{
    
}
#pragma mark UITableViewDelegate UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 4;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    SearchTableViewCell *cell = (SearchTableViewCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil){
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SearchTableViewCell" owner:nil options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    UIImage *iconImage;
    NSString* titleText;
    
    if (indexPath.row == 0) {
        iconImage = [UIImage imageNamed:@"main_icon01.png"];
        titleText = @"우리 지역 찾기";
        cell.addressLabel.text = _address;
        cell.addressLabel.hidden = FALSE;
        cell.btn.hidden = FALSE;
        cell.searchView = self;
    }else if(indexPath.row == 1){
        iconImage = [UIImage imageNamed:@"main_icon02.png"];
        titleText = @"정당으로 찾기";
    }else if(indexPath.row == 2){
        iconImage = [UIImage imageNamed:@"main_icon03.png"];
        titleText = @"선거로 찾기";
    }else if(indexPath.row == 3){
        iconImage = [UIImage imageNamed:@"main_icon04.png"];
        titleText = @"이름으로 찾기";
    }
    cell.imgView.image = iconImage;
    cell.label.text = titleText;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        UIActionSheet *menu = [[UIActionSheet alloc]
                               initWithTitle: nil
                               delegate:self
                               cancelButtonTitle:@"취소"
                               destructiveButtonTitle:nil
                               otherButtonTitles:@"현재 지역 검색", @"지역 찾기", nil];
        [menu showInView:self];
    }else if(indexPath.row == 1) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        SearchListViewController* searchListViewCont = [storyboard instantiateViewControllerWithIdentifier:@"searchListViewController"];
        searchListViewCont.type = SearchListParty;
        searchListViewCont.array = _partyArr;
        [((UIViewController *)self.parentViewCont).navigationController pushViewController:searchListViewCont animated:TRUE];
        
    }else if(indexPath.row == 2) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        SearchListViewController* searchListViewCont = [storyboard instantiateViewControllerWithIdentifier:@"searchListViewController"];
        searchListViewCont.type = SearchListElection;
        searchListViewCont.array = _electionArr;
        [((UIViewController *)self.parentViewCont).navigationController pushViewController:searchListViewCont animated:TRUE];
    }else if(indexPath.row == 3) {
        [(UIViewController *)self.parentViewCont performSegueWithIdentifier:@"GoCandidateListPush" sender:nil];
    }
    /*
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
    }
     */
}


@end
