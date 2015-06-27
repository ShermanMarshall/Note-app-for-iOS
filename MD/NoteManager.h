
#import <Foundation/Foundation.h>
#import "Note.h"

#ifndef MD_NoteManager_h
#define MD_NoteManager_h


#endif

@interface NoteManager : NSObject
@property (nonatomic) NSMutableArray* notes;
@property (nonatomic) NSMutableArray* titles;
@property (nonatomic) NSMutableArray* tags;     //Title|tag pairs
@property (nonatomic) NSArray* searchNotes;
@property (nonatomic) NSInteger invocation; //May be unncessary
@property NSInteger listType;
@property BOOL search;
@property BOOL voidSearch;

-(instancetype) init;
-(void) addNote: (Note*) note;

@end