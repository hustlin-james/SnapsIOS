//
//  ImagePopupViewController.m
//  UTASnaps
//
//  Created by James Fielder on 6/13/14.
//  Copyright (c) 2014 com.mobi. All rights reserved.
//

#import "ImagePopupViewController.h"
#import "CustomScrollView.h"

@interface ImagePopupViewController (){
    UIImageView *imageView;
    CustomScrollView *scrollView;
    
    UIButton *backBtn;
    
    UIView *bottomView;
    
    UITextView *textView;
}

@end

@implementation ImagePopupViewController


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
    scrollView.zoomScale = .1;
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    [self initializeBackBtn];
    [self createBottomView];
    
    [scrollView addSubview:imageView];
    [self.view addSubview:scrollView];
    [self.view addSubview:backBtn];
    [self.view addSubview:bottomView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTouched)];
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(backBtn, bottomView);
   
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[backBtn(100)]" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[backBtn(40)]" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[backBtn]-20-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-40-[backBtn]" options:0 metrics:nil views:views]];
    
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[bottomView(150)]" options:0 metrics:nil views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[bottomView]|" options:0 metrics:nil views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[bottomView]|" options:0 metrics:nil views:views]];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC),
                   dispatch_get_main_queue(), ^{
        [self screenTouched];
    });
}

- (void)initializeBackBtn{
    backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [backBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
    [backBtn setTitle:@"Back" forState:UIControlStateNormal];
    
    backBtn.backgroundColor = [UIColor whiteColor];
    backBtn.layer.cornerRadius = 4;
    backBtn.alpha = .8f;
    
    [backBtn addTarget:self action:@selector(backBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)screenTouched{
     if(!backBtn.isHidden){
         [UIView animateWithDuration:.5 animations:^{
             backBtn.alpha = 0.0f;
             bottomView.alpha = 0.0f;
         } completion:^(BOOL finished){
             backBtn.hidden = YES;
             bottomView.hidden = YES;
         }];
     }else{
         [UIView animateWithDuration:.5 animations:^{
             backBtn.alpha = 0.8f;
             bottomView.alpha = 0.8f;
         } completion:^(BOOL finished){
             backBtn.hidden = NO;
             bottomView.hidden = NO;
         }];
     }
}

- (void) backBtnPressed: (id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) minusCookieBtnPressed: (id)sender{
    [self updateCookieGiveCookie:NO];
}

- (void) favoriteBtnPressed: (id)sender{
    
    PFUser *currentUser = [PFUser currentUser];
    
    if(currentUser){
       if (![[currentUser objectForKey:@"emailVerified"] boolValue]) {
           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email not verified." message:@"Please verify your email and login" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
           [alert show];
       }else{
           NSLog(@"user is logged in and email verified");
       }
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"You must login to favorite" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void) giveCookieBtnPressed: (id)sender{
    [self updateCookieGiveCookie:YES];
}

- (void) updateCookieGiveCookie: (BOOL)giveCookie{
    PFObject *object = self.object;
    
    if(giveCookie){
        object[@"numCookies"] = @([object[@"numCookies"] intValue] +1);
    }else{
        object[@"numCookies"] = @([object[@"numCookies"] intValue] -1);
    }
    
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(succeeded){
            NSString *msg = @"";
            if(giveCookie){
                msg = @"You gave a cookie.";
            }else{
                msg = @"You took away a cookie.";
            }
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
            [object refreshInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                if(!error){
                    self.object = object;
                    [self setTextViewText];
                }
            }];
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Operation failed." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createBottomView{
    bottomView = [UIView new];
    [bottomView setTranslatesAutoresizingMaskIntoConstraints:NO];
    bottomView.backgroundColor = [UIColor whiteColor];
    bottomView.alpha = .8f;
    
    UIButton *minusCookieBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [minusCookieBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
    [minusCookieBtn setTitle:@"Minus Cookie" forState:UIControlStateNormal];
    
    
    UIButton *favoriteBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [favoriteBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
    [favoriteBtn setTitle:@"Favorite" forState:UIControlStateNormal];
    
    UIButton *giveCookieBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [giveCookieBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
    [giveCookieBtn setTitle:@"Give Cookie" forState:UIControlStateNormal];
    
    [minusCookieBtn addTarget:self action:@selector(minusCookieBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [favoriteBtn addTarget:self action:@selector(favoriteBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [giveCookieBtn addTarget:self action:@selector(giveCookieBtnPressed:) forControlEvents:UIControlEventTouchUpInside];

    textView = [UITextView new];
    [textView setTranslatesAutoresizingMaskIntoConstraints:NO];
    textView.font = [UIFont fontWithName:@"Helvetica" size:12];
    textView.scrollEnabled = YES;
    textView.editable = NO;
    
    [self setTextViewText];
    
    [bottomView addSubview:minusCookieBtn];
    [bottomView addSubview:favoriteBtn];
    [bottomView addSubview:giveCookieBtn];
    [bottomView addSubview:textView];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(minusCookieBtn,favoriteBtn,giveCookieBtn,textView);
    NSDictionary *metrics = @{@"btnHeight":@40.0,@"padding":@10.0};
    
    //minusCookieBtn
    [bottomView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[minusCookieBtn(btnHeight)]" options:0 metrics:metrics views:views]];
    [bottomView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[minusCookieBtn]" options:0 metrics:metrics views:views]];
     [bottomView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[minusCookieBtn]-padding-|" options:0 metrics:metrics views:views]];
    
    //favoriteBtn
    [bottomView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[favoriteBtn(40)]" options:0 metrics:metrics views:views]];
    [bottomView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[favoriteBtn]-padding-|" options:0 metrics:metrics views:views]];
    
    NSLayoutConstraint *c = [NSLayoutConstraint constraintWithItem:favoriteBtn
                                                       attribute:NSLayoutAttributeCenterX
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:bottomView
                                                       attribute:NSLayoutAttributeCenterX
                                                      multiplier:1
                                                        constant:0];
    [bottomView addConstraint:c];
   
    //giveCookieBtn
    [bottomView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[giveCookieBtn(btnHeight)]" options:0 metrics:metrics views:views]];
    [bottomView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[giveCookieBtn]-padding-|" options:0 metrics:metrics views:views]];
    [bottomView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[giveCookieBtn]-padding-|" options:0 metrics:metrics views:views]];
    
    
    //textView
    [bottomView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[textView]" options:0 metrics:metrics views:views]];
    [bottomView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[textView]|" options:0 metrics:metrics views:views]];
    
    [bottomView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[textView]-0-[favoriteBtn]" options:0 metrics:metrics views:views]];
}

- (void)setTextViewText{
    int numCookies = [self.object[@"numCookies"] intValue];
    NSString *title = self.object[@"title"];
    NSString *description = self.object[@"description"];
    NSString *publisherUsername = self.object[@"publisherUsername"];
    
    NSString *text = [@"" stringByAppendingFormat:@"Number of cookies: %d\n%@\n%@\npublished by: %@", numCookies,title,description,publisherUsername];
    [textView setText:text];
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageView;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
