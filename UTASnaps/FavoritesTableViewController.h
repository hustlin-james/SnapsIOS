//
//  FavoritesTableViewController.h
//  UTASnaps
//
//  Created by James Fielder on 6/14/14.
//  Copyright (c) 2014 com.mobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoritesTableViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) NSArray *favoriteSnaps;
@end
