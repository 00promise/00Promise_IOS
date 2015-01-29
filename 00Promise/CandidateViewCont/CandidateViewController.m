//
//  CandidateViewController.m
//  00Promise
//
//  Created by Rangken on 13. 9. 27..
//  Copyright (c) 2013년 SocialInovation. All rights reserved.
//

#import "CandidateViewController.h"
#import "CandidateInfoCell.h"
#import "CandidateDetailInfoCell.h"
#import "PledgeListCell.h"
#import "MoreInfoCell.h"
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
    _linkOn = TRUE;
    _profileOn = FALSE;
}
- (void)initView{
    _candidateTopView = [[[NSBundle mainBundle] loadNibNamed:@"CandidateTopView" owner:nil options:nil] objectAtIndex:0];
    //[_candidateTopView setBackgroundColor:[UIColor colorWithHex:@"#DC5A14" alpha:1.0f]];
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
    
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 227-20)];
    _tableView.tableHeaderView.backgroundColor = [UIColor whiteColor];
    
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
    if (indexPath.section == 0) {
        if (_profileOn) {
            if (indexPath.row == 4) {
                CGSize expectedLabelSize = [_politician.memo sizeWithFont:[UIFont boldSystemFontOfSize:15.0] constrainedToSize:CGSizeMake(200, 200)];
                if (expectedLabelSize.height > 20) {
                    return 77;
                }
                return 55;
            }else if (indexPath.row == 5) {
                return 186;
            }else if (indexPath.row == 6) {
                return 50;
            }
            return 55;
        }else{
            if (indexPath.row == 2) {
                return 185;
            }else if (indexPath.row == 3) {
                return 50;
            }
            return 55;
        }
        
    }
    return 100;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if (_profileOn) {
            return 7;
        }else{
            return 4;
        }
    }
    return 10;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            CandidateInfoCell *cell = (CandidateInfoCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil){
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CandidateInfoCell" owner:nil options:nil];
                cell = [topLevelObjects objectAtIndex:0];
            }
            cell.nameLabel.text = @"선거구명";
            cell.infoLabel.text = _politician.positionName;
            return cell;
        }else if (indexPath.row == 1) {
            CandidateInfoCell *cell = (CandidateInfoCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil){
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CandidateInfoCell" owner:nil options:nil];
                cell = [topLevelObjects objectAtIndex:0];
            }
            cell.nameLabel.text = @"소속정당명";
            cell.infoLabel.text = _politician.partyName;
            return cell;
        }else if (indexPath.row == 2 && _profileOn) {
            CandidateInfoCell *cell = (CandidateInfoCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil){
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CandidateInfoCell" owner:nil options:nil];
                cell = [topLevelObjects objectAtIndex:0];
            }
            cell.nameLabel.text = @"생년원일";
            cell.infoLabel.text = [NSString stringWithFormat:@"%@(%ld)",_politician.birthDayStr,_politician.currentAge.integerValue];
            return cell;
        }else if (indexPath.row == 3 && _profileOn) {
            CandidateInfoCell *cell = (CandidateInfoCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil){
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CandidateInfoCell" owner:nil options:nil];
                cell = [topLevelObjects objectAtIndex:0];
            }
            cell.nameLabel.text = @"학력";
            cell.infoLabel.text = _politician.academic;
            return cell;
        }else if (indexPath.row == 4 && _profileOn) {
            CandidateInfoCell *cell = (CandidateInfoCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil){
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CandidateInfoCell" owner:nil options:nil];
                cell = [topLevelObjects objectAtIndex:0];
            }
            cell.nameLabel.text = @"경력";
            cell.infoLabel.text = _politician.memo;
            CGSize expectedLabelSize = [_politician.memo sizeWithFont:cell.infoLabel.font constrainedToSize:CGSizeMake(cell.infoLabel.frame.size.width, 200)];
            if (expectedLabelSize.height > 20) {
                [cell.infoLabel setFrame:CGRectMake(cell.infoLabel.frame.origin.x, cell.infoLabel.frame.origin.y+8, cell.infoLabel.frame.size.width, cell.infoLabel.frame.size.height)];
                [cell.lineView setFrame:CGRectMake(cell.lineView.frame.origin.x, cell.lineView.frame.origin.y+10, cell.lineView.frame.size.width, cell.lineView.frame.size.height)];
            }
            return cell;
        }else if (indexPath.row == 5 || (!_profileOn && indexPath.row == 2)) {
            CandidateDetailInfoCell *cell = (CandidateDetailInfoCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil){
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CandidateDetailInfoCell" owner:nil options:nil];
                cell = [topLevelObjects objectAtIndex:0];
            }
            NSString* propertyStr = [NSNumberFormatter
                                     localizedStringFromNumber:_politician.property
                                     numberStyle:NSNumberFormatterDecimalStyle];;
            if (propertyStr == NULL) {
                propertyStr = @"-";
            }
            
            NSString* militaryStr = _politician.military;
            if (militaryStr == NULL) {
                militaryStr = @"-";
            }
            NSString* paymentStr = [NSNumberFormatter
                                       localizedStringFromNumber:_politician.payment
                                       numberStyle:NSNumberFormatterDecimalStyle];
            if (paymentStr == NULL) {
                paymentStr = @"-";
            }
            NSString* arrearsStr = [NSNumberFormatter
                                    localizedStringFromNumber:_politician.arrears
                                    numberStyle:NSNumberFormatterDecimalStyle];
            if (arrearsStr == NULL) {
                arrearsStr = @"-";
            }
            NSString* nowArrearsStr = [NSNumberFormatter
                                       localizedStringFromNumber:_politician.nowArrears
                                       numberStyle:NSNumberFormatterDecimalStyle];
            if (nowArrearsStr == NULL) {
                nowArrearsStr = @"-";
            }
            NSString* crimeStr = _politician.crime;
            if (crimeStr == NULL) {
                crimeStr = @"-";
            }
            NSString* descriptionStr = [NSString stringWithFormat:@"재산신고액(천원) : %@\n병역신고(본인) : %@\n납부액(천원) : %@\n당해년도체납액(천원) : %@\n현체납액(천원) : %@\n전과유무(건수) : %@",propertyStr, militaryStr, paymentStr, arrearsStr,nowArrearsStr, crimeStr];
            
            NSString *labelText = descriptionStr;
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineSpacing:8];
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
            cell.detailLabel.attributedText = attributedString ;

            return cell;
        }else if (indexPath.row == 6 || (!_profileOn && indexPath.row == 3)) {
            MoreInfoCell *cell = (MoreInfoCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil){
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"MoreInfoCell" owner:nil options:nil];
                cell = [topLevelObjects objectAtIndex:0];
            }
            if (_profileOn) {
                cell.nameLabel.text = @"정보 접어두기";
            }else{
                cell.nameLabel.text = @"정보 더보기";
            }
            return cell;
        }
    }else{
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
    }
    
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
    if (indexPath.section == 0) {
        if (_profileOn) {
            if (indexPath.row == 6) {
                _profileOn = !_profileOn;
                [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
            }
        }else{
            if (indexPath.row == 3) {
                _profileOn = !_profileOn;
                [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
            }
        }
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
