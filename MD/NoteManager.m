
#import <Foundation/Foundation.h>
#import "NoteManager.h"
#import "Note.h"
#import "SimpleSearch.h"
#import "sqlite3.h"

@interface NoteManager()

@end

@implementation NoteManager

-(instancetype) init {
    self = [super init];
    _notes = [NSMutableArray array];
    _listType = 0;
    return self;
}

-(void) addNote: (Note*) note {
    [_notes addObject: note];
}
@end