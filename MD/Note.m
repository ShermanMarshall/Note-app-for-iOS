
#import <Foundation/Foundation.h>
#import "Note.h"

@interface Note ()

@end

@implementation Note

-(instancetype) init {
    self = [super init];
    self.title = @"New Note";
    self.data = @"";
    self.tags = [NSMutableArray array];
    self.newData = NO;
    
    
    return self;
}

-(void) addTag:(NSString *)tag {
    [_tags addObject: tag];
}

-(NSString*) returnConcatenatedTags {
    NSString* list;
    NSInteger x = 0;
    for (NSString* tag in _tags) {
        if (list)
            list = [NSString stringWithFormat: @"%@, %@", list, tag];
        else
            list = [NSString stringWithString: tag];
       
        x++;
        if ((x !=0) &&(x % 10 == 0))
            [list stringByAppendingString: @"\n"];
    }
    
    if (list != nil)
        return list;
    
    return @"";
}

-(NSMutableArray*) parseTags:(char *)tagString {
    NSString* composite = [[NSString alloc] initWithUTF8String: tagString];
    return (NSMutableArray* )[composite componentsSeparatedByString: @", "];
}
@end