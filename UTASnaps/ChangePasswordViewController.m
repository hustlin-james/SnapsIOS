//
//  ChangePasswordViewController.m
//  UTASnaps
//
//  Created by James Fielder on 6/14/14.
//  Copyright (c) 2014 com.mobi. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "FormsTableViewCell.h"
#import <Parse/Parse.h>

#define NUM_TABLE_ROWS 2

static NSString *const kDefaultCellId = @"default";
static NSString *const kUpdatedPasswordCellId = @"updatedPassword";
static NSString *const kUpdatedVPasswordCellId = @"updatedVPassword";
static NSString *const kCellNibName = @"FormsTableViewCell";

@interface ChangePasswordViewController ()
<UITableViewDataSource, UITableViewDelegate,FormsTextFieldDelegate>{
    NSString *updatedPw;
    NSString *vUpdatedPw;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

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
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapDismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    
    self.tableView.layer.cornerRadius = 5.0;
    [self.tableView registerNib:[UINib nibWithNibName:kCellNibName bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kUpdatedPasswordCellId];
    [self.tableView registerNib:[UINib nibWithNibName:kCellNibName bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kUpdatedVPasswordCellId];
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
    
    if([updatedPw isEqualToString:@""]){
        fieldErrStr = @"New Password field is empty";
    }
    
    if(![vUpdatedPw isEqualToString:updatedPw]){
        fieldErrStr = @"New Password must match verify New Password";
    }
    
    if([fieldErrStr isEqualToString:@""]){
        PFUser *currentUser = [PFUser currentUser];

        if(currentUser){
            currentUser.password = updatedPw;
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

#pragma mark - tableview

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return NUM_TABLE_ROWS;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FormsTableViewCell *cell = nil;
    
    switch (indexPath.row) {
        case 0:{
            cell = [self.tableView dequeueReusableCellWithIdentifier:kUpdatedPasswordCellId];
            cell.textField.placeholder = @"Updated Password";
            cell.delegate = self;
            cell.key = kUpdatedPasswordCellId;
        }
        break;
        case 1:{
            cell =  [self.tableView dequeueReusableCellWithIdentifier:kUpdatedVPasswordCellId];
            cell.textField.placeholder = @"Verfiy Updated Password";
            cell.delegate = self;
            cell.key = kUpdatedVPasswordCellId;
        }
        break;
        default:
            break;
    }
    
    return cell;
}

-(void)textFieldKey:(NSString *)key andValue:(NSString *)value{
    if([key isEqualToString:kUpdatedPasswordCellId]){
        updatedPw = value;
    }else if([key isEqualToString:kUpdatedVPasswordCellId]){
        vUpdatedPw = value;
    }
}

@end
