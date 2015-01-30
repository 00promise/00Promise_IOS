//
//  LoginViewController.h
//  00Promise
//
//  Created by Rangken on 13. 9. 28..
//  Copyright (c) 2013년 SocialInovation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KakaoOpenSDK/KakaoOpenSDK.h>
@interface LoginViewController : UIViewController
@property (nonatomic, weak) IBOutlet UITextField* emailTextField;
@property (nonatomic, weak) IBOutlet UITextField* passwordTextField;
@end
