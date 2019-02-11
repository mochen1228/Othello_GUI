//
//  ViewController.h
//  LoginLogout
//
//  Created by ChenMo on 4/5/17.
//  Copyright © 2017 ChenMo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (void) attemptLogin;
- (void) dismissKeyboard;

- (IBAction)clearPressed:(UIButton *)sender;

- (IBAction)loginPressed:(UIButton *)sender;

- (BOOL) textFieldShouldReturn:(UITextField *)textField;

@end

