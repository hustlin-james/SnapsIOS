//
//  UploadOptionViewController.m
//  UTASnaps
//
//  Created by James Fielder on 6/8/14.
//  Copyright (c) 2014 com.mobi. All rights reserved.
//

#import "UploadOptionViewController.h"
#import "CustomButton.h"
#import "SubmitViewController.h"

@interface UploadOptionViewController ()
@property (weak, nonatomic) IBOutlet CustomButton *cameraBtn;
@property (weak, nonatomic) IBOutlet CustomButton *photosBtn;
@end

@implementation UploadOptionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"Upload";
    }
    return self;
}

- (void)awakeFromNib{
    NSLog(@"waking from nib");
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
- (IBAction)cameraBtnTap:(id)sender {
    UIImagePickerController *imagePicker =
    [[UIImagePickerController alloc] init];
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else{
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}
- (IBAction)photoBtnTap:(id)sender {
    UIImagePickerController *imagePicker =
    [[UIImagePickerController alloc] init];
    
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.4);
    image = [UIImage imageWithData:imageData];
    
    [self dismissViewControllerAnimated:YES completion:^{
        //Go to the submit image views
        SubmitViewController *submit = [SubmitViewController new];
        submit.image = image;
        [self presentViewController:submit animated:YES completion:nil];
        //[self.navigationController pushViewController:submit animated:YES];
    }];
}




@end
