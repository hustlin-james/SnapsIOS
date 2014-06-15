#import <UIKit/UIKit.h>
#import "CollectionCell.h"
#import "Footer.h"

@interface CollectionViewController : UIViewController
<UICollectionViewDelegate,
UICollectionViewDataSource,
FooterProtocolDelegate, UICollectionViewDelegateFlowLayout >
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
