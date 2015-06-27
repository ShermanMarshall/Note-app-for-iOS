
#import <Foundation/Foundation.h>
#import "Note.h"

#ifndef MD_SimpleSearch_h
#define MD_SimpleSearch_h


#endif

@interface  SimpleSearch : NSObject
@property (weak) Note* focus;
@property NSInteger hits;
@property NSInteger tagsMatched;
@property NSString* criteria;

-(NSInteger) calcSum;
-(instancetype) init;
@end
