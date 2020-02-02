#import "clsFMDB+utility.h"

@implementation clsFMDB (utility)

-(bool)_dropTable:(NSString*)tableName{

   bool result = [db executeUpdate:[NSString stringWithFormat:@"drop table if exists %@",tableName]];
    
   return result;
    
}

-(BOOL)_tableExists:(NSString*)tableName {
    
    tableName = [tableName lowercaseString];
    
    NSString*sql = [NSString stringWithFormat:@"select [sql] from sqlite_master where [type] = 'table' and lower(name) = %@",tableName];
    FMResultSet*result = [db executeQuery:sql];
    while([result next]) {
        return YES;
    }
    return NO;
}

-(NSMutableArray*)_getTableName_all{
    NSString*sql = [NSString stringWithFormat:@"SELECT tbl_name as tableName FROM sqlite_master Where type = 'table' and tableName not in ('sqlite_sequence') and tableName NOT LIKE '%old_%';"];
    NSMutableArray* reuslt = [self _selectDic:sql];
    return reuslt;
}

- (NSMutableArray*)_getTableSchema:(NSString*)tableName {
    
    NSString*sql = [NSString stringWithFormat:@"PRAGMA table_info('%@');",tableName];
    NSMutableArray* reuslt =  [self _selectDic:sql];
    
    return reuslt;
}

- (NSString*)_getTableSchema_PRIMARY_KEY:(NSString*)tableName {
    
    NSString*sql = [NSString stringWithFormat:@"PRAGMA table_info('%@');",tableName];
    NSMutableArray* reuslt =  [self _selectDic:sql];
    
    for(NSMutableDictionary*dic in reuslt){
        if([[dic objectForKey:@"pk"] boolValue]){
            return [dic objectForKey:@"name"];
        }
    }
    return @"";
}

- (BOOL)_columnExists:(NSString*)columnName inTableWithName:(NSString*)tableName {
    
    BOOL returnBool = NO;
    
    tableName  = [tableName lowercaseString];
    columnName = [columnName lowercaseString];
    
    NSMutableArray* result = [self _getTableSchema:tableName];
    
    //check if column is present in table schema
    for(NSMutableDictionary*dic in result){
        if ([[[dic objectForKey:@"name"] lowercaseString] isEqualToString:columnName]) {
            returnBool = YES;
            break;
        }
    }
    
    return returnBool;
}

- (BOOL)_columnExists:(NSString*)tableName columnName:(NSString*)columnName __attribute__ ((deprecated)) {
    return [self _columnExists:columnName inTableWithName:tableName];
}

+(NSString*)_sqlEscapeStr:(NSString*)sql{
    
    if(sql != nil && ![sql isEqual:@""]){
        
        if ([sql isKindOfClass:[NSNumber class]]) {
            sql = [NSString stringWithFormat:@"%@", (NSNumber*)sql];
        }
        
        return  [sql stringByReplacingOccurrencesOfString:@"'" withString:@"’"];
    }
    return @"";
}


@end
