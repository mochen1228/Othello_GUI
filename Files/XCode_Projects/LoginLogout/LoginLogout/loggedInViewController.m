//
//  loggedInViewController.m
//  LoginLogout
//
//  Created by ChenMo on 4/5/17.
//  Copyright © 2017 ChenMo. All rights reserved.
//

#import "loggedInViewController.h"

@interface loggedInViewController ()

@end

@implementation loggedInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)logoutPressed:(UIButton *)sender {
    [self performSegueWithIdentifier:@"performLogout" sender:sender];
}


@end
