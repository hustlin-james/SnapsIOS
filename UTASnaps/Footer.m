//
//  Footer.m
//  TestCollectionViewWithXIB
//
//  Created by James Fielder on 6/12/14.
//  Copyright (c) 2014 Quy Sang Le. All rights reserved.
//

#import "Footer.h"
#import "CustomButton.h"

@interface Footer()

@property (weak, nonatomic) IBOutlet CustomButton *backBtn;
@property (weak, nonatomic) IBOutlet CustomButton *nextBtn;

@end

@implementation Footer

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (IBAction)next:(id)sender {
    [self.delegate nextBtnTapped];
}
- (IBAction)back:(id)sender {
    [self.delegate backBtnTapped];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
