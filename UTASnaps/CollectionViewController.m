
#import "CollectionViewController.h"
#import "Footer.h"
#import "SnapContainer.h"
#import "ImagePopupViewController.h"
#import <Parse/Parse.h>

#define NUM_CELLS_PER_PAGE 6

@interface CollectionViewController (){
    int currentPage;
    NSMutableArray *itemsContainer;
    NSMutableArray *currentItems;
    int maxPages;
    
    UIImage *imagePlaceholder;
    
    NSFileManager *fileManager;
    NSString *documentsDirectory;
}

@end

@implementation CollectionViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        self.navigationItem.title = @"Images";
        fileManager = [NSFileManager defaultManager];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        documentsDirectory = [paths objectAtIndex:0];
        
        currentPage = 0;
        maxPages = -1;
        itemsContainer = [[NSMutableArray alloc]init];
        
        imagePlaceholder = [UIImage imageNamed:@"placeholder.jpg"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionCell" bundle:nil] forCellWithReuseIdentifier:@"CELL"];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"Footer" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    
    //[self parseImagesRetrieve];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self parseImagesRetrieveCoordinator];
    });
     //[self parseImagesRetrieveCoordinator];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"MEMORY WARNING");
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return NUM_CELLS_PER_PAGE;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (CollectionCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL" forIndexPath:indexPath];
    SnapContainer *s = currentItems[indexPath.item];
    
    if(s.showImage == YES){
        SnapContainer *s = currentItems[indexPath.item];
        if(s.image){
            cell.imageView.image = s.image;
        }
        else{
            NSString *name = [@"" stringByAppendingFormat:@"%d_%d", currentPage,indexPath.item];
            if([self doesFileExistWithName:name] && !s.image){
                s.image = [self loadImageWithName:name];
                cell.imageView.image = s.image;
            }
        }
    }else{
        cell.imageView.image = imagePlaceholder;
    }
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //TODO
    SnapContainer *s = currentItems[indexPath.item];
    
    ImagePopupViewController *ipVc = [ImagePopupViewController new];
    ipVc.image = s.image;
    ipVc.object = s.object;
    
    [self presentViewController:ipVc animated:YES completion:nil];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 5, 5, 5);

}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
     if (kind == UICollectionElementKindSectionFooter) {
         Footer *footer = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
         footer.delegate = self;
         reusableview = footer;
     }
    return reusableview;
}

- (void)nextBtnTapped{
    if(maxPages == currentPage){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"End" message:@"Thats all the snaps!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        //clear previous page to mantain a small cache
        [self clearOldImagesNext: YES];
        currentPage++;
        /*
         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
         [self parseImagesRetrieveCoordinator];
         });
         */
        [self parseImagesRetrieveCoordinator];
    }
}

- (void)backBtnTapped{
    if(currentPage > 0){
        [self clearOldImagesNext: NO];
        currentPage--;
        [self parseImagesRetrieveCoordinator];
        //NSLog(@"currentPage: %d", currentPage);
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"First Page" message:@"You are on the first page!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)clearOldImagesNext: (BOOL)next{
    //reload the curret page images to blanks
    //clear currentPage - 1 items to nil;
    //delete currentPage - 2 items from disk
    
    int currentPageLessOne = currentPage - 1;
    int currentPageLessTwo = currentPage - 2;
    
    int currentPagePlusOne = currentPage + 1;
    int currentPagePlusTwo = currentPage + 2;

    for(int i = 0; i < NUM_CELLS_PER_PAGE; i++){
        
        //Reloading the current page to prepare for the next set of images
        SnapContainer *c = currentItems[i];
        c.showImage = NO;
        
        //cancel any downloading
        PFFile *file = c.object[@"imageFile"];
        [file cancel];
        
        NSIndexPath *ip = [NSIndexPath indexPathForItem:i inSection:0];
        [self.collectionView reloadItemsAtIndexPaths:@[ip]];
        
        //next button pressed
        if(next){
            //Clears the currentPage - 1 items
            if(currentPageLessOne >= 0){
                NSMutableArray *previousLessOneItems = itemsContainer[currentPageLessOne];
                c = previousLessOneItems[i];
                c.image = nil;
            }
            
            //Clear the currentPage - 2 files in dir
            if(currentPageLessTwo >= 0){
                NSString *name = [@"" stringByAppendingFormat:@"%d_%d", currentPageLessTwo,i];
                if( [self doesFileExistWithName:name]){
                    //delete file
                    if(![self deleteFileWithName:name])
                        NSLog(@"unable to delete: %@", name);
                }
            }
        }
        //Previous button pressed
        else{
            
            //Clears the currentPage + 1 Items
            if(currentPagePlusOne < itemsContainer.count){
                NSMutableArray *nextPlusOneItems = itemsContainer[currentPagePlusOne];
                c = nextPlusOneItems[i];
                c.image = nil;
            }
            
            if(currentPagePlusTwo < itemsContainer.count){
                NSString *name = [@"" stringByAppendingFormat:@"%d_%d", currentPagePlusTwo,i];
                if([self doesFileExistWithName:name]){
                    if(![self deleteFileWithName:name])
                        NSLog(@"unable to delete: %@", name);
                }
            }
            
        }
    }
}


/*
 
 MAKE SURE YOU ARE CALLING parseImagesRetrieveCoordinator
 or parseImagesRetrieve, you have a RECURSION LOOP
 
 */
-(void)parseImagesRetrieveCoordinator{
    
    //The next has no data, hitting the next page the first time
    if(itemsContainer.count == currentPage){
        NSMutableArray *newItems = [[NSMutableArray alloc] init];
        for(int i =0; i < NUM_CELLS_PER_PAGE; i++){
            SnapContainer *temp = [SnapContainer new];
            [newItems addObject:temp];
        }
        [itemsContainer addObject:newItems];
        currentItems = itemsContainer[currentPage];
        [self parseImagesRetrieve];
    }else{
        
        currentItems = itemsContainer[currentPage];
        
        BOOL imagesInCache = NO;
        BOOL imagesInFile = NO;
        
        for(int i = 0; i < NUM_CELLS_PER_PAGE; i++){
            SnapContainer *s = currentItems[i];
            s.showImage = YES;
            
            //Check if the images already exists in cache
            if(s.image != nil){
                //The current page cache has images
                imagesInCache = YES;
            }
            //Check if it is in file and update the cache
            else{
                NSString *name = [@"" stringByAppendingFormat:@"%d_%d", currentPage, i];
                if([self doesFileExistWithName:name]){
                    imagesInFile = YES;
                    s.image = [self loadImageWithName:name];
                }
            }
            
            if(imagesInCache || imagesInFile){
                NSIndexPath *ip = [NSIndexPath indexPathForItem:i inSection:0];
                [self.collectionView reloadItemsAtIndexPaths:@[ip]];
            }
        }
        
        if(imagesInCache || imagesInFile){
            //NSLog(@"imagesInCache or File");
            //[self.collectionView reloadData];
        }else{
            
            dispatch_async(
                dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                //Background Thread
                [self parseImagesRetrieve];
            });
        }
    }
}

