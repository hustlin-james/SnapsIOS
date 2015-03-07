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
#import "FormsTableViewCell.h"
#import "ProfileViewController.h"

#define NUM_TABLE_ROWS 2

static NSString *const kDefaultCellId = @"default";
static NSString *const kUsernameCellId = @"username";
static NSString *const kPasswordCellId = @"password";

static NSString *const kCellNibName = @"FormsTableViewCell";

@interface LoginViewController ()
<UITableViewDataSource,UITableViewDelegate, FormsTextFieldDelegate>{
    NSString *username;
    NSString *password;
}

@property (weak, nonatomic) IBOutlet CustomButton *submitBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

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
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapDismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    self.tableView.layer.cornerRadius = 5.0;
    
    [self.tableView registerNib:[UINib nibWithNibName:kCellNibName bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kUsernameCellId];
    [self.tableView registerNib:[UINib nibWithNibName:kCellNibName bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kPasswordCellId];
}
- (IBAction)submitBtnTapped:(id)sender {
    
    
    if([username isEqualToString:@""] || [password isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc ] initWithTitle:@"Empty Fields" message:@"Please enter an username and password" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        
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

#pragma  mark - tableview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return NUM_TABLE_ROWS;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FormsTableViewCell *cell =  nil;
    
    switch(indexPath.row){
        case 0:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:kUsernameCellId];
            cell.delegate = self;
            cell.textField.placeholder = @"Username";
            cell.key = kUsernameCellId;
        }
        break;
        case 1:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:kPasswordCellId];
            cell.delegate = self;
            cell.textField.placeholder = @"Password";
            cell.textField.secureTextEntry = YES;
            cell.key = kPasswordCellId;
        }
        break;
        default:
            break;
    }
    return cell;
}

-(void)textFieldKey: (NSString *)key andValue: (NSString *)value{
    if([key isEqualToString:kUsernameCellId]){
        username = value;
    }else if([key isEqualToString:kPasswordCellId]){
        password = value;
    }
}

@end
