//
//  LoginViewController.m
//  UTASnaps
//
//  Created by James Fielder on 6/10/14.
//  Copyright (c) 2014 com.mobi. All rights reserved.
//

#import <Parse/Parse.h>
#import "LoginViewController.h"
#import "CustomButton.h"
#import "ProfileViewController.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet CustomButton *submitBtn;

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"Login";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.usernameField.delegate = self;
    self.passwordField.delegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapDismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}
- (IBAction)submitBtnTapped:(id)sender {
    if([_usernameField.text isEqualToString:@""] || [_passwordField.text isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc ] initWithTitle:@"Empty Fields" message:@"Please enter an username and password" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        
        NSString *username = _usernameField.text;
        NSString *password = _passwordField.text;
        
        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
            if(user){
                NSLog(@"emailVerified: %@", user[@"emailVerified"]);
                    // Refresh to make sure the user did not recently verify
                    [user refresh];
                    if (![[user objectForKey:@"emailVerified"] boolValue]) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Verify Email" message:@"Please verify your email" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alert show];
                    }else{
                        ProfileViewController *profileVc = [ProfileViewController new];
                        [self.navigationController setViewControllers:@[profileVc]];
                    }
                
            }else{
                NSString *errStr = @"Error logging in";
                if(error) {
                    errStr = error.localizedDescription;
                }
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
        }];
    }
}

- (void) singleTapDismissKeyboard{
    [self.view endEditing:YES];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
