#import "clsFMDB.h"

@interface clsFMDB (utility)

-(bool)_dropTable:(NSString*)tableName;

-(BOOL)_tableExists:(NSString*)tableName;

-(NSMutableArray*)_getTableName_all;

- (NSMutableArray*)_getTableSchema:(NSString*)tableName;

- (NSString*)_getTableSchema_PRIMARY_KEY:(NSString*)tableName;

- (BOOL)_columnExists:(NSString*)columnName inTableWithName:(NSString*)tableName;

- (BOOL)_columnExists:(NSString*)tableName columnName:(NSString*)columnName __attribute__ ((deprecated));

+(NSString*)_sqlEscapeStr:(NSString*)sql;

@end
