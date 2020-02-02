
#import "ViewController.h"

static NSMutableArray*db_testTableArray;

static NSString*dbFilePath_static = @"/Users/ita/COCOCA_2/mantleSample/mantleSample/mantleSample.db3";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _init_db];
    
    [queue_fmdb inDatabase:^(FMDatabase *db_queue){
        
        [self _select_testTable:db_queue];
        
        [self.arrayCon _resetIndex];
    }];

}

-(void)_init_db{
    
    queue_fmdb = [FMDatabaseQueue databaseQueueWithPath:dbFilePath_static];
    
}

- (IBAction)selectedTableView:(NSTableView*)sender {
    
    [self.arrayCon _setSelectIndex:[sender _getRowIndex]];
    
}

-(NSMutableArray*)_select_testTable:(FMDatabase *)db_queue{
    
    NSString*sql = [NSString stringWithFormat:@"Select * from testTable order by test_id desc ;"];
    
    db_testTableArray = [[clsFMDB _sharedManager] _select:sql className:[db_testTable class] db_queue:db_queue];
    
    self.arrayCon.content = db_testTableArray;
    
    return db_testTableArray;
}

- (IBAction)komokuNewBtn_down:(id)sender {
    
    [self.arrayCon _resetIndex];    
    
}

-(IBAction)_insert_testTable:(id)sender{
    
    db_testTable*db_testTable1 = [self.arrayCon _getDataRow];
    
    [queue_fmdb inTransaction:^(FMDatabase *db_queue, BOOL *rollback) {
        
        NSString*sql2 = [NSString stringWithFormat:@"Select * from testTable Where test_id = '%ld' ;" , db_testTable1.test_id ];
        
        id dic = [[clsFMDB _sharedManager] _selectOneDic:sql2 db_queue:db_queue];
        
        if(dic == nil){
            
            db_testTable*db_testTable1 = [db_testTable new];

            db_testTable1.name = self.inputTextFiled.stringValue;
            db_testTable1.date = [NSDate new];
            db_testTable1.deleteFlag = [NSNumber numberWithInt:0] ;
            
            [[clsFMDB _sharedManager] _insert:db_testTable1 db_queue:db_queue];
        }
        
        [self _select_testTable :db_queue];
        
        [self.arrayCon _resetIndex];
        
    }];
    
}

-(IBAction)_update_testTable:(id)sender{
    
    [queue_fmdb inTransaction:^(FMDatabase *db_queue, BOOL *rollback) {
        
        for(db_testTable*db_testTable1 in db_testTableArray){
            [[clsFMDB _sharedManager] _update:db_testTable1 db_queue:db_queue];
        }
        [self _select_testTable :db_queue];
    }];
    
}

-(IBAction)_delete_testTable:(id)sender{
    
    [queue_fmdb inTransaction:^(FMDatabase *db_queue, BOOL *rollback) {
        
        for(db_testTable*db_testTable1 in db_testTableArray){
            if([db_testTable1.deleteFlag boolValue]){
                [[clsFMDB _sharedManager] _delete:db_testTable1 db_queue:db_queue];
            }
        }        
        [self _select_testTable :db_queue];
        
        [self.arrayCon _resetIndex];
    }];
    
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    
    
}

@end
