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
#import "CandidateViewController.h"
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
    if (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height != 568.0f) {
        // 아이폰4
        //[_tableView setFrame:CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y, _tableView.frame.size.width, _tableView.frame.size.height-48)];
        
    }
}

- (void)initVariable{
    theMoreHeight = 0;
    ratingIdx = 0;
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
    NSMutableDictionary* params2 = [NSMutableDictionary new];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"authToken"]) {
        //[params2 setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"authToken"] forKey:@"auth_token"];
    }
    
    
    [[AFAppDotNetAPIClient sharedClient] getPath:[NSString stringWithFormat:@"manifestos/%d.json",_manifestoId] parameters:params2 success:^(AFHTTPRequestOperation *response, id responseObject) {
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
            ratingIdx = _manifesto.ratingStatus.integerValue;
            NSIndexSet* indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,1)];
            [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
        NSLog(@"manifestos/@id.json [HTTPClient Error]: %@", error.localizedDescription);
        FSBlockButton *cancelButton = [FSBlockButton blockButtonWithTitle:@"확인" block:^ {
            [self.navigationController popViewControllerAnimated:TRUE];
        }];
        FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"에러" message:@"정보를 가져올수 없습니다." cancelButton:cancelButton otherButtons: nil];
        [alert show];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    NSMutableDictionary* params = [NSMutableDictionary new];
    [params setObject:[NSString stringWithFormat:@"%d",_manifestoId] forKey:@"manifesto_id"];
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
        NSLog(@"replies/manifesto/@id.json [HTTPClient Error]: %@", error.localizedDescription);
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
    
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(10.0f,
                                                                           6.0f,
                                                                           222.0f,
                                                                           35.0f)];
    //textField.borderStyle = UITextBorderStyleRoundedRect;
    //textView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [_textView setFont:[UIFont systemFontOfSize:15]];
    //self.textView = textView;
    _textView.delegate = self;
    [_keyboardView addSubview:_textView];
    
    _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sendBtn addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
    [_sendBtn setImage:[UIImage imageNamed:@"reply_btn01.png"] forState:UIControlStateNormal];
    _sendBtn.frame = CGRectMake(_keyboardView.bounds.size.width - 65.0f,
                                  6.0f,
                                  62.0f,
                                  32.0f);
    [_keyboardView addSubview:_sendBtn];
    
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
        if ([_textView.text isEqualToString:@""]) {
            
            return ;
        }
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"authToken"] == NULL) {
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
            FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"로그인" message:@"로그인을 하시겠습니까?" cancelButton:cancelButton otherButtons: okButton,nil];
            [alert show];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            return ;
        }
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSMutableDictionary* params = [NSMutableDictionary new];
        [params setObject:[NSString stringWithFormat:@"%d",_manifesto.ID.integerValue] forKey:@"manifesto_id"];
        [params setObject:_textView.text forKey:@"content"];
        //[params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"authToken"] forKey:@"auth_token"];
        _textView.text = @"";
        [[AFAppDotNetAPIClient sharedClient] postPath:@"replies/create.json" parameters:params success:^(AFHTTPRequestOperation *response, id responseObject) {
#ifdef _SERVER_LOG_
            NSLog(@"replies/create.json : %@",(NSDictionary *)responseObject);
#endif
            NSString* code = [responseObject objectForKey:@"code"];
            if (![code isEqualToString:@"0000"]) {
                FSBlockButton *cancelButton = [FSBlockButton blockButtonWithTitle:@"확인" block:^ {
                }];
                FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"에러" message:[responseObject objectForKey:@"message"] cancelButton:cancelButton otherButtons: nil];
                [alert show];
            }else{
                NSDictionary* replyDic = [responseObject objectForKey:@"data"];
                Reply* reply = [Reply new];
                [reply setPropertiesUsingRemoteDictionary:replyDic];
                [_replyArr insertObject:reply atIndex:0];
                _manifesto.replyCnt = [[NSNumber alloc] initWithInt:_manifesto.replyCnt.integerValue+1];

                [_tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationTop];
                [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
                [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:TRUE];
                //NSIndexSet* indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1,1)];
                //[_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
            NSLog(@"replies/create.json [HTTPClient Error]: %@", error.localizedDescription);
            FSBlockButton *cancelButton = [FSBlockButton blockButtonWithTitle:@"확인" block:^ {
                
            }];
            FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"에러" message:@"댓글쓰기 실패하였습니다." cancelButton:cancelButton otherButtons: nil];
            [alert show];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
        
    }else{
        [_textView becomeFirstResponder];
        //self.view.isKeyboardCoverViewVisible = !self.view.isKeyboardCoverViewVisible;
    }
}

