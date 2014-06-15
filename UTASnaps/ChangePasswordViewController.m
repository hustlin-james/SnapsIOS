//
//  ChangePasswordViewController.m
//  UTASnaps
//
//  Created by James Fielder on 6/14/14.
//  Copyright (c) 2014 com.mobi. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import <Parse/Parse.h>

@interface ChangePasswordViewController ()

@property (weak, nonatomic) IBOutlet UITextField *updatedPw;
@property (weak, nonatomic) IBOutlet UITextField *vUpdatedPw;

@end

@implementation ChangePasswordViewController

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
    self.updatedPw.delegate = self;
    self.vUpdatedPw.delegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapDismissKeyboard)];
    [self.view addGestureRecognizer:tap];
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
- (IBAction)submitBtnTapped:(id)sender {
    
    NSString *fieldErrStr = @"";
    
    if([self.updatedPw.text isEqualToString:@""]){
        fieldErrStr = @"New Password field is empty";
    }
    
    if(![self.vUpdatedPw.text isEqualToString:self.updatedPw.text]){
        fieldErrStr = @"New Password must match verify New Password";
    }
    
    if([fieldErrStr isEqualToString:@""]){
        PFUser *currentUser = [PFUser currentUser];

        if(currentUser){
            currentUser.password = self.updatedPw.text;
            [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if(succeeded){
                    [currentUser refresh];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"You have successfully changed your password." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                    
                }else{
                    NSString *errStr = error.localizedDescription;
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                }
            }];
        }
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:fieldErrStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}
- (IBAction)cancelBtnTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
