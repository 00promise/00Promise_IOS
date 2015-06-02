//
//  PledgeViewController.m
//  00Promise
//
//  Created by Digitalfrog on 13. 9. 25..
//  Copyright (c) 2013년 SocialInovation. All rights reserved.
//

#import "PledgeViewController.h"
#import "ReplyCell.h"
#import "PledgeCell.h"
#import "ODRefreshControl.h"
#import "JYGraphic.h"
#import "DAKeyboardControl.h"
#import "DateUtil.h"
#import "LoginViewController.h"
#import <FSExtendedAlertKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
@interface PledgeViewController ()

@end

@implementation PledgeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated{
    
}

- (void)initVariable{
    theMoreHeight = 0;
    _replyArr = [NSMutableArray new];
}
- (void)initView{
    ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:_tableView];
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    
    [[NSBundle mainBundle] loadNibNamed:@"PledgeFooterActivityIndicator" owner:self options:nil];//this gets a new instance from the xib
    self.activityIndicator=self.activityIndicator;
    [[self tableView] setTableFooterView:[self activityIndicatorView]];
    [[self activityIndicatorView] setHidden:TRUE];
    
    [self addChatKeyborad];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[AFAppDotNetAPIClient sharedClient] getPath:[NSString stringWithFormat:@"manifestos/%d.json",_manifestoId] parameters:nil success:^(AFHTTPRequestOperation *response, id responseObject) {
#ifdef _SERVER_LOG_
        NSLog(@"manifestos/@id.json : %@",(NSDictionary *)responseObject);
#endif
        NSString* code = [responseObject objectForKey:@"code"];
        if (![code isEqualToString:@"0000"]) {
            FSBlockButton *cancelButton = [FSBlockButton blockButtonWithTitle:@"확인" block:^ {
            }];
            FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"에러" message:[responseObject objectForKey:@"message"] cancelButton:cancelButton otherButtons: nil];
            [alert show];
        }else{
            NSDictionary* manifestoDic = [NSDictionary dictionaryWithObject:[responseObject objectForKey:@"data"] forKey:@"manifesto"];
            _manifesto = [Manifesto new];
            [_manifesto setPropertiesUsingRemoteDictionary:manifestoDic];
            NSIndexSet* indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,1)];
            [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
        NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
        FSBlockButton *cancelButton = [FSBlockButton blockButtonWithTitle:@"확인" block:^ {
            [self.navigationController popViewControllerAnimated:TRUE];
        }];
        FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"에러" message:@"정보를 가져올수 없습니다." cancelButton:cancelButton otherButtons: nil];
        [alert show];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    NSMutableDictionary* params = [NSMutableDictionary new];
    [params setObject:[NSString stringWithFormat:@"%d",_manifestoId] forKey:@"manifesto_id"];
    //[params setObject:[NSString stringWithFormat:@"%d",10] forKey:@"count"];
    //[params setObject:[NSString stringWithFormat:@"%d",10] forKey:@"max_id"];
    [[AFAppDotNetAPIClient sharedClient] getPath:[NSString stringWithFormat:@"replies/manifesto/%d.json",_manifestoId] parameters:params success:^(AFHTTPRequestOperation *response, id responseObject) {
#ifdef _SERVER_LOG_
        NSLog(@"replies/manifesto/@id.json : %@",(NSDictionary *)responseObject);
#endif
        NSString* code = [responseObject objectForKey:@"code"];
        if (![code isEqualToString:@"0000"]) {
            FSBlockButton *cancelButton = [FSBlockButton blockButtonWithTitle:@"확인" block:^ {
            }];
            FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"에러" message:[responseObject objectForKey:@"message"] cancelButton:cancelButton otherButtons: nil];
            [alert show];
        }else{
            NSMutableArray* replyArr = [responseObject objectForKey:@"data"];
            for (NSDictionary* dic in replyArr) {
                NSDictionary* replyDic = [NSDictionary dictionaryWithObject:dic forKey:@"reply"];
                Reply* reply = [Reply new];
                [reply setPropertiesUsingRemoteDictionary:replyDic];
                [_replyArr addObject:reply];
            }
            NSIndexSet* indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1,1)];
            [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        }
    } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
        NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
        FSBlockButton *cancelButton = [FSBlockButton blockButtonWithTitle:@"확인" block:^ {
            [self.navigationController popViewControllerAnimated:TRUE];
        }];
        FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"에러" message:@"정보를 가져올수 없습니다." cancelButton:cancelButton otherButtons: nil];
        [alert show];
    }];
}

