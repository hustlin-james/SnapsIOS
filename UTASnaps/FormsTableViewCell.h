//
//  FormsTableViewCell.h
//  UTASnaps
//
//  Created by James Fielder on 3/5/15.
//  Copyright (c) 2015 com.mobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FormsTextFieldDelegate <NSObject>
@required
-(void)textFieldKey: (NSString *)key andValue: (NSString *)value;
@end

@interface FormsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (strong,nonatomic) NSString *key;
@property (nonatomic,weak) id<FormsTextFieldDelegate>delegate;
@end
