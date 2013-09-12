//
//  ViewController.m
//  00Promise
//
//  Created by Rangken on 13. 9. 8..
//  Copyright (c) 2013년 SocialInovation. All rights reserved.
//

#import "ViewController.h"
#import "MainViewController.h"
#import "UIImageView+LBBlurredImage.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_imgView setImageToBlur:[UIImage imageNamed:@"arnold.png"]
                        blurRadius:kLBBlurredImageDefaultBlurRadius
                   completionBlock:^(NSError *error){
                       NSLog(@"The blurred image has been setted");
                   }];
    
    NSTimer* timer = [NSTimer timerWithTimeInterval:1.5f target:self selector:@selector(goToMain) userInfo:nil repeats:FALSE];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

- (void)viewDidAppear:(BOOL)animated
{
    
}

- (void)goToMain{
    [self performSegueWithIdentifier:@"GoToMainModal" sender:self];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
