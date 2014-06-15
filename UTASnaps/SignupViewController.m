//
//  SignupViewController.m
//  UTASnaps
//
//  Created by James Fielder on 6/9/14.
//  Copyright (c) 2014 com.mobi. All rights reserved.
//

#import "SignupViewController.h"
#import "CustomButton.h"
#import <Parse/Parse.h>

@interface SignupViewController ()

@property (weak, nonatomic) UITextField *activeField;

@property (weak, nonatomic) IBOutlet UITextField *usernameField;

@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *vPasswordField;
@property (weak, nonatomic) IBOutlet UITextField *majorField;
@property (weak, nonatomic) IBOutlet CustomButton *submitBtn;

@end

@implementation SignupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"Signup";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapDismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}
- (IBAction)submitBtnTapped:(id)sender {
    NSString *errorStr = @"";
    if([_usernameField.text isEqualToString:@""]){
        errorStr = @"Need Username";
    }
    if( [_emailField.text isEqualToString:@""]){
        errorStr = @"Need email";
    }
    
    if( [_passwordField.text isEqualToString:@""]){
        errorStr = @"Need password";
    }
    
    if (![_vPasswordField.text isEqualToString:_passwordField.text]){
        errorStr = @"Verify password must match password";
    }
    
    if( [_majorField.text isEqualToString:@""]){
        errorStr = @"Please enter a major";
    }
    
    if([errorStr isEqualToString:@""]){
        PFUser *user = [PFUser user];
        user.username = _usernameField.text;
        user.password = _passwordField.text;
        user.email = _emailField.text;
        
        user[@"major"] = _majorField.text;
        
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(!error){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Sign up successful. Please verify your email." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }else{
                NSString *errorString = [error userInfo][@"error"];
                errorString = [errorString stringByAppendingString:@"\nPlease try again later"];
            
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
        }];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Missing Field" message:errorStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) singleTapDismissKeyboard{
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
