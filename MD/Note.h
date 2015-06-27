
#import <Foundation/Foundation.h>

#ifndef MD_Note_h
#define MD_Note_h


#endif

@interface Note : NSObject
@property (nonatomic) NSString* title;
@property (nonatomic) NSString* data;
@property (nonatomic) NSMutableArray* tags;
@property BOOL newData;
@property NSInteger identifier;

-(void) addTag: (NSString*) tag;
-(NSString*) returnConcatenatedTags;
-(instancetype) init;
-(NSMutableArray*) parseTags: (char*) tagString;
@end