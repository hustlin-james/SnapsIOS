//
//  ImagePopupViewController.h
//  UTASnaps
//
//  Created by James Fielder on 6/13/14.
//  Copyright (c) 2014 com.mobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ImagePopupViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic) UIImage *image;
@property (nonatomic) PFObject *object;


@end
