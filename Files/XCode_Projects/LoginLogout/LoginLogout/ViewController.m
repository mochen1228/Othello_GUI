//
//  ViewController.m
//  LoginLogout
//
//  Created by ChenMo on 4/5/17.
//  Copyright © 2017 ChenMo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITextFieldDelegate>

@end

@implementation ViewController
@synthesize usernameTextField, passwordTextField;
@synthesize managedObjectContext = _managedObjectContext;

- (void)viewDidLoad {
    [super viewDidLoad];
    usernameTextField.delegate = self;
    passwordTextField.delegate = self;
    UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)clearPressed:(UIButton *)sender {
    usernameTextField.text = @"";
    passwordTextField.text = @"";
}

- (IBAction)loginPressed:(UIButton *)sender {
    [self attemptLogin];
}

- (void) dismissKeyboard {  // this dismisses the keybaord with whatever the first responder is
    if ([usernameTextField isFirstResponder]) {
        [usernameTextField resignFirstResponder];
    } else if ([passwordTextField isFirstResponder]) {
        [passwordTextField resignFirstResponder];
    }
}

- (void) attemptLogin {
    UIAlertController *loginFailAlert = [UIAlertController alertControllerWithTitle:@"Error!" message:@"Login information incorrect" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *loginFailAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * loginAction) {}];
    
    [loginFailAlert addAction:loginFailAction];
    
    
    if ([passwordTextField.text isEqual: @"12345"] && [usernameTextField.text isEqual:@"cmo3"]) {
        [self performSegueWithIdentifier: @"performLogin" sender: self];
    } else {
        [self presentViewController:loginFailAlert animated:YES completion:nil];
    }
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    if ([usernameTextField.text isEqual:@""]) {
        [usernameTextField becomeFirstResponder];  // username field empty
    } else if ([passwordTextField.text isEqual:@""]) {
        [passwordTextField becomeFirstResponder];  // password field empty
    } else {
        [self attemptLogin];  // both not empty, attempt login
    }
    return YES;
}
@end
