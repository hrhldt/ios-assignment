//
//  ViewController.m
//  ios-assignment
//
//  Created by Martin Herholdt Rasmussen on 13/05/16.
//  Copyright © 2016 Martin Herholdt Rasmussen. All rights reserved.
//

#import "IALoginViewController.h"

#define kMinimumPasswordCount 6
#define kAlertTime 1.7

@interface IALoginViewController ()

@end

@implementation IALoginViewController
{
    IAUser *userRef;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [self initView];
    [self registerForKeyboardNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View setup

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

//    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    NSNumber* duration = info[UIKeyboardAnimationDurationUserInfoKey];

    [UIView animateWithDuration:duration.doubleValue animations:^{
        self.view.frame = CGRectMake(0, -kbSize.height, self.view.frame.size.width, self.view.frame.size.height);
    }];

//    scrollView.contentInset = contentInsets;
//    scrollView.scrollIndicatorInsets = contentInsets;

    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
//    CGRect aRect = self.view.frame;
//    aRect.size.height -= kbSize.height;
//    if (!CGRectContainsPoint(aRect, self.passwordTextFieldView.inputField.frame.origin) ) {
//
//        [self.scrollView scrollRectToVisible:activeField.frame animated:YES];
//    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
//    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
//    scrollView.contentInset = contentInsets;
//    scrollView.scrollIndicatorInsets = contentInsets;
    NSDictionary* info = [aNotification userInfo];
    //CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

    NSNumber* duration = info[UIKeyboardAnimationDurationUserInfoKey];

    [UIView animateWithDuration:duration.doubleValue animations:^{
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
}

- (void)initView {
    [self.emailTextFieldView setAttributedPlaceholder:NSLocalizedString(@"Username", @"loginEmailPlaceholder")];
    [self.passwordTextFieldView setAttributedPlaceholder:NSLocalizedString(@"Password", @"loginEmailPlaceholder")];
    self.passwordTextFieldView.inputField.secureTextEntry = YES;

    [self.passwordTextFieldView setAsPasswordTextField];
    [self.emailTextFieldView setAsEmailTextField];

    [self.loginButtonView.loginButton addTarget:self action:@selector(didPressLoginButton) forControlEvents:UIControlEventTouchUpInside];
    self.loginButtonView.delegate = self;
}

#pragma mark - Actions

- (void)didPressLoginButton {
    UIAlertView *alert = [[UIAlertView alloc] init];
    NSString *email = self.emailTextFieldView.inputField.text;
    NSString *password = self.passwordTextFieldView.inputField.text;

    [self.emailTextFieldView.inputField resignFirstResponder];
    [self.passwordTextFieldView.inputField resignFirstResponder];

    if ( email.length == 0 ) {
        alert.message = @"Email field is empty";
        [alert show];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kAlertTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alert dismissWithClickedButtonIndex:0 animated:YES];
        });

        [self.loginButtonView reenableLoginButton];
    } else if ( ![Utils validateEmail:self.emailTextFieldView.inputField.text] ) {
        alert.message = @"Email is not valid";
        [alert show];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kAlertTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alert dismissWithClickedButtonIndex:0 animated:YES];
        });

        [self.loginButtonView reenableLoginButton];
    } else if ( password.length < kMinimumPasswordCount ) {
        alert.message = @"Password contain atleast 6 characters";
        [alert show];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kAlertTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alert dismissWithClickedButtonIndex:0 animated:YES];
        });

        [self.loginButtonView reenableLoginButton];
    } else {
        [self.loginButtonView didPressLoginButton];
        [IANetworkDummy requestLoginWithEmail:email password:password delegate:self];
    }
}

#pragma mark - IALoginButtonViewDelegate

- (void)loginButtonDidEndLoginAnimation {
    UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Welcome %@", userRef.email] message:@"You're logged in - log out again to continue" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Logout", nil];
    alert.tag = 112;
    [alert show];
}

- (void)loginButtonDidEndResetAnimation {
    [self.loginButtonView reenableLoginButton];

    self.passwordTextFieldView.inputField.text = @"";
    self.emailTextFieldView.inputField.text = @"";

    [self.emailTextFieldView.inputField becomeFirstResponder];
    [self.passwordTextFieldView resetTextField];
}

#pragma mark - Networking 

- (void)networkDidFailWithError:(NSError *)error {
    if ( error.code == kWrongEmailError || error.code == kWrongPasswordError ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Email or password is not correct - try again" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kAlertTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alert dismissWithClickedButtonIndex:0 animated:YES];
        });
    }
    [self.loginButtonView reenableLoginButton];
}

- (void)networkDidLoginWithUser:(IAUser *)user {
    userRef = user;

    [self.loginButtonView executeRedirectNavigation];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if ( alertView.tag == 112 ) {
        [self.loginButtonView resetButtonState];
    }

}

@end
