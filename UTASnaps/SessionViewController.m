//
//  SessionViewController.m
//  UTASnaps
//
//  Created by James Fielder on 6/8/14.
//  Copyright (c) 2014 com.mobi. All rights reserved.
//

#import "SessionViewController.h"
#import "LoginViewController.h"
#import "SignupViewController.h"
#import <Parse/Parse.h>
#import "ProfileViewController.h"

@interface SessionViewController ()

@end

@implementation SessionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"Account";
    }
    return self;
}

- (IBAction)loginBtnPressed:(id)sender {
    LoginViewController *loginVc = [LoginViewController new];
    [self.navigationController pushViewController:loginVc animated:YES];
}
- (IBAction)signupBtnPressed:(id)sender {
    SignupViewController *signupVc = [SignupViewController new];
    [self.navigationController pushViewController:signupVc animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    PFUser *currentUser = [PFUser currentUser];
    if(currentUser){
        if ([[currentUser objectForKey:@"emailVerified"] boolValue]) {
            ProfileViewController *profileVc = [ProfileViewController new];
            [self.navigationController setViewControllers:@[profileVc]];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
