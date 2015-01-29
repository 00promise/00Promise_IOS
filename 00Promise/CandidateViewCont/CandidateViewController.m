//
//  CandidateViewController.m
//  00Promise
//
//  Created by Rangken on 13. 9. 27..
//  Copyright (c) 2013년 SocialInovation. All rights reserved.
//

#import "CandidateViewController.h"
#import "CandidateInfoCell.h"
#import "PledgeListCell.h"
#import "PledgeViewController.h"
#import "JYGraphic.h"
#import "DateUtil.h"
#import "CandidateTopView.h"
#import <FSExtendedAlertKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
@interface CandidateViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
@property (nonatomic, weak) IBOutlet UITableView* tableView;
@property (nonatomic, strong) CandidateTopView* candidateTopView;
@property (nonatomic, assign) NSInteger profileImgSize;
@property (nonatomic, assign) BOOL profileOn;
@property (nonatomic, assign) BOOL linkOn;
@end

@implementation CandidateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"leads_calls_to_detail"])
    {
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
}
- (void)initVariable{
    memoHeight = 0;
}
- (void)initView{
    _candidateTopView = [[[NSBundle mainBundle] loadNibNamed:@"CandidateTopView" owner:nil options:nil] objectAtIndex:0];
    _candidateTopView.parent = self;
    [_candidateTopView.backImgView setImageWithURL:[NSURL URLWithString:[_politician bgImg]] placeholderImage:[UIImage imageNamed:@"bg_default.png"] options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){
        
    }];
    [JYGraphic setRoundedView:_candidateTopView.profileImgView toDiameter:_candidateTopView.profileImgView.frame.size.width];
    [_candidateTopView.profileImgView setImageWithURL:[NSURL URLWithString:[_politician img]] placeholderImage:[UIImage imageNamed:@"feed_bg_profile01.png"] options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){
        
    }];
    _profileImgSize = _candidateTopView.profileImgView.frame.size.width;
    _candidateTopView.nameLabel.text = _politician.name;
    _candidateTopView.positionLabel.text = _politician.positionName;
    [_candidateTopView setFrame:CGRectMake(0, 0, 320, 227)];
    [self.view addSubview:_candidateTopView];
    
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 227-80)];
    _tableView.tableHeaderView.backgroundColor = [UIColor clearColor];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[AFAppDotNetAPIClient sharedClient] getPath:[NSString stringWithFormat:@"politicians/%ld.json",_politicianId] parameters:nil success:^(AFHTTPRequestOperation *response, id responseObject) {
#ifdef _SERVER_LOG_
        NSLog(@"politicians/@id.json : %@",(NSDictionary *)responseObject);
#endif
        NSString* code = [responseObject objectForKey:@"code"];
        if (![code isEqualToString:@"0000"]) {
            FSBlockButton *cancelButton = [FSBlockButton blockButtonWithTitle:@"확인" block:^ {
            }];
            FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"에러" message:[responseObject objectForKey:@"message"] cancelButton:cancelButton otherButtons: nil];
            [alert show];
        }else{
            NSDictionary* politicianDic = [NSDictionary dictionaryWithObject:[responseObject objectForKey:@"data"] forKey:@"politician"];
            _politician = [Politician new];
            [_politician setPropertiesUsingRemoteDictionary:politicianDic];
            
            NSString *string = [_politician.memo stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            CGSize expectedLabelSize = [string sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(285, 200)];
            memoHeight = expectedLabelSize.height;
            [_tableView reloadData];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
#ifdef _SERVER_LOG_
        NSLog(@"politicians/@id.json [HTTPClient Error]: %@", error.localizedDescription);
#endif
        FSBlockButton *cancelButton = [FSBlockButton blockButtonWithTitle:@"확인" block:^ {
            [self.navigationController popViewControllerAnimated:TRUE];
        }];
        FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"에러" message:@"정보를 가져올수 없습니다." cancelButton:cancelButton otherButtons: nil];
        [alert show];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
- (IBAction)backItemClick:(id)sender{
    [self dismissViewControllerAnimated:TRUE completion:nil];
}
- (IBAction)shareClick:(id)sender{
    //NSString *text = [NSString stringWithFormat:@"%@ - %@",_politician.positionName, _politician.name];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/politicians/%ld",RAILS_BASE_URL,_politician.ID.integerValue]];
    //UIImage *image = _candidateTopView.profileImgView.image;
    
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[url]applicationActivities:nil];
    
    [self presentViewController:controller animated:YES completion:nil];
    
}
- (void)animationForTableView{
    CGFloat offset = self.tableView.contentOffset.y;
    if (self.tableView.contentOffset.y < 0) {
        _candidateTopView.frame = CGRectMake(0, 0, self.view.frame.size.width+ (-offset) * 2, 227 + (-offset));
        _candidateTopView.backImgView.center = CGPointMake(160, _candidateTopView.profileImgView.center.y);
        _candidateTopView.profileImgView.center = CGPointMake(160, _candidateTopView.profileImgView.center.y);
        _candidateTopView.nameLabel.alpha = 1.0f;
        _candidateTopView.positionLabel.alpha = 1.0f;
        [JYGraphic setRoundedView:_candidateTopView.profileImgView toDiameter:_candidateTopView.profileImgView.frame.size.width];
    }else{
        _candidateTopView.nameLabel.alpha = (272-offset*3)/272.0f;
        _candidateTopView.positionLabel.alpha = (272-offset*3)/272.0f;
        _candidateTopView.frame = CGRectMake(0, 0, 320, 227 + (-offset));
        [JYGraphic setRoundedView:_candidateTopView.profileImgView toDiameter:_profileImgSize*(272-offset)/272.0f];
    }
    //[_candidateTopView setAlpha:(272+offset)/272.0f];
}
#pragma mark UITableViewDelegate UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    PledgeListCell *cell = (PledgeListCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil){
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PledgeListCell" owner:nil options:nil];
        cell = [topLevelObjects objectAtIndex:0];
        
    }
    Manifesto* manifesto = [_politician.manifestos objectAtIndex:0];
    UIImage *backImage;
    if (indexPath.row == 0) {
        backImage = [UIImage imageNamed:@"list_bg01.png"];
        cell.backImgView.frame = CGRectMake(10, 0, 300, 57);
    }else if(indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1){
        backImage = [UIImage imageNamed:@"list_bg03.png"];
        cell.backImgView.frame = CGRectMake(10, 0, 300, 58);
    }else{
        backImage = [UIImage imageNamed:@"list_bg02.png"];
        cell.backImgView.frame = CGRectMake(10, 0, 300, 56);
    }
    
    cell.backImgView.image = [backImage stretchableImageWithLeftCapWidth:3 topCapHeight:3];
    cell.titleLabel.text = manifesto.title;
    int maxRatingCnt = MAX(manifesto.goodCnt.integerValue, MAX(manifesto.fairCnt.integerValue, manifesto.poorCnt.integerValue));
    if (maxRatingCnt == manifesto.goodCnt.integerValue) {
        cell.ratingImgView.image = [UIImage imageNamed:@"appraisal_icon04.png"];
        cell.ratingCntLabel.text = [NSString stringWithFormat:@"%d",manifesto.goodCnt.integerValue];
    }else if (maxRatingCnt == manifesto.fairCnt.integerValue) {
        cell.ratingImgView.image = [UIImage imageNamed:@"appraisal_icon05.png"];
        cell.ratingCntLabel.text = [NSString stringWithFormat:@"%d",manifesto.fairCnt.integerValue];
    }else if (maxRatingCnt == manifesto.poorCnt.integerValue) {
        cell.ratingImgView.image = [UIImage imageNamed:@"appraisal_icon06.png"];
        cell.ratingCntLabel.text = [NSString stringWithFormat:@"%d",manifesto.poorCnt.integerValue];
    }
    cell.replyCntLabel.text = [NSString stringWithFormat:@"%d",manifesto.replyCnt.integerValue];
    return cell;
    /*
    if (indexPath.section == 0) {
        CandidateInfoCell *cell = (CandidateInfoCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil){
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CandidateInfoCell" owner:nil options:nil];
            cell = [topLevelObjects objectAtIndex:0];
            
        }
        [JYGraphic setRoundedView:cell.politicianImgView toDiameter:88.0f];
        UIImage *backImage = [UIImage imageNamed:@"profile_bg01.png"];
        cell.backImgView.image = [backImage stretchableImageWithLeftCapWidth:3 topCapHeight:3];
        
        if ([_politician haveImg]) {
            [cell.politicianImgView setImageWithURL:[NSURL URLWithString:[_politician img]] placeholderImage:[UIImage imageNamed:@"feed_bg_profile01.png"] options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){
                
            }];
        }
        if ([_politician haveBgImg]) {
            [cell.bgImgView setImageWithURL:[NSURL URLWithString:[_politician bgImg]] placeholderImage:[UIImage imageNamed:@"bg_default.png"] options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){
                
            }];
        }
        cell.nameLabel.text = _politician.name;
        cell.birthLabel.text = [DateUtil dateStringByTimestamp:_politician.birthday.longLongValue];
        cell.positionLabel.text = [NSString stringWithFormat:@"현재 제 %@ (%@)",_politician.positionName,_politician.partyName];
        cell.positionHistoryLabel.text = _politician.memo;
        cell.positionHistoryLabel.frame = CGRectMake(cell.positionHistoryLabel.frame.origin.x, cell.positionHistoryLabel.frame.origin.y, cell.positionHistoryLabel.frame.size.width, memoHeight);
        return cell;
    }else{
        PledgeListCell *cell = (PledgeListCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil){
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PledgeListCell" owner:nil options:nil];
            cell = [topLevelObjects objectAtIndex:0];
            
        }
        Manifesto* manifesto = [_politician.manifestos objectAtIndex:indexPath.row];
        UIImage *backImage;
        if (indexPath.row == 0) {
            backImage = [UIImage imageNamed:@"list_bg01.png"];
            cell.backImgView.frame = CGRectMake(10, 0, 300, 57);
        }else if(indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1){
            backImage = [UIImage imageNamed:@"list_bg03.png"];
            cell.backImgView.frame = CGRectMake(10, 0, 300, 58);
        }else{
            backImage = [UIImage imageNamed:@"list_bg02.png"];
            cell.backImgView.frame = CGRectMake(10, 0, 300, 56);
        }
        
        cell.backImgView.image = [backImage stretchableImageWithLeftCapWidth:3 topCapHeight:3];
        cell.titleLabel.text = manifesto.title;
        int maxRatingCnt = MAX(manifesto.goodCnt.integerValue, MAX(manifesto.fairCnt.integerValue, manifesto.poorCnt.integerValue));
        if (maxRatingCnt == manifesto.goodCnt.integerValue) {
            cell.ratingImgView.image = [UIImage imageNamed:@"appraisal_icon04.png"];
            cell.ratingCntLabel.text = [NSString stringWithFormat:@"%d",manifesto.goodCnt.integerValue];
        }else if (maxRatingCnt == manifesto.fairCnt.integerValue) {
            cell.ratingImgView.image = [UIImage imageNamed:@"appraisal_icon05.png"];
            cell.ratingCntLabel.text = [NSString stringWithFormat:@"%d",manifesto.fairCnt.integerValue];
        }else if (maxRatingCnt == manifesto.poorCnt.integerValue) {
            cell.ratingImgView.image = [UIImage imageNamed:@"appraisal_icon06.png"];
            cell.ratingCntLabel.text = [NSString stringWithFormat:@"%d",manifesto.poorCnt.integerValue];
        }
        cell.replyCntLabel.text = [NSString stringWithFormat:@"%d",manifesto.replyCnt.integerValue];
        return cell;
    }
     */
    
    return NULL;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        Manifesto* manifesto = [_politician.manifestos objectAtIndex:indexPath.row];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PledgeViewController* pledgeViewCont = [storyboard instantiateViewControllerWithIdentifier:@"pledgeViewController"];
        pledgeViewCont.manifestoId = manifesto.ID.integerValue;
        [self.navigationController pushViewController:pledgeViewCont animated:TRUE];
    }
}
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self animationForTableView];
    if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height) {
        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, scrollView.contentSize.height - scrollView.frame.size.height)];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self animationForTableView];
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self animationForTableView];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
