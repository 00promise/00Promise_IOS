//
//  MainView.m
//  00Promise
//
//  Created by Rangken on 13. 9. 19..
//  Copyright (c) 2013년 SocialInovation. All rights reserved.
//

#import "MainView.h"
#import "MainTableViewCell.h"
#import "PledgeViewController.h"
#import "AppDelegate.h"
#import "JYGraphic.h"
#import "LogoutCell.h"
#import "LoginViewController.h"
#import "DateUtil.h"
#import <FSExtendedAlertKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
@implementation MainView
- (id) initWithCoder:(NSCoder *)aCoder{
    if(self = [super initWithCoder:aCoder]){
        [self initVariable];
        [self initView];
    }
    return self;
}
- (void)awakeFromNib{
    if (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height != 568.0f) {
        [_tableView setFrame:CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y, _tableView.frame.size.width, _tableView.frame.size.height-88)];
    }
}
- (void)initVariable{
    _mainManifestoArr = [NSMutableArray new];
}
- (void)initView{
    [_tableView setHidden:TRUE];
    [_mainManifestoArr removeAllObjects];
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    [[AFAppDotNetAPIClient sharedClient] getPath:@"manifestos/daily.json" parameters:nil success:^(AFHTTPRequestOperation *response, id responseObject) {
#ifdef _SERVER_LOG_
        NSLog(@"manifestos/daily.json : %@",(NSDictionary *)responseObject);
#endif
        NSString* code = [responseObject objectForKey:@"code"];
        if (![code isEqualToString:@"0000"]) {
            FSBlockButton *cancelButton = [FSBlockButton blockButtonWithTitle:@"확인" block:^ {
            }];
            FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"에러" message:[responseObject objectForKey:@"message"] cancelButton:cancelButton otherButtons: nil];
            [alert show];
        }else{
            NSMutableArray* manifestoArr = [responseObject objectForKey:@"data"];
            for (NSDictionary* dic in manifestoArr) {
                NSDictionary* manifestoDic = [NSDictionary dictionaryWithObject:dic forKey:@"manifesto"];
                Manifesto* manifesto = [Manifesto new];
                [manifesto setPropertiesUsingRemoteDictionary:manifestoDic];
                [_mainManifestoArr addObject:manifesto];
            }
            [_tableView reloadData];
        }
        [_tableView setHidden:FALSE];
        [MBProgressHUD hideHUDForView:self animated:YES];
    } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
        NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
        FSBlockButton *cancelButton = [FSBlockButton blockButtonWithTitle:@"예" block:^ {
            [self initView];
        }];
        FSBlockButton *okButton = [FSBlockButton blockButtonWithTitle:@"아니요" block:^ {
        }];
        FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"에러" message:@"다시 시도하시겠습니까?." cancelButton:cancelButton otherButtons:okButton, nil];
        [alert show];
        [_tableView setHidden:FALSE];
        [MBProgressHUD hideHUDForView:self animated:YES];
    }];
}
- (void)layoutSubviews{
    [super layoutSubviews];
}
#pragma mark BaseViewDelegate
- (void)viewDidSlide{
    NSLog(@"viewDidSlide");
}

