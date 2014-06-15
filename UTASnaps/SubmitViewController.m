//
//  SubmitViewController.m
//  UTASnaps
//
//  Created by James Fielder on 6/9/14.
//  Copyright (c) 2014 com.mobi. All rights reserved.
//

#import "SubmitViewController.h"
#import "CustomScrollView.h"
#import "AddTextViewController.h"

@interface SubmitViewController(){
    UIImageView *imageView;
    CustomScrollView *scrollView;
    
    UIButton *addBtn;
    UIButton *backBtn;
}
@end

@implementation SubmitViewController

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
    // Do any additional setup after loading the view.
    UIImage *image = _image;
    //image = [UIImage imageNamed:@"doge.jpg"];
    imageView = [UIImageView new];
    imageView.image = image;
    [imageView sizeToFit];
    
    CGRect loc = CGRectMake(self.view.bounds.origin.x,
                            self.view.bounds.origin.y,
                            self.view.bounds.size.width,
                            self.view.bounds.size.height);
    
    scrollView = [[CustomScrollView alloc] initWithFrame:loc];
    scrollView.contentSize = image.size;
    scrollView.backgroundColor = [UIColor blackColor];
    
    scrollView.delegate = self;
    scrollView.minimumZoomScale = .25;
    scrollView.maximumZoomScale = 1.0;
    scrollView.zoomScale = .25;
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    [self initializeAddBtn];
    [self initializeBackBtn];
    
    [scrollView addSubview:imageView];
    [self.view addSubview:scrollView];
    [self.view addSubview:addBtn];
    [self.view addSubview:backBtn];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTouched)];
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(addBtn,backBtn);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[addBtn(100)]" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[addBtn(40)]" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[addBtn]" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-40-[addBtn]" options:0 metrics:nil views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[backBtn(100)]" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[backBtn(40)]" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[backBtn]-20-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-40-[backBtn]" options:0 metrics:nil views:views]];
}

- (void)initializeAddBtn{
    addBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [addBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
    [addBtn setTitle:@"Add" forState:UIControlStateNormal];
    
    //addBtn.frame = CGRectMake(boundsWidth-(20+btnWidth), 40, btnWidth,btnHeight);
    addBtn.backgroundColor = [UIColor whiteColor];
    addBtn.layer.cornerRadius = 4;
    addBtn.alpha = .7f;
    
    [addBtn addTarget:self action:@selector(addBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initializeBackBtn{
    backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [backBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
    [backBtn setTitle:@"Back" forState:UIControlStateNormal];
    
    //backBtn.frame = CGRectMake(20,40,btnWidth,btnHeight);
    backBtn.backgroundColor = [UIColor whiteColor];
    backBtn.layer.cornerRadius = 4;
    backBtn.alpha = .7f;
    
    [backBtn addTarget:self action:@selector(backBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)screenTouched{
    if(!addBtn.isHidden){
        [UIView animateWithDuration:.5 animations:^{
            addBtn.alpha = 0.0f;
            backBtn.alpha = 0.0f;
        } completion:^(BOOL finished){
            addBtn.hidden = YES;
            backBtn.hidden = YES;
        }];
    }else{
        [UIView animateWithDuration:.5 animations:^{
            addBtn.alpha = 0.7f;
            backBtn.alpha = 0.7f;
        } completion:^(BOOL finished){
            addBtn.hidden = NO;
            backBtn.hidden = NO;
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) addBtnPressed: (id)sender{
    AddTextViewController *addTextVc = [AddTextViewController new];
    addTextVc.image = self.image;
    [self presentViewController:addTextVc animated:YES completion:nil];
}


- (void) backBtnPressed: (id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageView;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
