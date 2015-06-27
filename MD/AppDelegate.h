
#import <UIKit/UIKit.h>
#import "NoteManager.h"
#import "DBManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong,nonatomic) NoteManager* theManager;
@property (strong, nonatomic) DBManager* dbManager;
@property (strong, nonatomic) UIWindow *window;

@end

