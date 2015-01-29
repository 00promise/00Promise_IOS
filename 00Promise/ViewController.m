//
//  ViewController.m
//  00Promise
//
//  Created by Rangken on 13. 9. 8..
//  Copyright (c) 2013년 SocialInovation. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "UIImageView+LBBlurredImage.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (IS_IPHONE_5) {
        UIImageView* imgView;
        //imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Splash_640x1136.png"]];
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
        imgView.image = [UIImage imageNamed:@"Default-568h.png"];
        if ([[UIDevice currentDevice].systemVersion floatValue] < 7.0) {
            [imgView setFrame:CGRectMake(0, -20, 320, 568)];
        }
        [self.view addSubview:imgView];
    }else{
        UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
        imgView.image = [UIImage imageNamed:@"Default.png"];
        if ([[UIDevice currentDevice].systemVersion floatValue] < 7.0) {
            [imgView setFrame:CGRectMake(0, 0, 320, 480)];
        }
        [self.view addSubview:imgView];
    }
//    [_imgView setImageToBlur:[UIImage imageNamed:@"arnold.png"]
//                        blurRadius:kLBBlurredImageDefaultBlurRadius
//                   completionBlock:^(NSError *error){
//                       NSLog(@"The blurred image has been setted");
//                   }];
//    
    self.view.backgroundColor = [UIColor clearColor];
    NSTimer* timer = [NSTimer timerWithTimeInterval:1.5f target:self selector:@selector(goToMain) userInfo:nil repeats:FALSE];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

- (void)viewDidAppear:(BOOL)animated
{
    
}

- (void)goToMain{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UINavigationController* naviViewController = [storyboard instantiateViewControllerWithIdentifier:@"mainNavigationController"];
    
    CATransition* transition = [CATransition animation];
    transition.duration = 1;
    transition.type = kCATransitionFade;
    transition.subtype = kCATransitionFromBottom;
    [self.view.window.layer addAnimation:transition forKey:kCATransition];
     
    [self presentViewController:naviViewController animated:NO completion:nil];
}

- (void)goToLogin{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    LoginViewController* loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
    
    CATransition* transition = [CATransition animation];
    transition.duration = 1;
    transition.type = kCATransitionFade;
    transition.subtype = kCATransitionFromBottom;
    [self.view.window.layer addAnimation:transition forKey:kCATransition];
    
    [self presentViewController:loginViewController animated:FALSE completion:nil];
}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
