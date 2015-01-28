//
//  SuperViewController.m
//  00Promise
//
//  Created by Digitalfrog on 13. 9. 12..
//  Copyright (c) 2013년 SocialInovation. All rights reserved.
//

#import "SuperViewController.h"
#import "BaseViewController.h"
#import "PledgeViewController.h"
#import "CandidateViewController.h"
#import "CandidateListViewController.h"
#import "LocationViewController.h"
#import "FavoriteLocationViewController.h"
#import "SearchListViewController.h"
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
    self.automaticallyAdjustsScrollViewInsets = FALSE;
    UINavigationBar *navBar = self.navigationController.navigationBar;
    
    UIView *overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, 1)];
    [overlayView setBackgroundColor:[UIColor whiteColor]];
    [navBar setBackgroundColor:[UIColor whiteColor]];
    [navBar addSubview:overlayView];
    
     
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithHex:@"#DC5A14" alpha:1.0f]];
    [[UINavigationBar appearance] setTranslucent:NO];
    //UIImage *image = [UIImage imageNamed:@"top_bg01.png"];
    //[navBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    /*
    UIImage *centerBtnImg=[UIImage imageNamed:@"top_btn02.png"];
    UIImage *centerBtnImgOn=[UIImage imageNamed:@"top_btn02.png"];
    UIButton *centerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [centerBtn setImage:centerBtnImg forState:UIControlStateNormal];
    [centerBtn setImage:centerBtnImgOn forState:UIControlStateHighlighted];
    [centerBtn addTarget:self action:@selector(centerItemClick) forControlEvents:UIControlEventTouchUpInside];
    [centerBtn setCenter:CGPointMake(160, 0)];
    self.navigationItem.titleView = centerBtn;
    */
//    titleImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top_btn02.png"]];
//    [titleImgView setCenter:CGPointMake(160, 18)];
//    [navBar addSubview:titleImgView];

    if ([self isKindOfClass:[LocationViewController class]] || [self isKindOfClass:[FavoriteLocationViewController class]] || [self isKindOfClass:[SearchListViewController class]]) {
        titleLabel=[[UILabel alloc]init];
        
        titleLabel.font=[UIFont boldSystemFontOfSize:19];
        //titleLabel.shadowColor = [UIColor whiteColor];
        
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor=[UIColor clearColor];
        titleLabel.textColor=[UIColor whiteColor];
        titleLabel.frame=CGRectMake(0,0, 150, 44);
        titleLabel.center=CGPointMake(160, 22);
        self.navigationItem.titleView=titleLabel;
    }else{
        titleImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_title.png"]];
        [titleImgView setCenter:CGPointMake(160, 18)];
        self.navigationItem.titleView=titleImgView;
    }
    /*
    CGRect frame = CGRectMake(self.view.frame.size.width/4, 0, self.view.frame.size.width/2, 44);
    UIView *navBarTapView = [[UIView alloc] initWithFrame:frame];
    [navBar addSubview:navBarTapView];
    
    UIImage *leftBtnImg=[UIImage imageNamed:@"top_btn01.png"];
    UIImage *leftBtnImgOn=[UIImage imageNamed:@"top_btn01.png"];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:leftBtnImg forState:UIControlStateNormal];
    [leftBtn setImage:leftBtnImgOn forState:UIControlStateHighlighted];
    [leftBtn addTarget:self action:@selector(leftItemClick) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.frame = CGRectMake(0, 0,leftBtnImg.size.width, leftBtnImg.size.height);
    
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc]
                                   initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
    
    UIImage *rightBtnImg=[UIImage imageNamed:@"top_btn03.png"];
    UIImage *rightBtnImgOn=[UIImage imageNamed:@"top_btn03.png"];
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:rightBtnImg forState:UIControlStateNormal];
    [rightBtn setImage:rightBtnImgOn forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.frame = CGRectMake(0, 0,rightBtnImg.size.width, rightBtnImg.size.height);
    
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc]
                                    initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
    */
    if ([self isKindOfClass:[PledgeViewController class]]) {
        self.navigationItem.rightBarButtonItem = nil;
        [self setBackBtn];
    }
    if ([self isKindOfClass:[CandidateViewController class]]) {
        self.navigationItem.rightBarButtonItem = nil;
        [self setBackBtn];
    }
    if ([self isKindOfClass:[CandidateListViewController class]]) {
        self.navigationItem.rightBarButtonItem = nil;
        [self setBackBtn];
    }
    if ([self isKindOfClass:[LocationViewController class]]) {
        self.navigationItem.rightBarButtonItem = nil;
        [self setBackBtn];
    }
    if ([self isKindOfClass:[FavoriteLocationViewController class]]) {
        self.navigationItem.rightBarButtonItem = nil;
        [self setBackBtn];
    }
    if ([self isKindOfClass:[SearchListViewController class]]) {
        self.navigationItem.rightBarButtonItem = nil;
        [self setBackBtn];
    }
    id<SuperViewControllerDelegate> delegate = (id<SuperViewControllerDelegate>)self;
    if ([delegate respondsToSelector:@selector(initVariable)]) {
        [delegate initVariable];
    }
    if ([delegate respondsToSelector:@selector(initView)]) {
        [delegate initView];
    }
}

- (void)leftItemClick{
    id<SuperViewControllerDelegate> delegate = (id<SuperViewControllerDelegate>)self;
    if ([delegate respondsToSelector:@selector(leftItemClick)]) {
        [delegate leftItemClick];
    }
}

- (void)rightItemClick{
    id<SuperViewControllerDelegate> delegate = (id<SuperViewControllerDelegate>)self;
    if ([delegate respondsToSelector:@selector(rightItemClick)]) {
        [delegate rightItemClick];
    }
}
- (void)backItemClick{
    id<SuperViewControllerDelegate> delegate = (id<SuperViewControllerDelegate>)self;
    if ([delegate respondsToSelector:@selector(backItemClick)]) {
        [delegate backItemClick];
    }
}

- (void)setBackBtn{
    UIImage *rightBtnImg=[UIImage imageNamed:@"btn_back01.png"];
    UIImage *rightBtnImgOn=[UIImage imageNamed:@"btn_back01.png"];
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:rightBtnImg forState:UIControlStateNormal];
    [rightBtn setImage:rightBtnImgOn forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(backItemClick) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.frame = CGRectMake(0, 0, 12, 20);
    
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc]
                                    initWithCustomView:rightBtn];
    self.navigationItem.leftBarButtonItem = rightBarBtn;
}

- (void)setTitleLabelStr:(NSString *)str{
    titleLabel.text = str;
}

- (UIViewController *)isExistViewController:(Class)cls{
    UINavigationController* mainNaviCont = self.navigationController;
    NSArray* viewContArr = [mainNaviCont viewControllers];
    for (UIViewController* viewCont in viewContArr) {
        if ([viewCont isKindOfClass:cls]) {
            return viewCont;
        }
    }
    return nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
