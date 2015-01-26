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
#import <FSExtendedAlertKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
@interface CandidateViewController ()

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
    NSLog(@"%@",[segue identifier]);
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
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[AFAppDotNetAPIClient sharedClient] getPath:[NSString stringWithFormat:@"politicians/%d.json",_politicianId] parameters:nil success:^(AFHTTPRequestOperation *response, id responseObject) {
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
        NSLog(@"politicians/@id.json [HTTPClient Error]: %@", error.localizedDescription);
        FSBlockButton *cancelButton = [FSBlockButton blockButtonWithTitle:@"확인" block:^ {
            [self.navigationController popViewControllerAnimated:TRUE];
        }];
        FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"에러" message:@"정보를 가져올수 없습니다." cancelButton:cancelButton otherButtons: nil];
        [alert show];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
- (void)backItemClick{
    [self.navigationController popViewControllerAnimated:TRUE];
}
#pragma mark UITableViewDelegate UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 6;
    }
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    int height = 0;
    if (section == 0) {
        height = 0;
    }else{
        height = 6;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, height)];
    [view setBackgroundColor:[UIColor clearColor]];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return 10;
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    int height = 0;
    if (section == 0) {
        height = 0;
    }else{
        height = 10;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, height)];
    [view setBackgroundColor:[UIColor clearColor]];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 234+memoHeight;
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            return 57;
        }else if(indexPath.row == [_politician.manifestos count]-1){
            return 58;
        }else{
            return 56;
        }
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if (_politician) {
            return 1;
        }
        return 0;
    }else if(section == 1){
        return [_politician.manifestos count];
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
