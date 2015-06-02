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
#import "CandidateLinkCell.h"
#import "ReplyCell.h"
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
    _linkOn = FALSE;
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 50;
    }else if(section == 2){
        return 70;
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 200, 20)];
        label.font = [UIFont boldSystemFontOfSize:15];
        label.text = @"관련기사";
        label.textColor = [UIColor colorWithHex:@"#888888" alpha:1.0f];
        [view addSubview:label];
        UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 49, 290, 1)];
        lineView.backgroundColor = [UIColor colorWithHex:@"#b2b2b2" alpha:1.0f];
        [view addSubview:lineView];
        return view;
    }else if(section == 2){
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 200, 20)];
        label.font = [UIFont boldSystemFontOfSize:15];
        label.text = [NSString stringWithFormat:@"댓글 %ld",[_politician.replies count]];
        label.textColor = [UIColor colorWithHex:@"#808080" alpha:1.0f];
        [view addSubview:label];
        UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 49, 290, 1)];
        [view addSubview:lineView];
        return view;
    }
    return nil;
}
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
                // 더보기 접기
                return 50;
            }
            return 55;
        }else{
            if (indexPath.row == 2) {
                return 185;
            }else if (indexPath.row == 3) {
                // 더보기 접기
                return 50;
            }
            return 55;
        }
        
    }else if (indexPath.section == 1){
//        if (indexPath.row == [_politician.links count] || (!_linkOn && indexPath.row == 2)) {
        if (false) {
            // 더보기 접기
            return 50;
        }else{
            Link* link = [_politician.links objectAtIndex:indexPath.row];
            NSString* linkTitle = link.title;
            CGSize expectedLabelSize = [linkTitle sizeWithFont:[UIFont boldSystemFontOfSize:15.0] constrainedToSize:CGSizeMake(280, 200)];
            
            if (expectedLabelSize.height > 20) {
                return 95;
            }else{
                return 71;
            }
        }
    }else if (indexPath.section == 2){
        Reply* reply = [_politician.replies objectAtIndex:indexPath.row];
        NSString* replyTxt = reply.content;
        CGSize expectedLabelSize = [replyTxt sizeWithFont:[UIFont boldSystemFontOfSize:15.0] constrainedToSize:CGSizeMake(280, 200)];
        
        return expectedLabelSize.height + 30;
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
    else if (section == 1) {
        return [_politician.links count];
    }else if (section == 2){
        return [_politician.replies count];
    }
    
    return 10;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
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
    }else if(indexPath.section == 1){
//        if (indexPath.row == [_politician.links count] || (!_linkOn && indexPath.row == 2)) {
        if (false) {
            MoreInfoCell *cell = (MoreInfoCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil){
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"MoreInfoCell" owner:nil options:nil];
                cell = [topLevelObjects objectAtIndex:0];
            }
            if (_linkOn) {
                cell.nameLabel.text = @"기사 접어두기";
            }else{
                cell.nameLabel.text = [NSString stringWithFormat:@"%ld개 기사 더보기",[_politician.links count]-2];
            }
            return cell;
        }else {
            CandidateLinkCell *cell = (CandidateLinkCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil){
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CandidateLinkCell" owner:nil options:nil];
                cell = [topLevelObjects objectAtIndex:0];
            }
            Link* link = [_politician.links objectAtIndex:indexPath.row];
            NSString* linkTitle = link.title;
            cell.titleLabel.text = link.title;
            cell.pressLabel.text = [NSString stringWithFormat:@"%@ | %@",link.press, [DateUtil dateStringByTimestamp:link.updatedAt.longValue]];
            CGSize expectedLabelSize = [linkTitle sizeWithFont:[UIFont boldSystemFontOfSize:15.0] constrainedToSize:CGSizeMake(280, 200)];
            if (expectedLabelSize.height < 20) {
                cell.titleLabel.frame = CGRectMake(cell.titleLabel.frame.origin.x, cell.titleLabel.frame.origin.y-10, cell.titleLabel.frame.size.width, cell.titleLabel.frame.size.height);
                cell.pressLabel.frame = CGRectMake(cell.pressLabel.frame.origin.x, cell.pressLabel.frame.origin.y-25, cell.pressLabel.frame.size.width, cell.pressLabel.frame.size.height);
                cell.lineView.frame = CGRectMake(cell.lineView.frame.origin.x, cell.lineView.frame.origin.y-25, cell.lineView.frame.size.width, cell.lineView.frame.size.height);
            }
            return cell;
        }
    }else if(indexPath.section == 2){
        ReplyCell *cell = (ReplyCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil){
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ReplyCell" owner:nil options:nil];
            cell = [topLevelObjects objectAtIndex:0];
            
        }
        Reply* reply = [_politician.replies objectAtIndex:indexPath.row];
        cell.nameLabel.text = reply.username;
        cell.createdAtLabel.text = [DateUtil timeDateStringByTimestamp:reply.createdAt.longLongValue];
        cell.contentLabel.text = reply.content;
        cell.ratingAgreeLabel.text = [NSString stringWithFormat:@"좋아요 %ld",reply.agreeCnt.integerValue];
        cell.ratingDisAgreeLabel.text = [NSString stringWithFormat:@"싫어요 %ld",reply.disagreeCnt.integerValue];
        cell.agreeBtn.tag = indexPath.row;
        cell.disAgreeBtn.tag = indexPath.row;
        return cell;
    }
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
    }else if (indexPath.section == 1) {
        if (_linkOn) {
            if (indexPath.row == [_politician.links count]) {
                _linkOn = !_linkOn;
                [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
            }
        }else{
            if (indexPath.row == 2) {
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
    //[self animationForTableView];
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    //[self animationForTableView];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
