//
//  EditProfileViewController.m
//  UTASnaps
//
//  Created by James Fielder on 6/14/14.
//  Copyright (c) 2014 com.mobi. All rights reserved.
//

#import "EditProfileViewController.h"
#import "CustomButton.h"
#import "FormsTableViewCell.h"
#import <Parse/Parse.h>

#define NUM_TABLE_ROWS 3

static NSString* const kDefaultCellId = @"default";
static NSString* const kUsernameCellId = @"username";
static NSString* const kEmailCellId = @"email";
static NSString* const kMajorCellId = @"major";
static NSString *kCellNibName = @"FormsTableViewCell";


@interface EditProfileViewController ()
<UITableViewDataSource, UITableViewDelegate, FormsTextFieldDelegate>{
    PFUser *currentUser;
}

@property (strong,nonatomic) NSString *username;
@property (strong,nonatomic) NSString *major;
@property (strong,nonatomic) NSString *email;

@property (weak, nonatomic) IBOutlet CustomButton *editBtn;
@property (weak, nonatomic) IBOutlet CustomButton *cancelBtn;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

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
    
    currentUser = [PFUser currentUser];
    [currentUser refresh];

    self.username = currentUser.username;
    self.major = currentUser[@"major"];
    self.email = currentUser.email;

    //[self disableTextFields];
    self.tableView.layer.cornerRadius = 5.0;
    self.tableView.allowsSelection = NO;
    
    [self.tableView registerNib:[UINib nibWithNibName:kCellNibName bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kUsernameCellId];
    [self.tableView registerNib:[UINib nibWithNibName:kCellNibName bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kEmailCellId];
    [self.tableView registerNib:[UINib nibWithNibName:kCellNibName bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kMajorCellId];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)editBtnTapped:(id)sender {

        //Save the changes if there are any
        NSString *username = currentUser.username;
        NSString *major = currentUser[@"major"];
        NSString *email = currentUser.email;
        
        if(![self.username isEqualToString:@""])
            username = self.username;
        
        if(![self.major isEqualToString:@""])
            major = self.major;
        
        if(![self.email isEqualToString:@""])
            email = self.email;
        
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
        }];
        
}

- (IBAction)cancelBtnTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - tables
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return NUM_TABLE_ROWS;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FormsTableViewCell *cell = nil;
    
    switch (indexPath.row) {
        case 0:
        {
            cell = [self.tableView dequeueReusableCellWithIdentifier:kUsernameCellId];
            cell.delegate = self;
            cell.textField.placeholder = self.username;
        }
        break;
        case 1:
        {
            cell = [self.tableView dequeueReusableCellWithIdentifier:kEmailCellId];
            cell.delegate = self;
            cell.textField.placeholder = self.email;
        }
        break;
        case 2:
        {
            cell = [self.tableView dequeueReusableCellWithIdentifier:kMajorCellId];
            cell.delegate = self;
            cell.textField.placeholder = self.major;
        }
        break;
        default:
            break;
    }
    
    return cell;
}

-(void)textFieldKey:(NSString *)key andValue:(NSString *)value{
    if([key isEqualToString:kUsernameCellId]){
        self.username = value;
    }
    else if([key isEqualToString:kEmailCellId]){
        self.email = value;
    }
    else if([key isEqualToString:kMajorCellId]){
        self.major = value;
    }
}
@end
