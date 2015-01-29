//
//  SearchView.h
//  00Promise
//
//  Created by Rangken on 13. 9. 19..
//  Copyright (c) 2013년 SocialInovation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
#import <CoreLocation/CoreLocation.h>
@interface SearchView : BaseView <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation* currentLocation;
@property (nonatomic, weak) IBOutlet UITableView* tableView;

- (IBAction)addressReloadClick:(id)sender;
@end
