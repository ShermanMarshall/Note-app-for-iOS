
#import <Foundation/Foundation.h>
#import "DBManager.h"

@interface DBManager ()

@end

@implementation DBManager

-(instancetype) init {
    self = [super self];
    NSArray* array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    _dbPath = [[array objectAtIndex: 0] stringByAppendingString: @"/notes.db"];
    
    return self;
}

-(NoteManager*) loadDatabase {
    NoteManager* manager = [[NoteManager alloc] init];
    const char* err; char* error;
    if (sqlite3_open([_dbPath UTF8String], &_database) == SQLITE_OK) {
        char* createTable = "create table if not exists notes (id integer primary key autoincrement, title text, tags text, data text)";
        if (sqlite3_exec(_database, createTable, NULL, NULL, &error) == SQLITE_OK) {
            sqlite3_stmt* stmt; char* getData = "select * from notes";
            if (sqlite3_prepare_v2(_database, getData, -1, &stmt, &err) == SQLITE_OK) {
                while (sqlite3_step(stmt) == SQLITE_ROW) {
                    Note* note = [[Note alloc] init];
                    
                    int num = sqlite3_column_int(stmt, 1);
                    note.identifier = (NSInteger) num;
                    note.title = [[NSString alloc] initWithUTF8String:
                                  (char*) sqlite3_column_text(stmt, 2)];
                    
                    char* tags = (char* ) sqlite3_column_text(stmt, 3);
                    
                    if (tags != NULL)
                        note.tags = [note parseTags: tags];
                    
                    char* data = (char*) sqlite3_column_text(stmt, 4);
                    if (data != NULL)
                        note.data = [[NSString alloc] initWithUTF8String: data];
                    
                    NSLog(@"Title: %@\nTags: %@\nText: %@\nID: %lu", note.title, [note returnConcatenatedTags], note.data, note.identifier);
                    [manager.notes addObject: note];
                } sqlite3_finalize(stmt);
                
                sqlite3_close(_database);
            }
            else NSLog(@"%s", err);
        }
        else NSLog(@"%s", error);
    }
    else NSLog(@"Error: couldn't open database");
    
    return manager;
}

-(NSInteger) getIdOf: (Note*) note {
    const char* err; char* getId = "select id from notes where title='%@' and tags='%@'";
    if (sqlite3_open([_dbPath UTF8String], &_database) == SQLITE_OK) {
        sqlite3_stmt* stmt;
        if (sqlite3_prepare_v2(_database, getId, -1, &stmt, &err) == SQLITE_OK) {
            sqlite3_step(stmt);
            sqlite3_close(_database);
            return (NSInteger) sqlite3_column_int(stmt, 1);
        } else
            NSLog(@"%s", err);
        
        sqlite3_close(_database);
    } else
        NSLog(@"Error: couldn't open database");
    NSLog(@"YOu fail me");
    return 0;
}

-(BOOL) saveNote: (Note*) note {
    char* save = "insert into notes values (?, ?, ?, ?)";
    sqlite3_stmt* stmt;
    if (sqlite3_open([_dbPath UTF8String], &_database) == SQLITE_OK) {
        if (sqlite3_prepare_v2(_database, save, -1, &stmt, nil) == SQLITE_OK) {
            sqlite3_bind_text(stmt, 1,  0, -1, NULL);
            sqlite3_bind_text(stmt, 2, [note.title UTF8String], -1, NULL);
            sqlite3_bind_text(stmt, 3, [[note returnConcatenatedTags] UTF8String], -1, NULL);

            sqlite3_bind_text(stmt, 4, [note.data UTF8String], -1, NULL);
            
            if (sqlite3_step(stmt) == SQLITE_DONE) {
                sqlite3_finalize(stmt);
                sqlite3_close(_database);
                NSLog(@"Note titled: %@ saved", note.title);
                return YES;
            } else
                NSLog(@"Error: did not insert value");
        } else
            NSLog(@"Error with statement");
        
        sqlite3_close(_database);
    } else
        NSLog(@"Error: unable to open database");
    
    return NO;
}

-(BOOL) updateNote: (Note*) note {
    const char* err;
    char* update = (char*) [[NSString stringWithFormat:@"update notes set tags='%@', data='%@' where title='%@' and id=%lu", [note returnConcatenatedTags], note.data, note.title, note.identifier] UTF8String];
    
    if (sqlite3_open([_dbPath UTF8String], &_database) == SQLITE_OK) {
        sqlite3_stmt* stmt;
        if (sqlite3_prepare_v2(_database, update, -1, &stmt, &err) == SQLITE_OK) {
            if (sqlite3_step(stmt) == SQLITE_DONE) {
                sqlite3_finalize(stmt);
                NSLog(@"Note id: %lu, title: %@ updated", note.identifier, note.title);
                sqlite3_close(_database);
                return YES;
            } else
                NSLog(@"Error: did not update note");
        } else
            NSLog(@"%s", err);
        
        sqlite3_close(_database);
    } else
        NSLog(@"Error: unable to open database");
    
    return  NO;
}

-(BOOL) deleteNote: (Note*) note {
    const char* err; char* error; char* delete = (char*) [[NSString stringWithFormat: @"DELETE FROM notes WHERE id=%lu", note.identifier] UTF8String];
    if (sqlite3_open([_dbPath UTF8String], &_database) == SQLITE_OK) {
        sqlite3_stmt* stmt;
        if (sqlite3_prepare_v2(_database, delete, -1, &stmt, &err) == SQLITE_OK) {
            if (sqlite3_step(stmt) == SQLITE_DONE) {
                sqlite3_finalize(stmt);
                NSLog(@"%@ deleted", note.title);
                sqlite3_close(_database);
                return YES;
            } else
                NSLog(@"Error: did not delete note");
        } else
            NSLog(@"%s", err);
        
        sqlite3_close(_database);
    } else
        NSLog(@"%s", error);
    
    return NO;
}
@end