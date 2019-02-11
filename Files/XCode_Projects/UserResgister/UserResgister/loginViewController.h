//
//  ViewController.h
//  UserResgister
//
//  Created by ChenMo on 4/8/17.
//  Copyright © 2017 ChenMo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface loginViewController : UIViewController


@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;



- (IBAction)loginButtonPressed:(UIButton *)sender;
- (IBAction)signupButtonPressed:(UIButton *)sender;


- (void) attemptLogin;
- (void) dismissKeyboard;

@end