- (void)viewUnSilde{
}
#pragma mark UITableViewDelegate UITableViewDataSource
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    int height = 0;
    if (section == 0) {
        height = 12;
    }else{
        height = 8;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, height)];
    [view setBackgroundColor:[UIColor clearColor]];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 12;
    }else{
        return 8;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 23)];
        [view setBackgroundColor:[UIColor clearColor]];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, tableView.frame.size.width, 18)];
        [label setFont:[UIFont boldSystemFontOfSize:14]];
        [label setTextAlignment:NSTextAlignmentCenter];
        label.textColor = [UIColor colorWithHex:@"#888888" alpha:1.0f];
        NSString * version = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
        NSString * build = [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString *)kCFBundleVersionKey];
        label.text = [NSString stringWithFormat:@"현재 버전 %@.%@",version,build ];
        [view addSubview:label];
        return view;
    }
    return NULL;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        return 32;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 325;
    }else{
        return 53;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return [_mainManifestoArr count];
    }else{
        return 1;
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    if (indexPath.section == 0) {
        MainTableViewCell *cell = (MainTableViewCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"MainTableViewCell" owner:nil options:nil];
            cell = [topLevelObjects objectAtIndex:0];
        }
        [cell setFrame:CGRectMake(10, 0, 300, 296)];
        Manifesto* manifesto = [_mainManifestoArr objectAtIndex:indexPath.row];
//        if ([manifesto rangeOfString:@"missing"].location == NSNotFound) {
//            [nextView.imgView setImageWithURL:[NSURL URLWithString:[exercise img]] placeholderImage:[UIImage imageNamed:@"exercise_thumb_default.png"] options:SDWebImageRefreshCached];
//        }
        
        //cell.candidateImgView.image = [UIImage imageNamed:@"test_candidate1.png"];
        [JYGraphic setRoundedView:cell.candidateImgView toDiameter:92.0f];
        
        UIImage* backImage = [UIImage imageNamed:@"feed_bg01.png"];
        cell.backImgView1.image = [backImage stretchableImageWithLeftCapWidth:4 topCapHeight:4];
        backImage = [UIImage imageNamed:@"feed_bg02.png"];
        cell.backImgView2.image = [backImage stretchableImageWithLeftCapWidth:4 topCapHeight:4];
        
        cell.nameLabel.text = manifesto.politician.name;
        cell.titleLabel.text = manifesto.title;
        cell.userNameLabel.text = manifesto.reply.username;
        
        cell.createdAtLabel.text = [NSString stringWithFormat:@" | %@",[DateUtil dateStringByTimestamp:manifesto.reply.createdAt.longLongValue]];
        cell.contentLabel.text = manifesto.reply.content;
        int totalRatingCnt = manifesto.goodCnt.integerValue + manifesto.fairCnt.integerValue + manifesto.poorCnt.integerValue;
        cell.replyCntLabel.text = [NSString stringWithFormat:@"평가 %i개  댓글 %i개",totalRatingCnt,manifesto.replyCnt.integerValue];
        int maxRatingCnt = MAX(MAX(manifesto.goodCnt.integerValue , manifesto.fairCnt.integerValue), manifesto.poorCnt.integerValue);
        cell.bannerLabel.text = [NSString stringWithFormat:@"%i",maxRatingCnt];
        if (maxRatingCnt == manifesto.goodCnt.integerValue) {
            cell.bannerImgView.image = [UIImage imageNamed:@"feed_label01.png"];
        }else if(maxRatingCnt == manifesto.fairCnt.integerValue){
            cell.bannerImgView.image = [UIImage imageNamed:@"feed_label02.png"];
        }else{
            cell.bannerImgView.image = [UIImage imageNamed:@"feed_label03.png"];
        }
        cell.positioNameLabel.text = manifesto.politician.positionName;
        if ([manifesto.politician haveImg]) {
            [cell.candidateImgView setImageWithURL:[NSURL URLWithString:[manifesto.politician img]] placeholderImage:nil options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){
                
            }];
        }
        if ([manifesto.politician haveBgImg]) {
            [cell.bgImgView setImageWithURL:[NSURL URLWithString:[manifesto.politician bgImg]] placeholderImage:nil options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){
                
            }];
        }
        return cell;
        
    }else{
        LogoutCell *cell = (LogoutCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"LogoutCell" owner:nil options:nil];
            cell = [topLevelObjects objectAtIndex:0];
        }
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"authToken"]) {
            cell.txtLabel.text = @"로그아웃";
        }else{
            cell.txtLabel.text = @"로그인";
        }
        UIImage* backImage = [UIImage imageNamed:@"search_bg02.png"];
        cell.backImgView.image = [backImage stretchableImageWithLeftCapWidth:3 topCapHeight:3];
        return cell;
    }
    return NULL;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //PledgeViewController* pledgeViewCont = [PledgeViewController new];
    if (indexPath.section == 0) {
        Manifesto* manifesto = [_mainManifestoArr objectAtIndex:indexPath.row];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        PledgeViewController* pledgeViewCont = [storyboard instantiateViewControllerWithIdentifier:@"pledgeViewController"];
        pledgeViewCont.manifestoId = manifesto.ID.integerValue;
        [((UIViewController *)self.parentViewCont).navigationController pushViewController:pledgeViewCont animated:TRUE];
    }else{
        if ([((UIViewController *)self.parentViewCont).parentViewController isKindOfClass:[LoginViewController class]]) {
            [(UIViewController *)self.parentViewCont dismissViewControllerAnimated:TRUE completion:nil];
        }else{
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"authToken"]) {
                
                // 로그아웃
                MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
                hud.dimBackground = TRUE;
                NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"authToken"] forKey:@"auth_token"];
                [[AFAppDotNetAPIClient sharedClient] postPath:@"users/sign_out.json" parameters:params success:^(AFHTTPRequestOperation *response, id responseObject) {
#ifdef _SERVER_LOG_
                    NSLog(@"users/sign_out.json : %@",(NSDictionary *)responseObject);
#endif
                    NSString* code = [responseObject objectForKey:@"code"];
                    if (![code isEqualToString:@"0000"]) {
                        FSBlockButton *cancelButton = [FSBlockButton blockButtonWithTitle:@"확인" block:^ {
                        }];
                        FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"에러" message:[responseObject objectForKey:@"message"] cancelButton:cancelButton otherButtons: nil];
                        [alert show];
                    }else{
                        [[NSUserDefaults standardUserDefaults] setObject:NULL forKey:@"authToken"];
                        [[NSUserDefaults standardUserDefaults] setObject:NULL forKey:@"email"];
                        
                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        
                        LoginViewController* loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
                        loginViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                        [((UIViewController *)self.parentViewCont) presentViewController:loginViewController animated:TRUE completion:nil];
                    }
                    [MBProgressHUD hideHUDForView:self animated:YES];
                } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
                    NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
                    FSBlockButton *cancelButton = [FSBlockButton blockButtonWithTitle:@"확인" block:^ {
                    }];
                    FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"서버공사" message:@"서버 공사중입니다. 잠시만 기다려 주세요." cancelButton:cancelButton otherButtons: nil];
                    [alert show];
                    [MBProgressHUD hideHUDForView:self animated:YES];
                }];
            }else{
                // 로그인
                [MBProgressHUD showHUDAddedTo:self animated:YES];
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                
                LoginViewController* loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
                loginViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                [((UIViewController *)self.parentViewCont) presentViewController:loginViewController animated:TRUE completion:^(void){
                    [MBProgressHUD hideHUDForView:self animated:YES];
                }];
            }
            
            
        }
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
