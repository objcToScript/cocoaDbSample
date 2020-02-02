#import "MTLFMDBAdapter+utility.h"


@implementation MTLFMDBAdapter (utility)

+(NSArray*)_getYoyakuArray{
    
    if(yoyakuArray != nil){
        return yoyakuArray;
    }

    yoyakuArray = @[@"ABORT",@"ACTION",@"ADD",@"AFTER",@"ALL",@"ALTER",@"ANALYZE",@"AND",@"AS",@"ASC",@"ATTACH",@"AUTOINCREMENT",@"BEFORE",@"BEGIN",@"BETWEEN",@"BY",@"CASCADE",@"CASE",@"CAST",@"CHECK",@"COLLATE",@"COLUMN",@"COMMIT",@"CONFLICT",@"CONSTRAINT",@"CREATE",@"CROSS",@"CURRENT",@"CURRENT_DATE",@"CURRENT_TIME",@"CURRENT_TIMESTAMP",@"DATABASE",@"DEFAULT",@"DEFERRABLE",@"DEFERRED",@"DELETE",@"DESC",@"DETACH",@"DISTINCT",@"DO",@"DROP",@"EACH",@"ELSE",@"END",@"ESCAPE",@"EXCEPT",@"EXCLUSIVE",@"EXISTS",@"EXPLAIN",@"FAIL",@"FILTER",@"FOLLOWING",@"FOR",@"FOREIGN",@"FROM",@"FULL",@"GLOB",@"GROUP",@"HAVING",@"IF",@"IGNORE",@"IMMEDIATE",@"IN",@"INDEX",@"INDEXED",@"INITIALLY",@"INNER",@"INSERT",@"INSTEAD",@"INTERSECT",@"INTO",@"IS",@"ISNULL",@"JOIN",@"KEY",@"LEFT",@"LIKE",@"LIMIT",@"MATCH",@"NATURAL",@"NO",@"NOT",@"NOTHING",@"NOTNULL",@"NULL",@"OF",@"OFFSET",@"ON",@"OR",@"ORDER",@"OUTER",@"OVER",@"PARTITION",@"PLAN",@"PRAGMA",@"PRECEDING",@"PRIMARY",@"QUERY",@"RAISE",@"RANGE",@"RECURSIVE",@"REFERENCES",@"REGEXP",@"REINDEX",@"RELEASE",@"RENAME",@"REPLACE",@"RESTRICT",@"RIGHT",@"ROLLBACK",@"ROW",@"ROWS",@"SAVEPOINT",@"SELECT",@"SET",@"TABLE",@"TEMP",@"TEMPORARY",@"THEN",@"TO",@"TRANSACTION",@"TRIGGER",@"UNBOUNDED",@"UNION",@"UNIQUE",@"UPDATE",@"USING",@"VACUUM",@"VALUES",@"VIEW",@"VIRTUAL",@"WHEN",@"WHERE",@"WINDOW",@"WITH",@"WITHOUT"];

    return yoyakuArray;
}


+(NSString*)_isYoyakugo:(NSString*)columnName{
    
    NSString*columnUpper = [columnName uppercaseString];

    if([[self _getYoyakuArray] containsObject:columnUpper]){
        columnName = [NSString stringWithFormat:@"\"%@\"",columnName];
        return columnName;
    }
    
    return columnName;
    
}



@end
