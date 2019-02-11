//
//  ViewController.m
//  LoginView
//
//  Created by ChenMo on 4/4/17.
//  Copyright © 2017 ChenMo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)clearPressed:(UIButton *)sender {
    self.usernameText.text = @"";
    self.passwordText.text = @"";
}

- (IBAction)loginPressed:(UIButton *)sender {
    UIAlertController* loginSucceed = [UIAlertController
                                       alertControllerWithTitle: @"Success!"
                                       message: @"You are now logged in."
                                       preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertController* loginFailed = [UIAlertController
                                       alertControllerWithTitle: @"Failed!"
                                       message: @"Username and password combination incorrect."
                                       preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* loginAlertAction = [UIAlertAction
                                       actionWithTitle: @"OK"
                                       style:UIAlertActionStyleDefault
                                       handler: ^(UIAlertAction *loginAction) {}];
    
    // adding actions to alertControllers
    [loginSucceed addAction:loginAlertAction];
    [loginFailed addAction:loginAlertAction];

    if ([self.usernameText.text  isEqual: @"cmo3"]
        && [self.passwordText.text isEqual: @"MMcc1234!!"]) {
        [self presentViewController:loginSucceed animated:YES completion:nil];
    } else {
        [self presentViewController:loginFailed animated:YES completion:nil];
    }
        
}
@end
