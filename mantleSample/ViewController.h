
#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController{
    
    FMDatabaseQueue*queue_fmdb;
    
}

@property (weak) IBOutlet NSTextField *inputTextFiled;

@property (strong) IBOutlet NSArrayController *arrayCon;


@end

