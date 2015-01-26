//
//  LoginViewController.m
//  00Promise
//
//  Created by Rangken on 13. 9. 28..
//  Copyright (c) 2013년 SocialInovation. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "AppDelegate.h"
#import <NSString+CJStringValidator.h>
#import <FSExtendedAlertKit.h>
#import "AFAppDotNetAPIClient.h"
#import "MBProgressHUD.h"
@interface LoginViewController ()

@end

@implementation LoginViewController

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
- (IBAction)loginClick:(id)sender{
    [_emailTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
    NSMutableDictionary* params = [NSMutableDictionary new];
    [params setObject:_emailTextField.text forKey:@"email"];
    [params setObject:_passwordTextField.text forKey:@"password"];
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = TRUE;
    [[AFAppDotNetAPIClient sharedClient] postPath:@"users/sign_in.json" parameters:params success:^(AFHTTPRequestOperation *response, id responseObject) {
#ifdef _SERVER_LOG_
        NSLog(@"users/sign_in.json : %@",(NSDictionary *)responseObject);
#endif
        NSString* code = [responseObject objectForKey:@"code"];
        if (![code isEqualToString:@"0000"]) {
            FSBlockButton *cancelButton = [FSBlockButton blockButtonWithTitle:@"확인" block:^ {
            }];
            FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"에러" message:[responseObject objectForKey:@"message"] cancelButton:cancelButton otherButtons: nil];
            [alert show];
        }else{
            NSDictionary* userDic = [responseObject objectForKey:@"data"];
            [[NSUserDefaults standardUserDefaults] setValue:[userDic objectForKey:@"auth_token"] forKey:@"authToken"];
            [[NSUserDefaults standardUserDefaults] setValue:[userDic objectForKey:@"email"] forKey:@"email"];
            [[AFAppDotNetAPIClient sharedClient] setAuthorizationHeaderWithToken:[userDic objectForKey:@"auth_token"]];
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            UINavigationController* naviViewController = [storyboard instantiateViewControllerWithIdentifier:@"mainNavigationController"];
            naviViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self presentViewController:naviViewController animated:YES completion:nil];
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
        NSLog(@"users/sign_in.json [HTTPClient Error]: %@", error.localizedDescription);
        FSBlockButton *cancelButton = [FSBlockButton blockButtonWithTitle:@"확인" block:^ {
        }];
        FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"서버공사" message:@"서버 공사중입니다. 잠시만 기다려 주세요." cancelButton:cancelButton otherButtons: nil];
        [alert show];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
- (IBAction)registerClick:(id)sender{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RegisterViewController* registerViewController = [storyboard instantiateViewControllerWithIdentifier:@"registerViewController"];
    
    CATransition* transition = [CATransition animation];
    transition.type = kCATransitionMoveIn;
    [transition setDuration:0.5f];
    transition.subtype = kCATransitionFromLeft;
    [transition setType:kCATransitionFade];
    [self.view.window.layer addAnimation:transition forKey:nil ];
    [self presentViewController:registerViewController animated:FALSE completion:nil];
}
- (IBAction)tapGestureRecognizer:(id)sender{
    [_emailTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
}
- (BOOL)isValidateTextField:(UITextField*)textField
{
    BOOL isValide = TRUE;
    NSString* message;
    
    if (textField == _emailTextField) {
        if (![_emailTextField.text isEmail]) {
            isValide = FALSE;
            message = @"이메일을 올바르게 입력해주세요.";
        }

    }
    if (!isValide) {
        FSBlockButton *cancelButton = [FSBlockButton blockButtonWithTitle:@"확인" block:^ {
        }];
        FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"에러" message:message cancelButton:cancelButton otherButtons: nil];
        [alert show];
    }
    return isValide;
}
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    
    return TRUE;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{return YES;}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{return YES;}
- (BOOL)textFieldShouldClear:(UITextField *)textField
{return YES;}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _emailTextField) {
        [_passwordTextField becomeFirstResponder];
    }else if (textField == _passwordTextField) {
        [_passwordTextField resignFirstResponder];
        [self loginClick:NULL];
    }
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