- (void)addChatKeyborad{
    _keyboardView = [[UIView alloc] initWithFrame:CGRectMake(0.0f,
                                                            self.view.bounds.size.height - 40.0f,
                                                            self.view.bounds.size.width,
                                                            45.0f)];
    [_keyboardView setBackgroundColor:[UIColor whiteColor]];
    _keyboardView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:_keyboardView];
    
    UIImageView* lineImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_line01.png"]];
    lineImgView.frame = CGRectMake(0, 0, 320, 1);
    lineImgView.backgroundColor = [UIColor colorWith8BitRed:214 green:214 blue:214 alpha:1.0f];
    [_keyboardView addSubview:lineImgView];
    
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10.0f,
                                                                           6.0f,
                                                                           222.0f,
                                                                           35.0f)];
    //textField.borderStyle = UITextBorderStyleRoundedRect;
    //textView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [textView setFont:[UIFont systemFontOfSize:15]];
    _textView = textView;
    _textView.delegate = self;
    [_keyboardView addSubview:textView];
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
    [sendButton setImage:[UIImage imageNamed:@"reply_btn01.png"] forState:UIControlStateNormal];
    sendButton.frame = CGRectMake(_keyboardView.bounds.size.width - 65.0f,
                                  6.0f,
                                  62.0f,
                                  32.0f);
    [_keyboardView addSubview:sendButton];
    
    UIView *keyboardCover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    keyboardCover.backgroundColor = [UIColor redColor];
    
    self.view.keyboardCoverView = keyboardCover;
    self.view.keyboardTriggerOffset = _keyboardView.bounds.size.height;
    UITableView* tableView = _tableView;
    UIView* keyboardView = _keyboardView;
    [self.view addKeyboardPanningWithActionHandler:^(CGRect keyboardFrameInView) {
        /*
         Try not to call "sßelf" inside this block (retain cycle).
         But if you do, make sure to remove DAKeyboardControl
         when you are done with the view controller by calling:
         [self.view removeKeyboardControl];
         */
        
        CGRect keyboardViewFrame = keyboardView.frame;
        keyboardViewFrame.origin.y = keyboardFrameInView.origin.y - keyboardViewFrame.size.height;
        NSLog(@"%f",keyboardViewFrame.origin.y);
        keyboardView.frame = keyboardViewFrame;
        
        CGRect tableViewFrame = tableView.frame;
        tableViewFrame.size.height = keyboardViewFrame.origin.y;
        tableView.frame = tableViewFrame;
    }];
}

- (void) sendClick{
    if ([_textView isFirstResponder]) {
        [_textView resignFirstResponder];
        /*
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSMutableDictionary* params = [NSMutableDictionary new];
        NSLog(@"TOKEN : %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"authToken"]);
        [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"authToken"] forKey:@"auth_token"];
        [params setObject:[NSString stringWithFormat:@"%d",_manifesto.ID.integerValue] forKey:@"manifesto_id"];
        [params setObject:[NSString stringWithFormat:@"%d",tag+1] forKey:@"grade"];
        
        [[AFAppDotNetAPIClient sharedClient] postPath:@"ratings/update.json" parameters:params success:^(AFHTTPRequestOperation *response, id responseObject) {
#ifdef _SERVER_LOG_
            NSLog(@"ratings/update.json : %@",(NSDictionary *)responseObject);
#endif
            NSString* code = [responseObject objectForKey:@"code"];
            if (![code isEqualToString:@"0000"]) {
                FSBlockButton *cancelButton = [FSBlockButton blockButtonWithTitle:@"확인" block:^ {
                }];
                FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"에러" message:[responseObject objectForKey:@"message"] cancelButton:cancelButton otherButtons: nil];
                [alert show];
            }else{
                NSDictionary* manifestoDic = [NSDictionary dictionaryWithObject:[[responseObject objectForKey:@"data"] objectForKey:@"manifesto"] forKey:@"manifesto"];
                [_manifesto setPropertiesUsingRemoteDictionary:manifestoDic];
                
                [_tableView reloadData];
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
            NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
            FSBlockButton *cancelButton = [FSBlockButton blockButtonWithTitle:@"확인" block:^ {
                
            }];
            FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"에러" message:@"평가에 실패하였습니다." cancelButton:cancelButton otherButtons: nil];
            [alert show];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
         */
    }else{
        [_textView becomeFirstResponder];
        //self.view.isKeyboardCoverViewVisible = !self.view.isKeyboardCoverViewVisible;
    }
}

