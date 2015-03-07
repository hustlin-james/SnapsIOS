//
//  SignupTableViewCell.m
//  UTASnaps
//
//  Created by James Fielder on 3/5/15.
//  Copyright (c) 2015 com.mobi. All rights reserved.
//

#import "FormsTableViewCell.h"

@interface FormsTableViewCell()<UITextFieldDelegate>

@end

@implementation FormsTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.textField.delegate  = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.textField resignFirstResponder];
    [self.delegate textFieldKey:self.key andValue:self.textField.text];
    return YES;
}

@end
