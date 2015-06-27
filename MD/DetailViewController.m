
#import "MasterViewController.h"
#import "DetailViewController.h"
#import "AppDelegate.h"
#import "NoteManager.h"

@interface DetailViewController ()

@property (strong, nonatomic) IBOutlet UINavigationItem *navTitle;
@property (strong, nonatomic) IBOutlet UITextField *head;
@property (strong, nonatomic) IBOutlet UITextView *tagView;

@property (strong, nonatomic) IBOutlet UITextView *noteView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *tagButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *searchButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *makeNewNote;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *webButton;

@property NoteManager* manager;
@property Note* currentNote;
@property DBManager* dbManager;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    
    _currentNote = newDetailItem;
    
    // Update the view
    [self configureView];
}

- (IBAction)makeNewNote:(id)sender {
    Note* newNote = [[Note alloc] init];
    _currentNote = newNote;
    [self configureView];
}

- (IBAction)addTag:(id)sender {
    NSCharacterSet* set = [NSCharacterSet characterSetWithCharactersInString:@" "];
    
    NSString* potentialTag = [_head.text stringByTrimmingCharactersInSet: set];
    
    if ([_head.text isEqualToString: @""])
        return;
    
    for (NSString* tag in _currentNote.tags) {
        if ([tag isEqualToString: potentialTag])
            return;
    }
    
    if ([_navTitle.title isEqualToString: @"New Note"])
        _currentNote.title = potentialTag;
    
    _manager.search = FALSE;
    [_currentNote.tags addObject: potentialTag];
    _tagView.text = [_currentNote returnConcatenatedTags];
    _currentNote.newData = YES;
    
    [self saveNote: sender];
    [self configureView];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    _manager.listType = 0;
    [_tagView resignFirstResponder];
    [_noteView resignFirstResponder];
    [_head resignFirstResponder];
}

- (IBAction)saveNote:(id)sender {
    
    if ((!_currentNote.newData) && ([_noteView.text isEqualToString: @""]))
        return;
    
    if (![_head.text isEqualToString: @""])
        if ([_currentNote.title isEqualToString: @"New Note"])
            [self addTag: sender];
    
    _currentNote.data = _noteView.text;
    
    for (Note* note in _manager.notes)
        if (([note.title isEqualToString: _currentNote.title]) &&
            (note.identifier == _currentNote.identifier)) {
            [_dbManager updateNote: note];
            return;
        }
    
    _manager.search = FALSE;
    [_manager.notes addObject: _currentNote];
    [_dbManager saveNote: _currentNote];
    _currentNote.identifier = [_dbManager getIdOf: _currentNote];
    
    _currentNote.newData = NO;
    
    [self configureView];
}

- (IBAction)searchNotes:(id)sender {
    MasterViewController* master = [self.splitViewController.viewControllers firstObject];
    UISplitViewController* one;
    AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    one = (UISplitViewController*) delegate.window.rootViewController;
    
    NSString* criteria = [[_head text] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    
    NSMutableArray* soughtValues = [[NSMutableArray alloc] init];
    for (Note* note in _manager.notes) {
        if ([note.title isEqualToString: criteria])
            [soughtValues addObject: note];
    }
    
    _manager.searchNotes = soughtValues;
    _manager.search = TRUE;
    
    [self showViewController: master sender: master];
}

- (void)configureView {
    // Update the user interface for the detail item.
    AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    
    _manager = delegate.theManager;
    _dbManager = delegate.dbManager;
    
    if (_currentNote == nil) {
        Note* aNote = [[Note alloc] init];
        _currentNote = aNote;
    }
    
    self.head.text = @"";
    self.navTitle.title = _currentNote.title;
    self.tagView.text = [_currentNote returnConcatenatedTags];
    self.noteView.text = _currentNote.data;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
