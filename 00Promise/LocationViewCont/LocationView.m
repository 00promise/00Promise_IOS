//
//  LocationView.m
//  00Promise
//
//  Created by Rangken on 13. 9. 19..
//  Copyright (c) 2013년 SocialInovation. All rights reserved.
//

#import "LocationView.h"
#import "CandidateCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <FSExtendedAlertKit.h>
#import "AFAppDotNetAPIClient.h"
#import "Models.h"
#import "CandidateViewController.h"
@implementation LocationView

- (id) initWithCoder:(NSCoder *)aCoder{
    if(self = [super initWithCoder:aCoder]){
        [self initView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
}
- (void)initView{
    _candicateArr = [NSMutableArray new];
}
- (IBAction)locationClick:(id)sender{
    [[NSUserDefaults standardUserDefaults] setInteger:-1 forKey:@"sigunguId"];
    [self startLocationManager];
}

- (IBAction)otherLocationClick:(id)sender{
    [(UIViewController *)self.parentViewCont performSegueWithIdentifier:@"GoLocationPush" sender:nil];
}
- (void)startLocationManager{
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    [_locationManager setDistanceFilter:kCLDistanceFilterNone];
    [_locationManager setDelegate:self];
    [_locationManager startUpdatingLocation];
    [_locationManager setPausesLocationUpdatesAutomatically:NO];
    if([CLLocationManager locationServicesEnabled]){
        switch([CLLocationManager authorizationStatus]){
            case kCLAuthorizationStatusAuthorized:
                // we can access location services
                NSLog(@"kCLAuthorizationStatusAuthorized");
                break;
            case kCLAuthorizationStatusDenied:
                // denied by user
                NSLog(@"kCLAuthorizationStatusDenied");
                break;
            case kCLAuthorizationStatusRestricted:
                // restricted by parental controls
                NSLog(@"kCLAuthorizationStatusRestricted");
                break;
            case kCLAuthorizationStatusNotDetermined:
                NSLog(@"kCLAuthorizationStatusNotDetermined");
                break;
        }
    }
    else{
        // Location Services Are Disabled
        NSLog(@"Location Services Are Disabled");
    }
}
- (void)reloadLocation:(NSInteger)sigunguId :(NSString*)guStr{
    _locationLabel.text = guStr;
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    [[AFAppDotNetAPIClient sharedClient] getPath:[NSString stringWithFormat:@"politicians/my_district/%d.json",sigunguId] parameters:nil success:^(AFHTTPRequestOperation *response, id responseObject) {
        
        NSLog(@"politicians/my_district/@id.json : %@",(NSDictionary *)responseObject);
        
        NSString* code = [responseObject objectForKey:@"code"];
        if (![code isEqualToString:@"0000"]) {
            FSBlockButton *cancelButton = [FSBlockButton blockButtonWithTitle:@"확인" block:^ {
            }];
            FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"에러" message:[responseObject objectForKey:@"message"] cancelButton:cancelButton otherButtons: nil];
            [alert show];
        }else{
            [_candicateArr removeAllObjects];
            NSMutableArray* politicianArr = [responseObject objectForKey:@"data"];
            for (NSDictionary* dic in politicianArr) {
                NSDictionary* politicianDic = [NSDictionary dictionaryWithObject:dic forKey:@"politician"];
                Politician* politician = [Politician new];
                [politician setPropertiesUsingRemoteDictionary:politicianDic];
                [_candicateArr addObject:politician];
            }
            [_tableView reloadData];
        }
        [MBProgressHUD hideHUDForView:self animated:YES];
    } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
        NSLog(@"politicians/my_district/@id.json [HTTPClient Error]: %@", error.localizedDescription);
        [MBProgressHUD hideHUDForView:self animated:YES];
    }];
}
#pragma mark BaseViewDelegate
- (void)viewDidSlide{
    NSLog(@"viewDidSlide");
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"sigunguId"] == -1 ) {
        [self startLocationManager];
    }else if([[NSUserDefaults standardUserDefaults] integerForKey:@"sigunguId"] == 0){
        [self startLocationManager];
    }else{
        _locationLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"locationName"];
        [MBProgressHUD showHUDAddedTo:self animated:YES];
        [[AFAppDotNetAPIClient sharedClient] getPath:[NSString stringWithFormat:@"politicians/my_district/%d.json",[[NSUserDefaults standardUserDefaults] integerForKey:@"sigunguId"]] parameters:nil success:^(AFHTTPRequestOperation *response, id responseObject) {
            
            NSLog(@"politicians/my_district/@id.json : %@",(NSDictionary *)responseObject);
            
            NSString* code = [responseObject objectForKey:@"code"];
            if (![code isEqualToString:@"0000"]) {
                FSBlockButton *cancelButton = [FSBlockButton blockButtonWithTitle:@"확인" block:^ {
                }];
                FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"에러" message:[responseObject objectForKey:@"message"] cancelButton:cancelButton otherButtons: nil];
                [alert show];
            }else{
                [_candicateArr removeAllObjects];
                NSMutableArray* politicianArr = [responseObject objectForKey:@"data"];
                for (NSDictionary* dic in politicianArr) {
                    NSDictionary* politicianDic = [NSDictionary dictionaryWithObject:dic forKey:@"politician"];
                    Politician* politician = [Politician new];
                    [politician setPropertiesUsingRemoteDictionary:politicianDic];
                    [_candicateArr addObject:politician];
                }
                [_tableView reloadData];
            }
            [MBProgressHUD hideHUDForView:self animated:YES];
        } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
            NSLog(@"politicians/my_district/@id.json [HTTPClient Error]: %@", error.localizedDescription);
            [MBProgressHUD hideHUDForView:self animated:YES];
        }];
    }
}

