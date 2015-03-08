//
//  FavoritesTableViewController.m
//  UTASnaps
//
//  Created by James Fielder on 6/14/14.
//  Copyright (c) 2014 com.mobi. All rights reserved.
//

#import "FavoritesTableViewController.h"
#import "ImagePopupViewController.h"
#import "FavoritesTableViewCell.h"
#import <Parse/Parse.h>

static NSString* const kFavoritesCellId = @"favoritesCell";
static NSString *kCellNibName = @"FavoritesTableViewCell";

@interface FavoritesTableViewController ()

@end

@implementation FavoritesTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Favorite Snaps";
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.tableView registerNib:[UINib nibWithNibName:kCellNibName bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kFavoritesCellId];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.favoriteSnaps count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FavoritesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFavoritesCellId];
    
    PFObject *object = self.favoriteSnaps[indexPath.row];
    cell.favoritesTextLabel.text = object[@"title"];
    
    PFFile *imageFile = object[@"imageFile"];
    
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if(data) {
            UIImage *image = [UIImage imageWithData:data];
            cell.favoritesImageView.image = image;
            
            
        }
    }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *object = self.favoriteSnaps[indexPath.row];
    
    PFFile *imageFile = object[@"imageFile"];
    
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if(data) {
            UIImage *image = [UIImage imageWithData:data];
            
            ImagePopupViewController *ipVc = [ImagePopupViewController new];
            ipVc.object =object;
            ipVc.image =image;
            [self presentViewController:ipVc animated:YES completion:nil];
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to retrieve image." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}
@end
