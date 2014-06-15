//
//  EditProfileViewController.m
//  UTASnaps
//
//  Created by James Fielder on 6/14/14.
//  Copyright (c) 2014 com.mobi. All rights reserved.
//

#import "EditProfileViewController.h"
#import "CustomButton.h"
#import <Parse/Parse.h>

@interface EditProfileViewController (){
    PFUser *currentUser;
}

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *majorField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;

@property (weak, nonatomic) IBOutlet CustomButton *editBtn;
@property (weak, nonatomic) IBOutlet CustomButton *cancelBtn;

@end

@implementation EditProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.usernameField.delegate = self;
    self.majorField.delegate = self;
    self.emailField.delegate = self;
    
    currentUser = [PFUser currentUser];
    [currentUser refresh];
    
    self.usernameField.text = currentUser.username;
    self.majorField.text = currentUser[@"major"];
    self.emailField.text = currentUser.email;

    [self disableTextFields];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)disableTextFields{
    self.usernameField.enabled = NO;
    self.majorField.enabled = NO;
    self.emailField.enabled= NO;
}

- (void)enableTextFields{
    self.usernameField.enabled = YES;
    self.majorField.enabled = YES;
    self.emailField.enabled= YES;
}

- (IBAction)editBtnTapped:(id)sender {
    if([self.editBtn.titleLabel.text isEqualToString:@"Edit"]){
        [self.editBtn setTitle:@"Save" forState:UIControlStateNormal];
        [self enableTextFields];
    }else{
        
        [self disableTextFields];
        
       [self.editBtn setTitle:@"Edit" forState:UIControlStateNormal];
        
        //Save the changes if there are any
        NSString *username = currentUser.username;
        NSString *major = currentUser[@"major"];
        NSString *email = currentUser.email;
        
        if(![self.usernameField.text isEqualToString:@""])
            username = self.usernameField.text;
        
        if(![self.majorField.text isEqualToString:@""])
            major = self.majorField.text;
        
        if(![self.emailField.text isEqualToString:@""])
            email = self.emailField.text;
        
        currentUser.username = username;
        currentUser[@"major"] = major;
        currentUser.email = email;
        
        [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(succeeded){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"You have updated your information" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
    
            }else{
                NSString *errStr = error.localizedDescription;
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
            [self enableTextFields];
        }];
        
    }
}

- (IBAction)cancelBtnTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
@end
