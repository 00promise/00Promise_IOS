//
//  LocationView.h
//  00Promise
//
//  Created by Rangken on 13. 9. 19..
//  Copyright (c) 2013년 SocialInovation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
#import <CoreLocation/CoreLocation.h>
@interface LocationView : BaseView <CLLocationManagerDelegate>
@property (nonatomic, weak) IBOutlet UILabel* locationLabel;
@property (nonatomic, weak) IBOutlet UITableView* tableView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation* currentLocation;
@property (nonatomic, strong) NSMutableArray* candicateArr;
- (void)startLocationManager;
- (void)reloadLocation:(NSInteger)sigunguId :(NSString*)guStr;
@end