- (void)backItemClick{
    [self.navigationController popViewControllerAnimated:TRUE];
}
- (IBAction)theMoreClick:(id)sender{
    if (theMoreHeight < 60) {
        PledgeCell *cell = (PledgeCell *)[self tableView:_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
        CGSize size = [cell.manifestoLabel.text sizeWithFont:[UIFont systemFontOfSize:14]
                                           constrainedToSize:CGSizeMake(246, 1000)
                                               lineBreakMode:NSLineBreakByWordWrapping];
        theMoreHeight = size.height;
        
        NSRange range = NSMakeRange(0, 1);
        NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];
        [_tableView reloadSections:section withRowAnimation:UITableViewRowAnimationFade];
    }else{
        theMoreHeight = 0;
        NSRange range = NSMakeRange(0, 1);
        NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];
        [_tableView reloadSections:section withRowAnimation:UITableViewRowAnimationFade];
    }
}
- (IBAction)ratingClick:(id)sender{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"authToken"]) {
        int tag = ((UIButton *)sender).tag;
        ratingIdx = tag+1;
        UIButton* btn = sender;
        NSString* urlStr = @"";
        if ([btn isSelected]) {
            urlStr = @"ratings/destroy.json";
            ratingIdx = 0;
        }else{
            urlStr = @"ratings/update.json";
        }
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSMutableDictionary* params = [NSMutableDictionary new];
        //[params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"authToken"] forKey:@"auth_token"];
        [params setObject:[NSString stringWithFormat:@"%d",_manifesto.ID.integerValue] forKey:@"manifesto_id"];
        [params setObject:[NSString stringWithFormat:@"%d",tag+1] forKey:@"grade"];
        
        [[AFAppDotNetAPIClient sharedClient] postPath:urlStr parameters:params success:^(AFHTTPRequestOperation *response, id responseObject) {
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
            NSLog(@"ratings/update.json [HTTPClient Error]: %@", error.localizedDescription);
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
        FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"로그인" message:@"로그인을 하시겠습니까?" cancelButton:cancelButton otherButtons: okButton,nil];
        [alert show];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
}
- (IBAction)reportClick:(id)sender{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"authToken"] == NULL) {
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
        FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"로그인" message:@"로그인을 하시겠습니까?" cancelButton:cancelButton otherButtons: okButton,nil];
        [alert show];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        return ;
    }
    int tag = ((UIButton*)sender).tag;
    Reply* reply = [_replyArr objectAtIndex:tag];
    NSMutableDictionary* params = [NSMutableDictionary new];
    [params setObject:[NSString stringWithFormat:@"%d",reply.ID.integerValue] forKey:@"reply_id"];
    [[AFAppDotNetAPIClient sharedClient] postPath:@"reply_reports/create.json" parameters:params success:^(AFHTTPRequestOperation *response, id responseObject) {
#ifdef _SERVER_LOG_
        NSLog(@"reply_reports/create.json : %@",(NSDictionary *)responseObject);
#endif
        NSString* code = [responseObject objectForKey:@"code"];
        if (![code isEqualToString:@"0000"]) {
            FSBlockButton *cancelButton = [FSBlockButton blockButtonWithTitle:@"확인" block:^ {
            }];
            FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"에러" message:[responseObject objectForKey:@"message"] cancelButton:cancelButton otherButtons: nil];
            [alert show];
        }else{
            FSBlockButton *cancelButton = [FSBlockButton blockButtonWithTitle:@"취소" block:^ {
                
            }];
            FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"신고" message:@"신고처리 되었습니다." cancelButton:cancelButton otherButtons:nil];
            [alert show];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
        NSLog(@"reply_reports/create.json [HTTPClient Error]: %@", error.localizedDescription);
        FSBlockButton *cancelButton = [FSBlockButton blockButtonWithTitle:@"확인" block:^ {
            //[self.navigationController popViewControllerAnimated:TRUE];
        }];
        FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"에러" message:@"신고에 실패하였습니다." cancelButton:cancelButton otherButtons: nil];
        [alert show];
    }];
}

