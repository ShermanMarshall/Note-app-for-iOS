
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "WebViewController.h"

@interface WebViewController ()

@property (strong, nonatomic) IBOutlet UIWebView *webViewer;
@property (strong, nonatomic) IBOutlet UIButton *go;
@property (strong, nonatomic) IBOutlet UITextField *searchField;


@end

@implementation WebViewController

-(void) viewDidLoad {
    [super viewDidLoad];
}

-(IBAction) name:(id)sender{
    NSString* string = _searchField.text;
    NSURL* url;
    
    if ([string containsString: @"http://www"])
        url = [NSURL URLWithString: string];
    else
        url = [NSURL URLWithString: [NSString stringWithFormat: @"http://www.%@", string]];
    
    [_webViewer loadRequest: [NSURLRequest requestWithURL: url]];
}
@end