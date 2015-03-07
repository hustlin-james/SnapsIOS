//
//  SignupViewController.m
//  UTASnaps
//
//  Created by James Fielder on 6/9/14.
//  Copyright (c) 2014 com.mobi. All rights reserved.
//

#import "SignupViewController.h"
#import "CustomButton.h"
#import "FormsTableViewCell.h"
#import <Parse/Parse.h>


#define NUM_TABLE_ROWS 5


static NSString* const kDefaultCellId = @"default";
static NSString* const kUsernameCellId = @"username";
static NSString* const kEmailCellId = @"email";
static NSString* const kPasswordCellId = @"password";
static NSString* const kVPasswordCellId = @"vPassword";
static NSString* const kMajorCellId = @"major";

static NSString* const kCellNibName = @"FormsTableViewCell";


@interface SignupViewController () <UITableViewDataSource,UITableViewDelegate,FormsTextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *vPassword;
@property (strong, nonatomic) NSString *major;

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
   
    //Moves the form up, for some reason the top part has spaces before the first row.
    self.tableView.contentInset = UIEdgeInsetsMake(-64.0f, 0.0f, 0.0f, 0.0f);
    self.tableView.layer.cornerRadius = 5.0;
    
    [self.tableView registerNib:[UINib nibWithNibName:kCellNibName bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kUsernameCellId];
    [self.tableView registerNib:[UINib nibWithNibName:kCellNibName bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kEmailCellId];
    [self.tableView registerNib:[UINib nibWithNibName:kCellNibName bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kPasswordCellId];
    [self.tableView registerNib:[UINib nibWithNibName:kCellNibName bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kVPasswordCellId];
    [self.tableView registerNib:[UINib nibWithNibName:kCellNibName bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kMajorCellId];
}
- (IBAction)submitBtnTapped:(id)sender {
    
    NSString *errorStr = @"";
    if([self.username isEqualToString:@""]){
        errorStr = @"Need Username";
    }
    if( [self.email isEqualToString:@""]){
        errorStr = @"Need email";
    }
    
    if( [self.password isEqualToString:@""]){
        errorStr = @"Need password";
    }
    
    if (![self.vPassword isEqualToString:self.password]){
        errorStr = @"Verify password must match password";
    }
    
    if( [self.major isEqualToString:@""]){
        errorStr = @"Please enter a major";
    }
    
    if([errorStr isEqualToString:@""]){
        PFUser *user = [PFUser user];
        user.username =  self.username;
        user.password =  self.password;
        user.email = self.email;
        
        user[@"major"] = self.major;
        
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

#pragma mark - TableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return NUM_TABLE_ROWS;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    FormsTableViewCell *cell = nil;
    
    switch (indexPath.row) {
        case 0:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:kUsernameCellId];
            cell.delegate  = self;
            cell.key = kUsernameCellId;
            cell.textField.placeholder = @"Username";
        }
        break;
        case 1:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:kEmailCellId];
            cell.textField.placeholder = @"Email";
            cell.delegate = self;
            cell.key = kEmailCellId;
        }
        break;
        case 2:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:kPasswordCellId];
            cell.textField.placeholder = @"Password";
            cell.delegate = self;
            cell.key = kPasswordCellId;
            cell.textField.secureTextEntry = YES;
        }
        break;
        case 3:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:kVPasswordCellId];
            cell.textField.placeholder = @"Verify Password";
            cell.delegate = self;
            cell.key = kVPasswordCellId;
            cell.textField.secureTextEntry = YES;
        }
        break;
        case 4:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:kMajorCellId];
            cell.textField.placeholder = @"Major";
            cell.delegate = self;
            cell.key = kMajorCellId;
        }
        break;
        default:
            break;
    }
    
    if (!cell) {
        UITableViewCell *c = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kDefaultCellId];
        c.selectionStyle = UITableViewCellSelectionStyleNone;
        c.textLabel.textColor = [UIColor blackColor];
        
        return c;
    }
    
    return cell;
}

- (void)textFieldKey:(NSString *)key andValue:(NSString *)value{
    
    
    if([key isEqualToString:kUsernameCellId]){
        self.username = value;
    }else if([key isEqualToString:kEmailCellId]){
        self.email = value;
    }else if( [key isEqualToString:kPasswordCellId]){
        self.password = value;
    }else if( [key isEqualToString:kVPasswordCellId]){
        self.vPassword = value;
    }else if([key isEqualToString:kMajorCellId]){
        self.major = value;
    }
}

@end
