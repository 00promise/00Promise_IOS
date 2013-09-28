//
//  AppDelegate.h
//  00Promise
//
//  Created by Rangken on 13. 9. 8..
//  Copyright (c) 2013년 SocialInovation. All rights reserved.
//

#import <UIKit/UIKit.h>

#define _SERVER_LOG_ // 서버 로그 출력

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_5 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0f)
#define IS_RETINA ([[UIScreen mainScreen] scale] == 2.0f)
#define IS_IOS7 [[UIDevice currentDevice].systemVersion floatValue] >= 7.0
#define IS_UNDER_IOS7 [[UIDevice currentDevice].systemVersion floatValue] < 7.0
#define APP_DELEGATE (AppDelegate*)[[UIApplication sharedApplication] delegate]
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
- (void)transitionToViewController:(UIViewController *)viewController
                    withTransition:(UIViewAnimationOptions)transition;
@end

