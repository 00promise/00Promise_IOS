//
//  SuperViewController.m
//  00Promise
//
//  Created by Digitalfrog on 13. 9. 12..
//  Copyright (c) 2013년 SocialInovation. All rights reserved.
//

#import "SuperViewController.h"
#import "IIViewDeckController.h"
@interface SuperViewController ()

@end

@implementation SuperViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINavigationBar *navBar = self.navigationController.navigationBar;
    UIImage *image = [UIImage imageNamed:@"top_bg01.png"];
    [navBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    UIImageView* titleImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top_btn02.png"]];
    [titleImgView setCenter:CGPointMake(160, 18)];
    [navBar addSubview:titleImgView];
    
    UIImage *leftBtnImg=[UIImage imageNamed:@"top_btn01.png"];
    UIImage *leftBtnImgOn=[UIImage imageNamed:@"top_btn01.png"];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:leftBtnImg forState:UIControlStateNormal];
    [leftBtn setImage:leftBtnImgOn forState:UIControlStateHighlighted];
    [leftBtn addTarget:self.viewDeckController action:@selector(toggleLeftView) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.frame = CGRectMake(0, 0,leftBtnImg.size.width, leftBtnImg.size.height);
    
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc]
                                   initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
    
    UIImage *rightBtnImg=[UIImage imageNamed:@"top_btn03.png"];
    UIImage *rightBtnImgOn=[UIImage imageNamed:@"top_btn03.png"];
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:rightBtnImg forState:UIControlStateNormal];
    [rightBtn setImage:rightBtnImgOn forState:UIControlStateHighlighted];
    [rightBtn addTarget:self.viewDeckController action:@selector(toggleRightView) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.frame = CGRectMake(0, 0,rightBtnImg.size.width, rightBtnImg.size.height);
    
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc]
                                    initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
    
    id<SuperViewControllerDelegate> delegate = (id<SuperViewControllerDelegate>)self;
    
    [delegate initVariable];
    [delegate initView];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
