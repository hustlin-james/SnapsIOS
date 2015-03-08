//
//  FavoritesTableViewCell.m
//  UTASnaps
//
//  Created by James Fielder on 3/7/15.
//  Copyright (c) 2015 com.mobi. All rights reserved.
//

#import "FavoritesTableViewCell.h"

@implementation FavoritesTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.favoritesImageView.layer.cornerRadius = 5.0;
    self.favoritesImageView.layer.masksToBounds = YES;
    self.favoritesImageView.layer.borderWidth = 0.1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