- (IBAction)agreeClick:(id)sender{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"authToken"] == NULL) {
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
        FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"로그인" message:@"로그인을 하시겠습니까?" cancelButton:cancelButton otherButtons: okButton,nil];
        [alert show];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        return ;
    }
    int tag = ((UIButton*)sender).tag;
    Reply* reply = [_replyArr objectAtIndex:tag];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary* params = [NSMutableDictionary new];
    //[params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"authToken"] forKey:@"auth_token"];
    [params setObject:[NSString stringWithFormat:@"%d",reply.ID.integerValue] forKey:@"reply_id"];
    [params setObject:@"A" forKey:@"eval_type"];
    
    [[AFAppDotNetAPIClient sharedClient] postPath:@"reply_evaluations/create.json" parameters:params success:^(AFHTTPRequestOperation *response, id responseObject) {
#ifdef _SERVER_LOG_
        NSLog(@"reply_evaluations/create.json : %@",(NSDictionary *)responseObject);
#endif
        NSString* code = [responseObject objectForKey:@"code"];
        if (![code isEqualToString:@"0000"]) {
            FSBlockButton *cancelButton = [FSBlockButton blockButtonWithTitle:@"확인" block:^ {
            }];
            FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"에러" message:[responseObject objectForKey:@"message"] cancelButton:cancelButton otherButtons: nil];
            [alert show];
        }else{
            //Reply* reply = [_replyArr objectAtIndex:tag];
            [reply setPropertiesUsingRemoteDictionary:[[responseObject objectForKey:@"data"] objectForKey:@"reply"]];
            [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:tag inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
        NSLog(@"reply_evaluations/create.json [HTTPClient Error]: %@", error.localizedDescription);
        FSBlockButton *cancelButton = [FSBlockButton blockButtonWithTitle:@"확인" block:^ {
            
        }];
        FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"에러" message:@"평가에 실패하였습니다." cancelButton:cancelButton otherButtons: nil];
        [alert show];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
- (IBAction)disAgreeClick:(id)sender{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"authToken"] == NULL) {
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
        FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"로그인" message:@"로그인을 하시겠습니까?" cancelButton:cancelButton otherButtons: okButton,nil];
        [alert show];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        return ;
    }
    int tag = ((UIButton*)sender).tag;
    Reply* reply = [_replyArr objectAtIndex:tag];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary* params = [NSMutableDictionary new];
    //[params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"authToken"] forKey:@"auth_token"];
    [params setObject:[NSString stringWithFormat:@"%d",reply.ID.integerValue] forKey:@"reply_id"];
    [params setObject:@"D" forKey:@"eval_type"];
    
    [[AFAppDotNetAPIClient sharedClient] postPath:@"reply_evaluations/create.json" parameters:params success:^(AFHTTPRequestOperation *response, id responseObject) {
#ifdef _SERVER_LOG_
        NSLog(@"reply_evaluations/create.json : %@",(NSDictionary *)responseObject);
#endif
        NSString* code = [responseObject objectForKey:@"code"];
        if (![code isEqualToString:@"0000"]) {
            FSBlockButton *cancelButton = [FSBlockButton blockButtonWithTitle:@"확인" block:^ {
            }];
            FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"에러" message:[responseObject objectForKey:@"message"] cancelButton:cancelButton otherButtons: nil];
            [alert show];
        }else{
            [reply setPropertiesUsingRemoteDictionary:[[responseObject objectForKey:@"data"] objectForKey:@"reply"]];
            [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:tag inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
        NSLog(@"reply_evaluations/create.json [HTTPClient Error]: %@", error.localizedDescription);
        FSBlockButton *cancelButton = [FSBlockButton blockButtonWithTitle:@"확인" block:^ {
            
        }];
        FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"에러" message:@"평가에 실패하였습니다." cancelButton:cancelButton otherButtons: nil];
        [alert show];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
- (IBAction)tapGestureRecognizer:(id)sender{
    [_textView resignFirstResponder];
}
- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl
{
    NSMutableDictionary* params = [NSMutableDictionary new];
    [params setObject:[NSString stringWithFormat:@"%d",_manifestoId] forKey:@"manifesto_id"];
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
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [refreshControl endRefreshing];
        });
        
        //[refreshControl endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
        NSLog(@"replies/manifesto/@id.json [HTTPClient Error]: %@", error.localizedDescription);
        FSBlockButton *cancelButton = [FSBlockButton blockButtonWithTitle:@"확인" block:^ {
            [self.navigationController popViewControllerAnimated:TRUE];
        }];
        FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"에러" message:@"정보를 가져올수 없습니다." cancelButton:cancelButton otherButtons: nil];
        [alert show];
        [refreshControl endRefreshing];
    }];
}

