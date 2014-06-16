//
//  AddTextViewController.m
//  UTASnaps
//
//  Created by James Fielder on 6/10/14.
//  Copyright (c) 2014 com.mobi. All rights reserved.
//

#import "AddTextViewController.h"
#import "CustomButton.h"
#import <Parse/Parse.h>

@interface AddTextViewController ()

@property (weak, nonatomic) IBOutlet UITextField *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet CustomButton *submitBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelBtn;

@end

@implementation AddTextViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)cancelBarBtnTapped:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)submitBtnTapped:(id)sender {
    
    if([_titleLabel.text isEqualToString:@""] || [_descriptionTextView.text isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc ] initWithTitle:@"Empty Fields" message:@"Please enter a title and a description" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        [self disableFields];
        PFUser *currentUser = [PFUser currentUser];
        
        NSString *publisherUsername = @"anonymous";
        if(currentUser){
            publisherUsername = currentUser.username;
        }
        
        NSData *imageData = UIImageJPEGRepresentation(self.image, 1.0);
        PFFile *imageFile = [PFFile fileWithData:imageData];
        
        PFObject *snap = [PFObject objectWithClassName:@"Snap"];
        snap[@"imageFile"] = imageFile;
        snap[@"title"] = _titleLabel.text;
        snap[@"description"] = _descriptionTextView.text;
        snap[@"numCookies"] = [NSNumber numberWithInt:0];
        snap[@"publisherUsername"] = publisherUsername;
        
        [snap saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(succeeded){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Snap has been uploaded" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }else{
                NSString *errStr = @"Error Uploading";
                if(error){
                    errStr = error.localizedDescription;
                }
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
               
            }
        }];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.title isEqualToString:@"Success"]) {
       [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self enableFields];
    }
}


- (void)disableFields{
    _titleLabel.enabled = NO;
    _descriptionTextView.editable = NO;
    _submitBtn.enabled = NO;
    _cancelBtn.enabled = NO;
}

- (void) enableFields{
    _titleLabel.text = @"";
    _descriptionTextView.text = @"";
    
    _titleLabel.enabled = YES;
    _descriptionTextView.editable = YES;
    _submitBtn.enabled = YES;
    _cancelBtn.enabled = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //self.navigationItem.leftBarButtonItem.enabled=NO;
    //self.navigationController.navigationItem.leftBarButtonItem.enabled = NO;
    
    // Do any additional setup after loading the view from its nib.
    CALayer *descriptionTv = _descriptionTextView.layer;
    [descriptionTv setCornerRadius:10];
    [descriptionTv setBorderWidth:1];
    descriptionTv.borderColor=[[UIColor lightGrayColor] CGColor];
    
    self.titleLabel.delegate = self;
    self.descriptionTextView.delegate = self;
    
    //Create tap gesture to dismiss the keyboard on the view
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapDismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)singleTapDismissKeyboard{
    [self.view endEditing:YES];
}

@end