- (void)backItemClick{
    [self.navigationController popViewControllerAnimated:TRUE];
}
- (IBAction)theMoreClick:(id)sender{
    PledgeCell *cell = (PledgeCell *)[self tableView:_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    CGSize size = [cell.manifestoLabel.text sizeWithFont:[UIFont systemFontOfSize:17]
                                      constrainedToSize:CGSizeMake(246, 1000)
                                          lineBreakMode:NSLineBreakByWordWrapping];
    [cell.manifestoLabel setFrame:CGRectMake(0, 0, size.width, size.height)];
    cell.manifestoLabel.numberOfLines = 0;
    [cell.manifestoLabel setFrame:CGRectMake(cell.manifestoLabel.frame.origin.x, cell.manifestoLabel.frame.origin.y, cell.manifestoLabel.frame.size.height, size.height)];
    theMoreHeight = size.height;
    NSRange range = NSMakeRange(0, 1);
    NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];
    [_tableView reloadSections:section withRowAnimation:UITableViewRowAnimationTop];
    
}
- (IBAction)ratingClick:(id)sender{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"authToken"]) {
        int tag = ((UIButton *)sender).tag;
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSMutableDictionary* params = [NSMutableDictionary new];
        NSLog(@"TOKEN : %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"authToken"]);
        [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"authToken"] forKey:@"auth_token"];
        [params setObject:[NSString stringWithFormat:@"%d",_manifesto.ID.integerValue] forKey:@"manifesto_id"];
        [params setObject:[NSString stringWithFormat:@"%d",tag+1] forKey:@"grade"];
        
        [[AFAppDotNetAPIClient sharedClient] postPath:@"ratings/update.json" parameters:params success:^(AFHTTPRequestOperation *response, id responseObject) {
#ifdef _SERVER_LOG_
            NSLog(@"ratings/update.json : %@",(NSDictionary *)responseObject);
#endif
            NSString* code = [responseObject objectForKey:@"code"];
            if (![code isEqualToString:@"0000"]) {
                FSBlockButton *cancelButton = [FSBlockButton blockButtonWithTitle:@"확인" block:^ {
                }];
                FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"에러" message:[responseObject objectForKey:@"message"] cancelButton:cancelButton otherButtons: nil];
                [alert show];
            }else{
                NSDictionary* manifestoDic = [NSDictionary dictionaryWithObject:[[responseObject objectForKey:@"data"] objectForKey:@"manifesto"] forKey:@"manifesto"];
                [_manifesto setPropertiesUsingRemoteDictionary:manifestoDic];
                
                [_tableView reloadData];
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
            NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
            FSBlockButton *cancelButton = [FSBlockButton blockButtonWithTitle:@"확인" block:^ {
                
            }];
            FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"에러" message:@"평가에 실패하였습니다." cancelButton:cancelButton otherButtons: nil];
            [alert show];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }else{
        FSBlockButton *okButton = [FSBlockButton blockButtonWithTitle:@"확인" block:^ {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            LoginViewController* loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
            loginViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self presentViewController:loginViewController animated:TRUE completion:^(void){
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }];
        }];
        FSBlockButton *cancelButton = [FSBlockButton blockButtonWithTitle:@"취소" block:^ {
            
        }];
        FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"에러" message:@"평가에 실패하였습니다." cancelButton:cancelButton otherButtons: okButton,nil];
        [alert show];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
}
- (IBAction)reportClick:(id)idx{
    FSBlockButton *cancelButton = [FSBlockButton blockButtonWithTitle:@"확인" block:^ {
        
    }];
    FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"신고" message:@"신고를 성공 하였습니다." cancelButton:cancelButton otherButtons: nil];
    [alert show];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
- (IBAction)tapGestureRecognizer:(id)sender{
    [_textView resignFirstResponder];
}
- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl
{
    [[AFAppDotNetAPIClient sharedClient] getPath:[NSString stringWithFormat:@"replies/manifesto/%d.json",_manifestoId] parameters:nil success:^(AFHTTPRequestOperation *response, id responseObject) {
#ifdef _SERVER_LOG_
        NSLog(@"replies/manifesto/@id.json : %@",(NSDictionary *)responseObject);
#endif
        NSString* code = [responseObject objectForKey:@"code"];
        if (![code isEqualToString:@"0000"]) {
            FSBlockButton *cancelButton = [FSBlockButton blockButtonWithTitle:@"확인" block:^ {
            }];
            FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"에러" message:[responseObject objectForKey:@"message"] cancelButton:cancelButton otherButtons: nil];
            [alert show];
        }else{
            
        }
        [refreshControl endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
        NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
        FSBlockButton *cancelButton = [FSBlockButton blockButtonWithTitle:@"확인" block:^ {
            [self.navigationController popViewControllerAnimated:TRUE];
        }];
        FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"에러" message:@"정보를 가져올수 없습니다." cancelButton:cancelButton otherButtons: nil];
        [alert show];
        
        [refreshControl endRefreshing];
    }];
}

- (void)loadMore{
    double delayInSeconds = 3.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if (_tableView.contentOffset.y > _tableView.contentSize.height - _tableView.frame.size.height-_activityIndicatorView.frame.size.height) {
            [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:1] atScrollPosition:UITableViewScrollPositionBottom animated:TRUE];
        }
        [[self activityIndicatorView] setHidden:TRUE];
        [[self activityIndicator] stopAnimating];
    });
}

