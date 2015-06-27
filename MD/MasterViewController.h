
#import <UIKit/UIKit.h>
#import "NoteManager.h"
#import "AppDelegate.h"

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;
@property NoteManager* manager;
-(void) updateTable;
@end