- (void)loadMore{
    Reply* reply = [_replyArr lastObject];
    NSMutableDictionary* params = [NSMutableDictionary new];
    [params setObject:[NSString stringWithFormat:@"%d",_manifestoId] forKey:@"manifesto_id"];
    [params setObject:[NSString stringWithFormat:@"%d",reply.ID.integerValue] forKey:@"max_id"];
    [params setObject:@"20" forKey:@"count"];
    [[AFAppDotNetAPIClient sharedClient] getPath:[NSString stringWithFormat:@"replies/manifesto/%d.json",_manifestoId] parameters:params success:^(AFHTTPRequestOperation *response, id responseObject) {
#ifdef _SERVER_LOG_
        NSLog(@"replies/manifesto/@id.json : %@",(NSDictionary *)responseObject);
#endif
        NSString* code = [responseObject objectForKey:@"code"];
        int tmpIdx;
        if (![code isEqualToString:@"0000"]) {
            FSBlockButton *cancelButton = [FSBlockButton blockButtonWithTitle:@"확인" block:^ {
            }];
            FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"에러" message:[responseObject objectForKey:@"message"] cancelButton:cancelButton otherButtons: nil];
            [alert show];
        }else{
            NSMutableArray* replyArr = [responseObject objectForKey:@"data"];
            NSMutableArray* tempReplyArr = [NSMutableArray new];
            tmpIdx = [_replyArr count];
            for (NSDictionary* dic in replyArr) {
                NSDictionary* replyDic = [NSDictionary dictionaryWithObject:dic forKey:@"reply"];
                Reply* reply = [Reply new];
                [reply setPropertiesUsingRemoteDictionary:replyDic];
                [tempReplyArr addObject:reply];
            }
            [_replyArr addObjectsFromArray:tempReplyArr];
            
            //NSIndexSet* indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1,1)];
            //[_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
            [_tableView reloadData];
        }
        if (_tableView.contentOffset.y > _tableView.contentSize.height - _tableView.frame.size.height-_activityIndicatorView.frame.size.height) {
            [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:tmpIdx-1 inSection:1] atScrollPosition:UITableViewScrollPositionBottom animated:TRUE];
        }
        [[self activityIndicatorView] setHidden:TRUE];
        [[self activityIndicator] stopAnimating];
    } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
        NSLog(@"replies/manifesto/@id.json [HTTPClient Error]: %@", error.localizedDescription);
        FSBlockButton *cancelButton = [FSBlockButton blockButtonWithTitle:@"확인" block:^ {
            [self.navigationController popViewControllerAnimated:TRUE];
        }];
        FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"에러" message:@"정보를 가져올수 없습니다." cancelButton:cancelButton otherButtons: nil];
        [alert show];
        if (_tableView.contentOffset.y > _tableView.contentSize.height - _tableView.frame.size.height-_activityIndicatorView.frame.size.height) {
            [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_replyArr count]-1 inSection:1] atScrollPosition:UITableViewScrollPositionBottom animated:TRUE];
        }
        [[self activityIndicatorView] setHidden:TRUE];
        [[self activityIndicator] stopAnimating];
    }];
    
}