- (void)viewUnSilde{
}

#pragma mark CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager
   didUpdateToLocation:(CLLocation *)newLocation
          fromLocation:(CLLocation *)oldLocation {
	NSString *strInfo = [NSString
                         stringWithFormat:@"didUpdateToLocation: latitude = %f, longitude = %f",
                         newLocation.coordinate.latitude, newLocation.coordinate.longitude];
	NSLog(@"%@",strInfo);
	
	//마지막으로 검색된 위치를 다른곳에서 활용하기 위하여 설정.
	//self.lastScannedLocation = newLocation;
    
	//한번 위치를 잡으면 로케이션 매니저 정지.
    //
	[self.locationManager stopUpdatingLocation];
    CLGeocoder *myGeocoder = [[CLGeocoder alloc]init];
    CLLocation *cl = [[CLLocation alloc]initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
    [myGeocoder reverseGeocodeLocation:cl completionHandler:^(NSArray *placemarks, NSError *error)
     {
         //CLPlacemark *placemark = [placemarks objectAtIndex:0];
         
     }];


	//[self getBranchDataWithLocation:self.lastScannedLocation]; //화면에 마커찍기
}
- (void)locationManager:(CLLocationManager *)manager
	 didUpdateLocations:(NSArray *)locations{
    
    _currentLocation = [locations lastObject];
    NSLog(@"currentLocation %f %f",_currentLocation.coordinate.latitude,_currentLocation.coordinate.longitude);
    CLGeocoder *myGeocoder = [[CLGeocoder alloc]init];
    CLLocation *cl = [[CLLocation alloc]initWithLatitude:_currentLocation.coordinate.latitude longitude:_currentLocation.coordinate.longitude];
    [myGeocoder reverseGeocodeLocation:cl completionHandler:^(NSArray *placemarks, NSError *error)
     {
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         _locationLabel.text = [NSString stringWithFormat:@"%@ %@",placemark.administrativeArea,placemark.subLocality];
         //http://00promise.org/api/politicians/my_district/1.json
         NSMutableDictionary* params = [NSMutableDictionary new];

         [params setObject:[NSString stringWithFormat:@"%@",placemark.subLocality] forKey:@"q"];
         //[params setObject:[NSString stringWithFormat:@"%d",tag+1] forKey:@"grade"];
         
         [[AFAppDotNetAPIClient sharedClient] getPath:@"district/search.json" parameters:params success:^(AFHTTPRequestOperation *response, id responseObject) {
             
             NSLog(@"district/search.json : %@",(NSDictionary *)responseObject);
             
             NSString* code = [responseObject objectForKey:@"code"];
             if (![code isEqualToString:@"0000"]) {
                 FSBlockButton *cancelButton = [FSBlockButton blockButtonWithTitle:@"확인" block:^ {
                 }];
                 FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"에러" message:[responseObject objectForKey:@"message"] cancelButton:cancelButton otherButtons: nil];
                 [alert show];
             }else{
                 //http://00promise.org/api/politicians/my_district/1.json
                 Sigungu* sigungu = [Sigungu new];
                 NSMutableArray* sigunguArr = [responseObject objectForKey:@"data"];
                 if ([sigunguArr count] == 0) {
                     [MBProgressHUD hideHUDForView:self animated:YES];
                     return ;
                 }
                 NSDictionary* sigunguDic = [sigunguArr objectAtIndex:0];
                 [sigungu setPropertiesUsingRemoteDictionary:[NSDictionary dictionaryWithObject:sigunguDic forKey:@"sigungu"]];
                 //[[NSUserDefaults standardUserDefaults] setInteger:-1 forKey:@"sigunguId"];
                 //[params setObject:[NSString stringWithFormat:@"%d",tag+1] forKey:@"grade"];
                 
                 [[AFAppDotNetAPIClient sharedClient] getPath:[NSString stringWithFormat:@"politicians/my_district/%d.json",sigungu.ID.integerValue] parameters:nil success:^(AFHTTPRequestOperation *response, id responseObject) {
                     
                     NSLog(@"politicians/my_district/@id.json : %@",(NSDictionary *)responseObject);
                     
                     NSString* code = [responseObject objectForKey:@"code"];
                     if (![code isEqualToString:@"0000"]) {
                         FSBlockButton *cancelButton = [FSBlockButton blockButtonWithTitle:@"확인" block:^ {
                         }];
                         FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"에러" message:[responseObject objectForKey:@"message"] cancelButton:cancelButton otherButtons: nil];
                         [alert show];
                     }else{
                         [_candicateArr removeAllObjects];
                         NSMutableArray* politicianArr = [responseObject objectForKey:@"data"];
                         for (NSDictionary* dic in politicianArr) {
                             NSDictionary* politicianDic = [NSDictionary dictionaryWithObject:dic forKey:@"politician"];
                             Politician* politician = [Politician new];
                             [politician setPropertiesUsingRemoteDictionary:politicianDic];
                             [_candicateArr addObject:politician];
                         }
                         [_tableView reloadData];
                     }
                     [MBProgressHUD hideHUDForView:self animated:YES];
                 } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
                     NSLog(@"politicians/my_district/@id.json [HTTPClient Error]: %@", error.localizedDescription);
                     [MBProgressHUD hideHUDForView:self animated:YES];
                 }];
             }
             //[MBProgressHUD hideHUDForView:self animated:YES];
         } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
             NSLog(@"district/search.json [HTTPClient Error]: %@", error.localizedDescription);
             [MBProgressHUD hideHUDForView:self animated:YES];
         }];
         
     }];
    [self.locationManager stopUpdatingLocation];
    //[MBProgressHUD hideHUDForView:self animated:YES];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    NSLog(@"didFailWithError");
    [MBProgressHUD hideHUDForView:self animated:YES];
}
#pragma mark UITableViewDelegate UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 10)];
    [view setBackgroundColor:[UIColor clearColor]];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 8;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 10)];
    [view setBackgroundColor:[UIColor clearColor]];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_candicateArr count];
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
    Politician* politician = [_candicateArr objectAtIndex:indexPath.row];
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //PledgeViewController* pledgeViewCont = [PledgeViewController new];
    //[(UIViewController *)self.parentViewCont performSegueWithIdentifier:@"GoCandidatePush" sender:nil];
    
    Politician* politician = [_candicateArr objectAtIndex:indexPath.row];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    CandidateViewController* candidateViewCont = [storyboard instantiateViewControllerWithIdentifier:@"candidateViewController"];
    candidateViewCont.politicianId = politician.ID.integerValue;
    [((UIViewController*)self.parentViewCont).navigationController pushViewController:candidateViewCont animated:TRUE];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
