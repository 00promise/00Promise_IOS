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
#import "UIColor+CreateMethods.h"
#import <FSExtendedAlertKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
@interface CandidateListViewController () <UISearchBarDelegate>

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
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"leads_calls_to_detail"])
    {
    }
    NSLog(@"%@",[segue identifier]);
}
- (void)initVariable{
    page = 1;
    _candidateArr = [NSMutableArray new];
}
- (void)initView{
    [[NSBundle mainBundle] loadNibNamed:@"PledgeFooterActivityIndicator" owner:self options:nil];//this gets a new instance from the xib
    self.activityIndicator=self.activityIndicator;
    [[self tableView] setTableFooterView:[self activityIndicatorView]];
    [[self activityIndicatorView] setHidden:TRUE];
    
    [_tableView setContentInset:UIEdgeInsetsMake(10.0f, 0.0, 10.0, 0.0)];
    
    [_candidateArr removeAllObjects];
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    /*
    NSString *url;
    if (_electionId != 0) {
        url = [NSString stringWithFormat:@"elections/%ld/politicians.json",_electionId];
    }else{
        url = [NSString stringWithFormat:@"parties/%ld/politicians.json",_candidateId];
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
        NSLog(@"parties/@id/politicians.json [HTTPClient Error]: %@", error.localizedDescription);
    
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
     */
}
- (void)backItemClick{
    [self.navigationController popViewControllerAnimated:TRUE];
}
- (void)loadMore{
    page++;
    NSString *url;
    if (_electionId != 0) {
        url = [NSString stringWithFormat:@"elections/%ld/politicians.json",_electionId];
    }else{
        url = [NSString stringWithFormat:@"parties/%ld/politicians.json",_candidateId];
    }
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    [[AFAppDotNetAPIClient sharedClient] getPath:url parameters:params success:^(AFHTTPRequestOperation *response, id responseObject) {
#ifdef _SERVER_LOG_
        NSLog(@"parties/@id/politicians.json : %@",(NSDictionary *)responseObject);
#endif
        NSString* code = [responseObject objectForKey:@"code"];
        NSUInteger tmpIdx;
        if (![code isEqualToString:@"0000"]) {
            FSBlockButton *cancelButton = [FSBlockButton blockButtonWithTitle:@"확인" block:^ {
                [[UIApplication sharedApplication] finalize];
            }];
            FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"에러" message:[responseObject objectForKey:@"message"] cancelButton:cancelButton otherButtons: nil];
            [alert show];
        }else{
            tmpIdx = [_candidateArr count];
            NSMutableArray* manifestoArr = [responseObject objectForKey:@"data"];
            for (NSDictionary* dic in manifestoArr) {
                NSDictionary* politicianDic = [NSDictionary dictionaryWithObject:dic forKey:@"politician"];
                Politician* politician = [Politician new];
                [politician setPropertiesUsingRemoteDictionary:politicianDic];
                [_candidateArr addObject:politician];
            }
            [_tableView reloadData];
        }
        if (_tableView.contentOffset.y > _tableView.contentSize.height - _tableView.frame.size.height-_activityIndicatorView.frame.size.height) {
            [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:tmpIdx-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:TRUE];
        }
        [[self activityIndicatorView] setHidden:TRUE];
        [[self activityIndicator] stopAnimating];
    } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
        NSLog(@"parties/@id/politicians.json [HTTPClient Error]: %@", error.localizedDescription);
        page--;
    }];
}

#pragma mark UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar; {
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{

    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
   
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
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
        [cell.profileImgView setImageWithURL:[NSURL URLWithString:[politician img]] placeholderImage:[UIImage imageNamed:@"default_image.png"] options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){
            
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
#pragma mark UIScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([_candidateArr count] < 10) {
        return ;
    }
	if (([scrollView contentOffset].y + scrollView.frame.size.height) > [scrollView contentSize].height) {
        if (![[self activityIndicator] isAnimating]) {
            [self loadMore];
        }
        [[self activityIndicator] startAnimating];
        [[self activityIndicatorView] setHidden:FALSE];
	}
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