-(void)parseImagesRetrieve{
    int offset = currentPage * NUM_CELLS_PER_PAGE;
    
    //Query customization
    PFQuery *query = [PFQuery queryWithClassName:@"Snap"];
    [query orderByDescending:@"numCookies"];
    query.skip = offset;
    query.limit = NUM_CELLS_PER_PAGE;
    
    //Block to execute
    void(^myBlock)(NSArray *objects, NSError *error) = ^(NSArray *objects, NSError *error){
        if(!error){
            
            if(objects.count < NUM_CELLS_PER_PAGE){
                maxPages = currentPage;
            }
            
            for(int i = 0; i < objects.count; i++){
                PFObject *object = objects[i];
                
                SnapContainer *s = currentItems[i];
                s.object = object;
                PFFile *imageFile = object[@"imageFile"];
                
                [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                     if(!error){
                         UIImage *image = [UIImage imageWithData:data];
                         NSString *name = [@"" stringByAppendingFormat:@"%d_%d", currentPage,i];
                         [self saveImage:image withName:name];
                         
                         /*
                         dispatch_async(dispatch_get_main_queue(), ^{
                             NSIndexPath *ip = [NSIndexPath indexPathForItem:i inSection:0];
                             [self.collectionView reloadItemsAtIndexPaths:@[ip]];
                         });
                          */
                         
                         NSIndexPath *ip = [NSIndexPath indexPathForItem:i inSection:0];
                         [self.collectionView reloadItemsAtIndexPaths:@[ip]];
                         
                     }else{
                         NSLog(@"couln't retrieve image: %@", [error localizedDescription]);
                     }
                 }];
            }
        }else{
            NSLog(@"error retrieving objects");
        }
    };
    
    [query findObjectsInBackgroundWithBlock:myBlock];
}
- (void)saveImage: (UIImage*)image withName: (NSString *)name
{
    if (image != nil)
    {
        NSString* path = [documentsDirectory stringByAppendingPathComponent:
                          [NSString stringWithString:name] ];
        NSData* data = UIImageJPEGRepresentation(image, 0.6);
        [data writeToFile:path atomically:YES];
    }
}

- (UIImage*)loadImageWithName: (NSString *)name
{
    NSString* path = [documentsDirectory stringByAppendingPathComponent:
                      [NSString stringWithString:name]];
    UIImage* image = [UIImage imageWithContentsOfFile:path];
    return image;
}

- (BOOL)doesFileExistWithName: (NSString *)name{
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:name];
    BOOL fileExists = [fileManager fileExistsAtPath:filePath];
    return fileExists;
}

- (BOOL)deleteFileWithName: (NSString *)name{
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:name];
    NSError *error = nil;
    [fileManager removeItemAtPath:filePath error:&error];
    if(error){
        return NO;
    }
    return YES;
}

@end
