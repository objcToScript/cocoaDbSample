#import "clsFMDB.h"
#import "MTLFMDBAdapter.h"

@interface clsFMDB (query)

-(BOOL)_insertQuery:(NSString*)sql db_queue:(FMDatabase*)db_temp;

-(BOOL)_updateQuery:(NSString*)sql;

-(BOOL)_updateQuery:(NSString*)sql db_queue:(FMDatabase*)db_queue;

-(BOOL)_deleteQuery:(NSString*)sql;

-(BOOL)_deleteQuery:(NSString*)sql db_queue:(FMDatabase*)db_queue;

-(BOOL)_insert:(id)model db_queue:(FMDatabase*)db_temp;

-(BOOL)_insert:(id)model;

// auto incrementを使わない時
-(BOOL)_insert_with_Primary:(id)model;

-(BOOL)_insert_with_Primary:(id)model db_queue:(FMDatabase*)db_temp;

-(BOOL)_update:(id)model db_queue:(FMDatabase*)db_temp;

-(BOOL)_update:(id)model;

-(BOOL)_delete:(id)model;

-(BOOL)_delete:(id)model db_queue:(FMDatabase*)db_temp;

-(NSMutableArray*)_select:(NSString*)sql className:(id)className;

-(id)_selectOne:(NSString*)sql className:(id)className;

-(NSMutableArray*)_selectDic:(NSString*)sql db_queue:(FMDatabase*)db_temp;

-(NSMutableArray*)_selectDic:(NSString*)sql;

-(NSMutableDictionary*)_selectOneDic:(NSString*)sql;

-(NSMutableDictionary*)_selectOneDic:(NSString*)sql db_queue:(FMDatabase*)db_temp;

-(NSMutableArray*)_select:(NSString*)sql className:(id)className db_queue:(FMDatabase*)db_temp;

-(id)_selectOne:(NSString*)sql className:(id)className db_queue:(FMDatabase*)db_temp;

@end
