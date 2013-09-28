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
@property (nonatomic, strong) IBOutlet UILabel* locationLabel;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation* currentLocation;
- (void)startLocationManager;
- (void)reloadLocation;
@end
