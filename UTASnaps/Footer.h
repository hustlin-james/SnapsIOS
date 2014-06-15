//
//  Footer.h
//  TestCollectionViewWithXIB
//
//  Created by James Fielder on 6/12/14.
//  Copyright (c) 2014 Quy Sang Le. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FooterProtocolDelegate <NSObject>
@required
- (void)nextBtnTapped;
- (void)backBtnTapped;
@end

@interface Footer : UICollectionReusableView

@property (nonatomic, strong) id delegate;

@end
