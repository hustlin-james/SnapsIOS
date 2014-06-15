//
//  CustomButton.h
//  UTASnaps
//
//  Created by James Fielder on 6/8/14.
//  Copyright (c) 2014 com.mobi. All rights reserved.
//

/*
 Based on code from:
 http://stackoverflow.com/questions/11170116/change-button-background-color-when-clicked
 
 */
#import <UIKit/UIKit.h>

@interface CustomButton : UIButton


- (void) setBackgroundColor:(UIColor *) _backgroundColor forState:(UIControlState) _state;
- (UIColor*) backgroundColorForState:(UIControlState) _state;

@end
