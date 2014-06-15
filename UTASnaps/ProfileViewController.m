//
//  ProfileViewController.m
//  UTASnaps
//
//  Created by James Fielder on 6/10/14.
//  Copyright (c) 2014 com.mobi. All rights reserved.
//

#import "ProfileViewController.h"
#import "SessionViewController.h"
#import "ChangePasswordViewController.h"
#import "EditProfileViewController.h"
#import <Parse/Parse.h>

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"Profile";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)favoriteSnapsBtnTapped:(id)sender {
    
}

- (IBAction)editProfileBtnTapped:(id)sender {
    EditProfileViewController *editVc = [EditProfileViewController new];
    [self presentViewController:editVc animated:YES completion:nil];
}

- (IBAction)changePasswordBtnTapped:(id)sender {
    ChangePasswordViewController *changePwVc = [ChangePasswordViewController new];
    [self presentViewController:changePwVc animated:YES completion:nil];
}

- (IBAction)logout:(id)sender {
    PFUser *currentUser = [PFUser currentUser];
    if(currentUser){
        [PFUser logOut];
        SessionViewController *sessVc = [SessionViewController new];
        [self.navigationController setViewControllers:@[sessVc]];
    }
}

@end
