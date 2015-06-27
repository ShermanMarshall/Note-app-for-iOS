
#import "sqlite3.h"
#import <Foundation/Foundation.h>
#import "NoteManager.h"
#import "Note.h"

#ifndef MD_DBManager_h
#define MD_DBManager_h


#endif

@interface DBManager : NSObject
@property sqlite3* database;
@property NSString* dbPath;

-(instancetype) init;

-(BOOL) saveNote: (Note*) note;
-(BOOL) updateNote: (Note*) note;
-(BOOL) deleteNote: (Note*) note;
-(NoteManager*) loadDatabase;
-(NSInteger) getIdOf: (Note*) note;
@end