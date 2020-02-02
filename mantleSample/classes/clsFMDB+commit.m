#import "clsFMDB+commit.h"

@implementation clsFMDB (commit)

-(void)_alertError:(NSError*)error{
    if(error != nil){
        NSLog(@"エラー %@",  error.description   );
        self.errorMes = error.description;
    }
}

-(void)_close{
    [db close];
}
-(void)_open{
    [db open];
}

-(void)_beginTransaction{
    [db beginTransaction];
}
-(void)_commit{
    [db commit];
}

-(void)_rollback{
    [db rollback];
}

-(void)_vacuum{
    [db executeUpdate: @"VACUUM;" ];
}
-(int)_lastId{
    long long int lastId = [db lastInsertRowId];
    return [[NSNumber numberWithLongLong:lastId] intValue];
}
-(void)_setOnForeignKey{
    [db executeUpdate:@"PRAGMA foreign_keys = ON;"];
}

-(void)_setOffForeignKey{
    [db executeUpdate:@"PRAGMA foreign_keys = OFF;"];
}

-(void)_end{
    [db executeUpdate:@"END;"];
}

-(void)_setCacheSize:(int32_t)mega {
    NSString *sql = [NSString stringWithFormat:@"PRAGMA cache_size = %d;", 1000 * mega ];
    [db executeUpdate:sql];
}

/*
-(int)_count:(NSString*)sql{
    
    sql = [sql stringByReplacingOccurrencesOfString:@"select" withString:@"SELECT"];
    sql = [sql stringByReplacingOccurrencesOfString:@"Select" withString:@"SELECT"];
    sql = [sql stringByReplacingOccurrencesOfString:@"From" withString:@"FROM"];
    sql = [sql stringByReplacingOccurrencesOfString:@"from" withString:@"FROM"];
    
    sql = [clsUtility _replacePatternOriginalStr_enNasi:sql pattern:@"SELECT(.*?)FROM" replaceText:@" COUNT(*) "];
    FMResultSet *s = [db executeQuery:sql];
    if ([s next]) {
        int totalCount = [s intForColumnIndex:0];
        return totalCount;
    }
    NSLog(@"  カウントエラー"     );
    
    return 0;
}
*/

@end