#pragma mark UITableViewDelegate UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 385+theMoreHeight;
    }else if(indexPath.section == 1){
        return 112;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if(section == 1){
        return [_replyArr count];
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    if (indexPath.section == 0) {
        PledgeCell *cell = (PledgeCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PledgeCell" owner:nil options:nil];
            cell = [topLevelObjects objectAtIndex:0];
        }
        [JYGraphic setRoundedView:cell.candidateImgView toDiameter:92.0f];
        cell.manifestoLabel.text = @"- 대주주의 사익 추구행위, 대기업의\n- 대주주의 사익 추구행위, 대기업의\n- 대주주의 사익 추구행위, 대기업의\n- 대주주의 사익 추구행위, 대기업의";
        cell.parent = self;
        if ([_manifesto.politician haveImg]) {
            [cell.candidateImgView setImageWithURL:[NSURL URLWithString:[_manifesto.politician img]] placeholderImage:nil options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){
                
            }];
        }
        if ([_manifesto.politician haveBgImg]) {
            [cell.bgImgView setImageWithURL:[NSURL URLWithString:[_manifesto.politician bgImg]] placeholderImage:nil options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){
                
            }];
        }
        cell.nameLabel.text = _manifesto.politician.name;
        cell.positionLabel.text = _manifesto.politician.positionName;
        cell.titleLabel.text = _manifesto.title;
        cell.manifestoLabel.text = _manifesto.description;
        cell.goodCntLabel.text = [NSString stringWithFormat:@"%i",_manifesto.goodCnt.integerValue ];
        cell.fairCntLabel.text = [NSString stringWithFormat:@"%i",_manifesto.fairCnt.integerValue ];
        cell.poorCntLabel.text = [NSString stringWithFormat:@"%i",_manifesto.poorCnt.integerValue ];
        cell.replyCntLabel.text = [NSString stringWithFormat:@"%i",_manifesto.replyCnt.integerValue ];

        return cell;
    }else{
        ReplyCell *cell = (ReplyCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ReplyCell" owner:nil options:nil];
            cell = [topLevelObjects objectAtIndex:0];
            
        }
        cell.parent = self;
        Reply* reply = [_replyArr objectAtIndex:indexPath.row];
        cell.nameLabel.text = reply.username;
        cell.createdAtLabel.text = [DateUtil timeDateStringByTimestamp:reply.createdAt.longLongValue];
        cell.contentLabel.text = reply.content;
        cell.ratingAgreeLabel.text = [NSString stringWithFormat:@"공감 %d",reply.agreeCnt.integerValue];
        cell.ratingAgreeLabel.text = [NSString stringWithFormat:@"비공감 %d",reply.disagreeCnt.integerValue];
        
        return cell;
    }
    
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //PledgeViewController* pledgeViewCont = [PledgeViewController new];
}

#pragma mark UIScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([_replyArr count] < 10) {
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
#pragma mark UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return TRUE;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    return TRUE;
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    _textView.text = @"";
    int bottomKeyboardY = 0;
    if (IS_IPHONE_5 && IS_IOS7) {
        bottomKeyboardY = 459;
    }else{
        bottomKeyboardY = 371;
    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelegate:self];
    //[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:_keyboardView cache:YES];
    [_keyboardView setFrame:CGRectMake(0.0f,
                                       bottomKeyboardY,
                                       self.view.bounds.size.width,
                                       45)];
    [_textView setFrame:CGRectMake(_textView.frame.origin.x, _textView.frame.origin.y, _textView.frame.size.width, 35)];
    [UIView commitAnimations];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    return TRUE;
}
- (void)textViewDidChange:(UITextView *)textView{
    int numLines = _textView.contentSize.height / _textView.font.lineHeight;
    if (numLines != 0) {
        numLines-=1;
    }
    if (numLines >= 1) {
        numLines = 1;
    }
    int topKeyboardY = 0;
    if (IS_IPHONE_5 && IS_IOS7) {
        topKeyboardY = 243;
    }else{
        topKeyboardY = 155;
    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelegate:self];
    //[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:_keyboardView cache:YES];
    [_keyboardView setFrame:CGRectMake(0.0f,
                                       topKeyboardY - 18*numLines,
                                       self.view.bounds.size.width,
                                       45+18*numLines)];
    [_textView setFrame:CGRectMake(_textView.frame.origin.x, _textView.frame.origin.y, _textView.frame.size.width, 35 + 18*numLines)];
    [UIView commitAnimations];
}

- (void)textViewDidChangeSelection:(UITextView *)textView{
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
