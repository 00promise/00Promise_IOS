//
//  RegisterViewController.m
//  00Promise
//
//  Created by Rangken on 13. 9. 28..
//  Copyright (c) 2013년 SocialInovation. All rights reserved.
//

#import "RegisterViewController.h"
#import <NSString+CJStringValidator.h>
#import <FSExtendedAlertKit.h>
#import "AFAppDotNetAPIClient.h"
#import "MBProgressHUD.h"
@interface RegisterViewController ()

@end

@implementation RegisterViewController

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
- (IBAction)confirmClick:(id)sender{
    if ([self isValidateTextField:_emailTextField]
        && [self isValidateTextField:_passwordTextField]
        && [self isValidateTextField:_passwordConfirmTextField]) {
        // 모두 성공
        NSMutableDictionary* params = [NSMutableDictionary new];
        [params setObject:_emailTextField.text forKey:@"email"];
        [params setObject:_passwordTextField.text forKey:@"password"];
        [params setObject:_passwordConfirmTextField.text forKey:@"password_confirmation"];
        MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.dimBackground = TRUE;
        [[AFAppDotNetAPIClient sharedClient] postPath:@"users/sign_up.json" parameters:params success:^(AFHTTPRequestOperation *response, id responseObject) {
#ifdef _SERVER_LOG_
            NSLog(@"users/sign_up.json : %@",(NSDictionary *)responseObject);
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
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                
                UINavigationController* naviViewController = [storyboard instantiateViewControllerWithIdentifier:@"mainNavigationController"];
                naviViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                [self presentViewController:naviViewController animated:YES completion:nil];
            }

            [MBProgressHUD hideHUDForView:self.view animated:YES];
        } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
            NSLog(@"users/sign_up.json [HTTPClient Error]: %@", error.localizedDescription);
            FSBlockButton *cancelButton = [FSBlockButton blockButtonWithTitle:@"확인" block:^ {
            }];
            FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"서버공사" message:@"서버 공사중입니다. 잠시만 기다려 주세요." cancelButton:cancelButton otherButtons: nil];
            [alert show];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
}
- (IBAction)loginClick:(id)sender{
    CATransition* transition = [CATransition animation];
    transition.type = kCATransitionMoveIn;
    [transition setDuration:0.5f];
    transition.subtype = kCATransitionFromLeft;
    [transition setType:kCATransitionFade];
    [self.view.window.layer addAnimation:transition forKey:nil ];
    [self dismissViewControllerAnimated:FALSE completion:nil];
}

- (IBAction)tapGestureRecognizer:(id)sender{
    [_emailTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
    [_passwordConfirmTextField resignFirstResponder];
}
- (BOOL)isValidateTextField:(UITextField*)textField
{
    BOOL isValide = TRUE;
    NSString* message;
    if (textField == _passwordTextField || _passwordConfirmTextField) {
        if (![_passwordTextField.text isMinLength:8 andMaxLength:30]) {
            isValide = FALSE;
            message = @"비밀번호를 8~30글자로 입력해주세요.";
        }
       
        if (![_passwordTextField.text isEqualToString:_passwordConfirmTextField.text]) {
            isValide = FALSE;
            message = @"비밀번호를 확인해주세요.";
        }
    }

    if (textField == _emailTextField) {
        if (![_emailTextField.text isEmail]) {
            isValide = FALSE;
            message = @"이메일을 올바르게 입력해주세요.";
        }
        if (![_emailTextField.text isMinLength:6 andMaxLength:30]) {
            isValide = FALSE;
            message = @"이메일을 6~30글자로 입력해주세요.";
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
        [_passwordConfirmTextField becomeFirstResponder];
    }else if (textField == _passwordConfirmTextField){
        [_passwordConfirmTextField resignFirstResponder];
        [self confirmClick:NULL];
    }
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
