//
//  SnapContainer.h
//  TestCollectionViewWithXIB
//
//  Created by James Fielder on 6/12/14.
//  Copyright (c) 2014 Quy Sang Le. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface SnapContainer : NSObject

@property (nonatomic) PFObject *object;
@property (nonatomic) UIImage *image;
@property (nonatomic) BOOL showImage;

@end
