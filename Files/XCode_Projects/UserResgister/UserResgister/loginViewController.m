//
//  ViewController.m
//  UserResgister
//
//  Created by ChenMo on 4/8/17.
//  Copyright © 2017 ChenMo. All rights reserved.
//

#import "loginViewController.h"

@interface loginViewController () <UITextFieldDelegate>

@end

@implementation loginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _usernameTextField.delegate = self;
    _passwordTextField.delegate = self;
    UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];

    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)loginButtonPressed:(UIButton *)sender {
    [self attemptLogin];
    
}

- (IBAction)signupButtonPressed:(UIButton *)sender {
    
}


- (void) attemptLogin {
    UIAlertController *loginFailAlert = [UIAlertController alertControllerWithTitle:@"Error!" message:@"Login information incorrect" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *loginFailAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * loginAction) {}];
    
    [loginFailAlert addAction:loginFailAction];
    
    
    if ([_passwordTextField.text isEqual: @"12345"] && [_usernameTextField.text isEqual:@"cmo3"]) {
        [self performSegueWithIdentifier: @"performLogin" sender: self];
    } else {
        [self presentViewController:loginFailAlert animated:YES completion:nil];
    }
}

- (void) dismissKeyboard {  // this dismisses the keybaord with whatever the first responder is
    if ([_usernameTextField isFirstResponder]) {
        [_usernameTextField resignFirstResponder];
    } else if ([_passwordTextField isFirstResponder]) {
        [_passwordTextField resignFirstResponder];
    }
}


- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    if ([_usernameTextField.text isEqual:@""]) {
        [_usernameTextField becomeFirstResponder];  // username field empty
    } else if ([_passwordTextField.text isEqual:@""]) {
        [_passwordTextField becomeFirstResponder];  // password field empty
    } else {
        [self attemptLogin];  // both not empty, attempt login
    }
    return YES;
}


@end
