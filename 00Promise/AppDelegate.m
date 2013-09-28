//
//  AppDelegate.m
//  00Promise
//
//  Created by Rangken on 13. 9. 8..
//  Copyright (c) 2013년 SocialInovation. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    //Badge 개수 설정
    application.applicationIconBadgeNumber = 0;
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"deviceToken : %@", deviceToken);
    NSMutableString* token = [[NSMutableString alloc]initWithFormat:@"%@",deviceToken];
    [token setString:[token stringByReplacingOccurrencesOfString:@"<" withString:@""]];
    [token setString:[token stringByReplacingOccurrencesOfString:@">" withString:@""]];
    [token setString:[token stringByReplacingOccurrencesOfString:@" " withString:@""]];
    
    NSLog(@"%@",token);
}
//push : 어플 실행중에 알림도착
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"userInfo : %@", userInfo);
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    NSLog(@"Alert : %@", [aps valueForKey:@"alert"]);
    
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:[aps valueForKey:@"alert"] message:@"" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    [alertView show];
    
    //application.applicationState
}

- (void)transitionToViewController:(UIViewController *)viewController
                    withTransition:(UIViewAnimationOptions)transition
{
//    [UIView transitionFromView:self.window.rootViewController.view
//                        toView:viewController.view
//                      duration:0.65f
//                       options:transition
//                    completion:^(BOOL finished){
//                        
//                        self.window.rootViewController = viewController;
//                    }];
    
    [UIView transitionWithView:self.window
                      duration:1.0f
                       options: UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        self.window.rootViewController = viewController;
                    }
                    completion:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
