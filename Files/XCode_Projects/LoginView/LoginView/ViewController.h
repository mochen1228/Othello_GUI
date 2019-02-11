//
//  ViewController.h
//  LoginView
//
//  Created by ChenMo on 4/4/17.
//  Copyright © 2017 ChenMo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameText;

@property (weak, nonatomic) IBOutlet UITextField *passwordText;

- (IBAction)clearPressed:(UIButton *)sender;

- (IBAction)loginPressed:(UIButton *)sender;

@end

