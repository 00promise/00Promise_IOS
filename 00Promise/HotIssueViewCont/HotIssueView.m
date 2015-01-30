//
//  HotIssueView.m
//  00Promise
//
//  Created by Rangken on 2015. 1. 28..
//  Copyright (c) 2015년 SocialInovation. All rights reserved.
//

#import "HotIssueView.h"
#import "AppDelegate.h"
#import "UIColor+CreateMethods.h"
#import "BaseViewController.h"
#import "IssueBigTableViewCell.h"
#import "IssueSmallTableViewCell.h"
#import "Models.h"
#import "JYGraphic.h"
#import "BaseViewController.h"
#import "CandidateViewController.h"
#import <FSExtendedAlertKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
@implementation HotIssueView

- (id) initWithCoder:(NSCoder *)aCoder{
    if(self = [super initWithCoder:aCoder]){
        [self initVariable];
        //[self initView];
    }
    return self;
}
- (void)initVariable{
    _issueArr = [NSMutableArray new];
}

- (void)initView{    [MBProgressHUD showHUDAddedTo:self.parentViewCont.view animated:YES];
    [[AFAppDotNetAPIClient sharedClient] getPath:@"issues.json" parameters:nil success:^(AFHTTPRequestOperation *response, id responseObject) {
#ifdef _SERVER_LOG_
        NSLog(@"issues.json : %@",(NSDictionary *)responseObject);
#endif
        NSString* code = [responseObject objectForKey:@"code"];
        if (![code isEqualToString:@"0000"]) {
            FSBlockButton *cancelButton = [FSBlockButton blockButtonWithTitle:@"확인" block:^ {
            }];
            FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"에러" message:[responseObject objectForKey:@"message"] cancelButton:cancelButton otherButtons: nil];
            [alert show];
        }else{
            NSMutableArray* sidoArr = [responseObject objectForKey:@"data"];
            for (NSDictionary* dic in sidoArr) {
                NSDictionary* issueDic = [NSDictionary dictionaryWithObject:dic forKey:@"issue"];
                Issue* issue = [Issue new];
                [issue setPropertiesUsingRemoteDictionary:issueDic];
                [_issueArr addObject:issue];
            }
            [_tableView reloadData];
        }
        [MBProgressHUD hideHUDForView:self.parentViewCont.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
        NSLog(@"issues.json [HTTPClient Error]: %@", error.localizedDescription);
        FSBlockButton *cancelButton = [FSBlockButton blockButtonWithTitle:@"확인" block:^ {
            //[self.navigationController popViewControllerAnimated:TRUE];
        }];
        FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"에러" message:@"정보를 가져올수 없습니다." cancelButton:cancelButton otherButtons: nil];
        [alert show];
        [MBProgressHUD hideHUDForView:self.parentViewCont.view animated:YES];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Issue* issue= [_issueArr objectAtIndex:indexPath.row];
    CGSize expectedLabelSize = [issue.title sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(223, 200)];
    if (expectedLabelSize.height > 20) {
        return 86;
    }else{
        return 72;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_issueArr count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    Issue* issue = [_issueArr objectAtIndex:indexPath.row];
    CGSize expectedLabelSize = [issue.title sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(223, 200)];
    
    if (expectedLabelSize.height > 20) {
        IssueBigTableViewCell *cell = (IssueBigTableViewCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil){
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"IssueBigTableViewCell" owner:nil options:nil];
            cell = [topLevelObjects objectAtIndex:0];
        }
        
        [cell.imgView setImageWithURL:[NSURL URLWithString:[issue.link.politician img]] placeholderImage:[UIImage imageNamed:@"default_image.png"] options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){
            [JYGraphic setRoundedView:cell.imgView toDiameter:52.0f];
        }];
        
        cell.issueLabel.text = issue.title;
        cell.nameLabel.text = issue.link.politician.name;
        cell.positionLabel.text = issue.link.politician.positionName;
        
        return cell;
    }else{
        IssueSmallTableViewCell *cell = (IssueSmallTableViewCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil){
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"IssueSmallTableViewCell" owner:nil options:nil];
            cell = [topLevelObjects objectAtIndex:0];
        }
        
        [cell.imgView setImageWithURL:[NSURL URLWithString:[issue.link.politician img]] placeholderImage:[UIImage imageNamed:@"default_image.png"] options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){
            [JYGraphic setRoundedView:cell.imgView toDiameter:52.0f];
        }];
        
        cell.issueLabel.text = issue.title;
        cell.nameLabel.text = issue.link.politician.name;
        cell.positionLabel.text = issue.link.politician.positionName;
        
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Issue* issue= [_issueArr objectAtIndex:indexPath.row];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    CandidateViewController* candidateViewCont = [storyboard instantiateViewControllerWithIdentifier:@"candidateViewController"];
    candidateViewCont.politician = issue.link.politician;
    candidateViewCont.politicianId = issue.link.politician.ID.integerValue;
    [((UIViewController*)self.parentViewCont) presentViewController:candidateViewCont animated:TRUE completion:nil];
    
    //[((UIViewController*)self.parentViewCont).navigationController pushViewController:candidateViewCont animated:TRUE];
}
@end
