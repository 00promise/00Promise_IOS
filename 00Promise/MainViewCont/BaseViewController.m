//
//  BaseViewController.m
//  00Promise
//
//  Created by Rangken on 13. 9. 18..
//  Copyright (c) 2013년 SocialInovation. All rights reserved.
//

#import "BaseViewController.h"
#import "CandidateCell.h"
#import <FSExtendedAlertKit/FSExtendedAlertKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
@interface BaseViewController () <SuperViewControllerDelegate, UIScrollViewDelegate>
@property (nonatomic, weak) IBOutlet UIButton* issueBtn;
@property (nonatomic, weak) IBOutlet UIButton* politicianBtn;
@property (nonatomic, weak) IBOutlet UIScrollView* scrollView;

@property (nonatomic, strong) NSMutableArray* searchArr;
@end

@implementation BaseViewController

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
    [self setNeedsStatusBarAppearanceUpdate];
}
- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    
}
- (void)viewWillAppear:(BOOL)animated{
    // TODO : 네이게이션에서 루트로 돌아오면 스크롤뷰 오프셋이 0으로 바뀜 - 이유를 몰라서 땜빵이로
    if (_type == BaseViewIssue) {
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:FALSE];
    }else if(_type == BaseViewSearch) {
        [_scrollView setContentOffset:CGPointMake(320, 0) animated:FALSE];
    }
}
- (void)viewDidAppear:(BOOL)animated{
    
    if (IS_UNDER_IOS7) {
        //[_bottomNaviBarView setFrame:CGRectMake(0, 5, 320, 3)];
        //[_scrollView setFrame:CGRectMake(0, 3, 320, _scrollView.frame.size.height)];
    }
}

- (void)initVariable{
    _type = BaseViewIssue;
    _searchArr = [NSMutableArray new];
}
- (void)initView{
    _scrollView.contentSize = CGSizeMake(320, 460);
    //_scrollView.pagingEnabled = YES;
    /*
    _locationView = [[[NSBundle mainBundle] loadNibNamed:@"LocationView" owner:nil options:nil] objectAtIndex:0];
    _locationView.parentViewCont = self;
    [_locationView setFrame:CGRectMake(0, 0, 320, 568)];
    [_scrollView addSubview:_locationView];
    
    _mainView = [[[NSBundle mainBundle] loadNibNamed:@"MainView" owner:nil options:nil] objectAtIndex:0];
    _mainView.parentViewCont = self;
    [_mainView setFrame:CGRectMake(320, 0, 320, 568)];
    [_scrollView addSubview:_mainView];
    */
   
    _hotIssueView = [[[NSBundle mainBundle] loadNibNamed:@"HotIssueView" owner:nil options:nil] objectAtIndex:0];
    _hotIssueView.parentViewCont = self;
    [_hotIssueView setFrame:CGRectMake(0, 0, 320, 568)];
    [_scrollView addSubview:_hotIssueView];
    
    _searchView = [[[NSBundle mainBundle] loadNibNamed:@"SearchView" owner:nil options:nil] objectAtIndex:0];
    _searchView.parentViewCont = self;
    [_searchView setBackgroundColor:[UIColor clearColor]];
    [_searchView setFrame:CGRectMake(320, 0, 320, 568)];
    [_scrollView addSubview:_searchView];
    
}

- (IBAction)leftSwipeGesutre:(id)sender{
    if (_scrollView.contentOffset.x == 0) {
        [self moveToIdx:1];
    }
}

- (IBAction)rightSwipeGesture:(id)sender{
    if (_scrollView.contentOffset.x == 320) {
        [self moveToIdx:0];
    }
}

// 네이게이션 바를 클릭했을때!
- (void)navBarClick{
    
}

- (IBAction)hotIssueClick{
    [self moveToIdx:0];
}


- (IBAction)politicianClick{
    [self moveToIdx:1];
}

- (void)moveToIdx:(NSInteger)idx{
    if (idx == 0) {
        _type = BaseViewIssue;
        [_issueBtn setSelected:TRUE];
        [_politicianBtn setSelected:FALSE];
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:TRUE];
        [_hotIssueView viewDidSlide];
        [_searchView viewUnSilde];
    }else if (idx == 1) {
        _type = BaseViewSearch;
        [_issueBtn setSelected:FALSE];
        [_politicianBtn setSelected:TRUE];
        [_scrollView setContentOffset:CGPointMake(320, 0) animated:TRUE];
        [_hotIssueView viewUnSilde];
        [_searchView viewDidSlide];
    }
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 메인뷰의 스크롤을 고정시키기 위함
    /*
    if (scrollView == _scrollView) {
        [scrollView setContentOffset: CGPointMake(scrollView.contentOffset.x, 0)];
    }
    if (scrollView.contentOffset.x == 0) {
        [_locationView startLocationManager];
    }
     */
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