#pragma mark UITableViewDelegate UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (theMoreHeight < 60) {
            return 385;
        }
        return 385+theMoreHeight-70;
    }else if(indexPath.section == 1){
        Reply* reply = [_replyArr objectAtIndex:indexPath.row];
        CGSize size = [reply.content sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(280, 120)];
        return 70+size.height;
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
        [JYGraphic setRoundedView:cell.candidateImgView toDiameter:88.0f];
        cell.parent = self;
        if ([_manifesto.politician haveImg]) {
            [cell.candidateImgView setImageWithURL:[NSURL URLWithString:[_manifesto.politician img]] placeholderImage:[UIImage imageNamed:@"default_image.png"] options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){
                
            }];
        }
        if ([_manifesto.politician haveBgImg]) {
            [cell.bgImgView setImageWithURL:[NSURL URLWithString:[_manifesto.politician bgImg]] placeholderImage:[UIImage imageNamed:@"bg_default.png"] options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){
                
            }];
        }
        cell.nameLabel.text = _manifesto.politician.name;
        cell.positionLabel.text = _manifesto.politician.positionName;
        cell.titleLabel.text = _manifesto.title;
        cell.manifestoLabel.text = _manifesto.descriptionInfo;
        if (theMoreHeight > 60) {
           cell.manifestoLabel.frame = CGRectMake(cell.manifestoLabel.frame.origin.x, cell.manifestoLabel.frame.origin.y, cell.manifestoLabel.frame.size.width, theMoreHeight-30);
            [cell.theMoreLabel setText:@"닫기"];
        }else{
            cell.manifestoLabel.frame = CGRectMake(cell.manifestoLabel.frame.origin.x, cell.manifestoLabel.frame.origin.y, cell.manifestoLabel.frame.size.width, 60);
            [cell.theMoreLabel setText:@"더보기"];
        }
        if (ratingIdx == 1) {
            [cell.goodBtn setSelected:TRUE];
            [cell.fairBtn setSelected:FALSE];
            [cell.poorBtn setSelected:FALSE];
        }else if (ratingIdx == 2) {
            [cell.goodBtn setSelected:FALSE];
            [cell.fairBtn setSelected:TRUE];
            [cell.poorBtn setSelected:FALSE];
        }else if (ratingIdx == 3) {
            [cell.goodBtn setSelected:FALSE];
            [cell.fairBtn setSelected:FALSE];
            [cell.poorBtn setSelected:TRUE];
        }else {
            [cell.goodBtn setSelected:FALSE];
            [cell.fairBtn setSelected:FALSE];
            [cell.poorBtn setSelected:FALSE];
        }
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
        cell.ratingDisAgreeLabel.text = [NSString stringWithFormat:@"비공감 %d",reply.disagreeCnt.integerValue];
        cell.agreeBtn.tag = indexPath.row;
        cell.disAgreeBtn.tag = indexPath.row;
        if (indexPath.row > 3) {
            [cell.bestImgView setHidden:TRUE];
        }
        CGSize size = [reply.content sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(280, 220)];
        [cell.contentLabel setFrame:CGRectMake(cell.contentLabel.frame.origin.x, cell.contentLabel.frame.origin.y, cell.contentLabel.frame.size.width, size.height+20)];
        return cell;
    }
    
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
    //_textView.text = @"";
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
    [_sendBtn setFrame:CGRectMake(_sendBtn.frame.origin.x, 6,_sendBtn.frame.size.width, _sendBtn.frame.size.height)];
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
    [_sendBtn setFrame:CGRectMake(_sendBtn.frame.origin.x, 6+ 18*numLines, _sendBtn.frame.size.width, _sendBtn.frame.size.height)];
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
