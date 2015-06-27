
#import "MasterViewController.h"
#import "DetailViewController.h"
#import "Note.h"

@interface MasterViewController ()
@property NSMutableArray *objects;
@property UIBarButtonItem* back;
@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(updateTable)];
    
    self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    AppDelegate* delegate = [UIApplication sharedApplication].delegate;
    _manager = delegate.theManager;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
        _manager = delegate.theManager;
        Note* object;
        
        if (_manager.search)
            object = _manager.searchNotes[indexPath.row];
        else
            object  = _manager.notes[indexPath.row];
        
        DetailViewController *controller = (DetailViewController *) [[segue destinationViewController] topViewController];
        [controller setDetailItem:object];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;

        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(void) setListType:(NSInteger)listType {
    _manager.listType = listType;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_manager.search) {
        if ([_manager.searchNotes count] < 1) {
            _manager.voidSearch = TRUE;
            return 1;
        } else
            return [_manager.searchNotes count];
    } else
        return [_manager.notes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    if (cell == nil)
        cell = [[UITableViewCell alloc] init];
    
    Note* note;
    if (_manager.voidSearch) {
        note = [[Note alloc] init];
        cell.textLabel.text = @"No results";
    } else {
        if (_manager.search)
            note = _manager.searchNotes[indexPath.row];
        else
            note = _manager.notes[indexPath.row];
        cell.textLabel.text = note.title;
    }
    
    return cell;
}


-(void) updateTable {
    AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    _manager = delegate.theManager;
    
    [self.tableView reloadData];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
        _manager = delegate.theManager;
        Note* note = _manager.notes[indexPath.row];
        [delegate.dbManager deleteNote: note];
        [_manager.notes removeObjectAtIndex: indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
    [self.tableView reloadData];
}
@end
