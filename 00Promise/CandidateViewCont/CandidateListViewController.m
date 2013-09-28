//
//  CandidateListViewController.m
//  00Promise
//
//  Created by Rangken on 13. 9. 27..
//  Copyright (c) 2013년 SocialInovation. All rights reserved.
//

#import "CandidateListViewController.h"
#import "CandidateCell.h"
#import "JYGraphic.h"
#import "CandidateViewController.h"
#import <FSExtendedAlertKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
@interface CandidateListViewController ()

@end

@implementation CandidateListViewController

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
	// Do any additional setup after loading the view.
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"leads_calls_to_detail"])
    {
    }
    NSLog(@"%@",[segue identifier]);
}
- (void)initVariable{
    _candidateArr = [NSMutableArray new];
}
- (void)initView{
    [_tableView setContentInset:UIEdgeInsetsMake(10.0f, 0.0, 10.0, 0.0)];
    
    [_candidateArr removeAllObjects];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *url;
    if (_electionId != 0) {
        url = [NSString stringWithFormat:@"elections/%i/politicians.json",_electionId];
    }else{
        url = [NSString stringWithFormat:@"parties/%i/politicians.json",_candidateId];
    }
    [[AFAppDotNetAPIClient sharedClient] getPath:url parameters:nil success:^(AFHTTPRequestOperation *response, id responseObject) {
#ifdef _SERVER_LOG_
        NSLog(@"parties/@id/politicians.json : %@",(NSDictionary *)responseObject);
#endif
        NSString* code = [responseObject objectForKey:@"code"];
        if (![code isEqualToString:@"0000"]) {
            FSBlockButton *cancelButton = [FSBlockButton blockButtonWithTitle:@"확인" block:^ {
                [[UIApplication sharedApplication] finalize];
            }];
            FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"에러" message:[responseObject objectForKey:@"message"] cancelButton:cancelButton otherButtons: nil];
            [alert show];
        }else{
            NSMutableArray* manifestoArr = [responseObject objectForKey:@"data"];
            for (NSDictionary* dic in manifestoArr) {
                NSDictionary* politicianDic = [NSDictionary dictionaryWithObject:dic forKey:@"politician"];
                Politician* politician = [Politician new];
                [politician setPropertiesUsingRemoteDictionary:politicianDic];
                [_candidateArr addObject:politician];
            }
            [_tableView reloadData];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
        NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
        FSBlockButton *cancelButton = [FSBlockButton blockButtonWithTitle:@"예" block:^ {
            [self initView];
        }];
        FSBlockButton *okButton = [FSBlockButton blockButtonWithTitle:@"아니요" block:^ {
        }];
        FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"에러" message:@"다시 시도하시겠습니까?." cancelButton:cancelButton otherButtons:okButton, nil];
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
        return 20;
    }
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
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
    return 90;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_candidateArr count];;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    CandidateCell *cell = (CandidateCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CandidateCell" owner:nil options:nil];
        cell = [topLevelObjects objectAtIndex:0];
        
    }
    Politician* politician = [_candidateArr objectAtIndex:indexPath.row];
    UIImage *backImage = [UIImage imageNamed:@"search_bg02.png"];
    cell.backImgView.image = [backImage stretchableImageWithLeftCapWidth:3 topCapHeight:3];
    
    cell.nameLabel.text = politician.name;
    cell.contentLabel.text = politician.memo;
    cell.positionLabel.text = politician.positionName;
    if ([politician haveImg]) {
        [cell.profileImgView setImageWithURL:[NSURL URLWithString:[politician img]] placeholderImage:nil options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){
            
        }];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //PledgeViewController* pledgeViewCont = [PledgeViewController new];
    //[(UIViewController *)self.parentViewCont performSegueWithIdentifier:@"GoPledgePush" sender:nil];
    Politician* politician = [_candidateArr objectAtIndex:indexPath.row];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    CandidateViewController* candidateViewCont = [storyboard instantiateViewControllerWithIdentifier:@"candidateViewController"];
    candidateViewCont.politicianId = politician.ID.integerValue;
    [self.navigationController pushViewController:candidateViewCont animated:TRUE];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
