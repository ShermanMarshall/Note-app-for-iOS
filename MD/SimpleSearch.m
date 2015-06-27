
#import <Foundation/Foundation.h>
#import "SimpleSearch.h"
#import "Note.h"

@interface  SimpleSearch()

@end

@implementation SimpleSearch

-(instancetype) init {
    self = [super init];
    
    _hits = 0;
    _tagsMatched = 0;
    
    return self;
}

-(instancetype) init: (NSString*) criteria {
    self = [super init];
    _criteria = criteria;
    _hits = 0;
    _tagsMatched = 0;
    
    return self;
}
-(NSInteger) calcSum {
    return _hits + (100 * _tagsMatched);
}
@end