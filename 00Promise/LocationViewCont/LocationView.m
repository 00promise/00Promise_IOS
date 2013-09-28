//
//  LocationView.m
//  00Promise
//
//  Created by Rangken on 13. 9. 19..
//  Copyright (c) 2013년 SocialInovation. All rights reserved.
//

#import "LocationView.h"
#import "CandidateCell.h"
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
    
}
- (IBAction)locationClick:(id)sender{
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
- (void)reloadLocation{
    NSLog(@"RELOAD LOCATION");
    
}
#pragma mark BaseViewDelegate
- (void)viewDidSlide{
    NSLog(@"viewDidSlide");
    [self startLocationManager];
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
	[self.locationManager stopUpdatingLocation];
    [MBProgressHUD hideHUDForView:self animated:YES];
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
         _locationLabel.text = [NSString stringWithFormat:@"%@ %@",placemark.subLocality,placemark.thoroughfare];
     }];
    [self.locationManager stopUpdatingLocation];
    [MBProgressHUD hideHUDForView:self animated:YES];
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
    return 10;
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
    UIImage *backImage = [UIImage imageNamed:@"search_bg02.png"];
    cell.backImgView.image = [backImage stretchableImageWithLeftCapWidth:3 topCapHeight:3];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //PledgeViewController* pledgeViewCont = [PledgeViewController new];
    [(UIViewController *)self.parentViewCont performSegueWithIdentifier:@"GoCandidatePush" sender:nil];
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
