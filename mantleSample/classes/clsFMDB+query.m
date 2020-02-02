#import "clsFMDB+query.h"

@implementation clsFMDB (query)

-(BOOL)_insertQuery:(NSString*)sql db_queue:(FMDatabase*)db_temp{
    
    NSError*error;
    
    BOOL result = [db_temp executeUpdate:sql withErrorAndBindings:&error];
    
    [self _alertError:error];
    
    return result;
}

-(BOOL)_updateQuery:(NSString*)sql{
    
    NSError*error;
    
    BOOL result = [db executeUpdate:sql withErrorAndBindings:&error];
    
    [self _alertError:error];
    
    return result;
}

-(BOOL)_updateQuery:(NSString*)sql db_queue:(FMDatabase*)db_queue{
    
    NSError*error;
    
    BOOL result = [db_queue executeUpdate:sql withErrorAndBindings:&error];
    
    [self _alertError:error];
    
    return result;
}


-(BOOL)_deleteQuery:(NSString*)sql{
    
    NSError*error;
    
    BOOL result = [db executeUpdate:sql withErrorAndBindings:&error];
    
    [self _alertError:error];
    
    return result;
}

-(BOOL)_deleteQuery:(NSString*)sql db_queue:(FMDatabase*)db_queue{
    
    NSError*error;
    
    BOOL result = [db_queue executeUpdate:sql withErrorAndBindings:&error];
    
    [self _alertError:error];
    
    return result;
}

-(BOOL)_insert:(id)model db_queue:(FMDatabase*)db_temp{
    if(model == nil){
        return NO;
    }
    
    [model _deleteNil];
    
    NSString *stmt = [MTLFMDBAdapter insertStatementForModelWithOutPrimaryKey:model];
    
    NSArray *params = [MTLFMDBAdapter columnValuesWithOutPrimaryKey:model];
    
    NSError*error;
    
    BOOL result = [db_temp executeUpdate:stmt values:params error:&error];
    
    [self _alertError:error];
    
    return result;
}

-(BOOL)_insert:(id)model{
    if(model == nil){
        return NO;
    }
    
    [((MTLModel_Common*)model) _deleteNil];
    
    NSString *stmt = [MTLFMDBAdapter insertStatementForModelWithOutPrimaryKey:model];
    
    NSArray *params = [MTLFMDBAdapter columnValuesWithOutPrimaryKey:model];
    
    NSError*error;
    
    BOOL result = [db executeUpdate:stmt values:params error:&error];
    
    [self _alertError:error];
    
    return result;
}

// auto incrementを使わない時
-(BOOL)_insert_with_Primary:(id)model{
    if(model == nil){
        return NO;
    }
    
    [((MTLModel_Common*)model) _deleteNil];
    
    NSString *stmt = [MTLFMDBAdapter insertStatementForModel:model];
    
    NSArray *params = [MTLFMDBAdapter columnValues:model];
    
    NSError*error;
    
    BOOL result = [db executeUpdate:stmt values:params error:&error];
    
    [self _alertError:error];
    
    return result;
}


-(BOOL)_insert_with_Primary:(id)model db_queue:(FMDatabase*)db_temp{
    if(model == nil){
        return NO;
    }
    
    [((MTLModel_Common*)model) _deleteNil];
    
    NSString *stmt = [MTLFMDBAdapter insertStatementForModel:model];
    
    NSArray *params = [MTLFMDBAdapter columnValues:model];
    
    NSError*error;
    
    BOOL result = [db_temp executeUpdate:stmt values:params error:&error];
    
    [self _alertError:error];
    
    return result;
}


-(BOOL)_update:(id)model db_queue:(FMDatabase*)db_temp{
    if(model == nil){
        return NO;
    }
    
    [model _deleteNil];
    
    NSString *stmt = [MTLFMDBAdapter updateStatementForModel:model];
    
    NSArray *params = [MTLFMDBAdapter columnValues:model];
    
    NSArray *primaryArray = [MTLFMDBAdapter primaryKeysValues:model];
    
    NSArray *newParams = [params arrayByAddingObjectsFromArray:primaryArray];
    
    NSError*error;
    //ここでスキーマも一緒にいれる jsonで 必要なキーはparamsでかき出してくれるので
    //paramsだしてそのあとでここでスキーマから mybindを生成してもいいそれを引数でもいい
    BOOL result = [db_temp executeUpdate:stmt values:newParams error:&error];
    
    [self _alertError:error];
    
    return result;
}


-(BOOL)_update:(id)model{
    if(model == nil){
        return NO;
    }
    
    [((MTLModel_Common*)model) _deleteNil];
    
    NSString *stmt = [MTLFMDBAdapter updateStatementForModel:model];
    //update pch_child set delFlag = ?, effective = ?, filePath = ?, name = ?, pch_child_id = ?, pch_id = ? where pch_child_id = ?
    NSArray *params = [MTLFMDBAdapter columnValues:model];
    // 値が順番
    NSArray *primaryArray = [MTLFMDBAdapter primaryKeysValues:model];
    //プライマリーの値
    NSArray *newParams = [params arrayByAddingObjectsFromArray:primaryArray];
    
    
    NSError*error;
    
    BOOL result = [db executeUpdate:stmt values:newParams error:&error];
    
    [self _alertError:error];
    
    return result;
}



-(BOOL)_delete:(id)model{
    if(model == nil){
        return NO;
    }
    
    [((MTLModel_Common*)model) _deleteNil];
    
    NSString *stmt = [MTLFMDBAdapter deleteStatementForModel:model];
    
    NSArray *primaryArray = [MTLFMDBAdapter primaryKeysValues:model];
    
    NSError*error;
    
    BOOL result = [db executeUpdate:stmt values:primaryArray error:&error];
    
    [self _alertError:error];
    
    return result;
}

-(BOOL)_delete:(id)model db_queue:(FMDatabase*)db_temp{
    
    [((MTLModel_Common*)model) _deleteNil];
    
    NSString *stmt = [MTLFMDBAdapter deleteStatementForModel:model];
    
    NSArray *primaryArray = [MTLFMDBAdapter primaryKeysValues:model];
    
    NSError*error;
    
    BOOL result = [db_temp executeUpdate:stmt values:primaryArray error:&error];
    
    [self _alertError:error];
    
    return result;
    
}


-(NSMutableArray*)_select:(NSString*)sql className:(id)className{
    
    NSError *error = nil;
    FMResultSet *resultSet = [db executeQuery:sql];
    NSMutableArray*array = [NSMutableArray new];
    while ([resultSet next]) {
        id resultClassModel = [MTLFMDBAdapter modelOfClass:className fromFMResultSet:resultSet error:&error];
        if(error != nil){
            NSLog(@"  %@",  error.description );
        }else{
            [array addObject:resultClassModel];
        }
    }
    return array;
}

-(id)_selectOne:(NSString*)sql className:(id)className{
    NSError *error = nil;
    FMResultSet *resultSet = [db executeQuery:sql];
    if ([resultSet next]) {
        id resultClassModel = [MTLFMDBAdapter modelOfClass:className fromFMResultSet:resultSet error:&error];
        if(error != nil){
            NSLog(@"  %@",  error.description );
        }else{
            return resultClassModel;
        }
    }
    return nil;
}


-(NSMutableArray*)_selectDic:(NSString*)sql{
    NSError *error = nil;
    FMResultSet *resultSet = [db executeQuery:sql];
    NSMutableArray*array = [NSMutableArray new];
    while ([resultSet next]) {
        if(error != nil){
            NSLog(@"  %@",  error.description );
        }else{
            [array addObject:[[resultSet resultDictionary]mutableCopy]];
        }
    }
    return array;
}

-(NSMutableDictionary*)_selectOneDic:(NSString*)sql {
    NSError *error = nil;
    FMResultSet *resultSet = [db executeQuery:sql];
    if ([resultSet next]) {
        if(error != nil){
            NSLog(@"  %@",  error.description );
        }else{
            return [[resultSet resultDictionary] mutableCopy];
        }
    }
    return nil;
}

-(NSMutableDictionary*)_selectOneDic:(NSString*)sql db_queue:(FMDatabase*)db_temp {
    NSError *error = nil;
    FMResultSet *resultSet = [db_temp executeQuery:sql];
    if ([resultSet next]) {
        if(error != nil){
            NSLog(@"  %@",  error.description );
        }else{
            return [[resultSet resultDictionary] mutableCopy];
        }
    }
    return nil;
}

-(NSMutableArray*)_selectDic:(NSString*)sql db_queue:(FMDatabase*)db_temp {
    NSError *error = nil;
    FMResultSet *resultSet = [db executeQuery:sql];
    NSMutableArray*array = [NSMutableArray new];
    if ([resultSet next]) {
        if(error != nil){
            NSLog(@"  %@",  error.description );
        }else{
            [array addObject:[[resultSet resultDictionary]mutableCopy]];
        }
    }
    return array;
}

-(NSMutableArray*)_select:(NSString*)sql className:(id)className db_queue:(FMDatabase*)db_temp {
    
    NSError *error = nil;
    FMResultSet *resultSet = [db_temp executeQuery:sql];
    NSMutableArray*array = [NSMutableArray new];
    while ([resultSet next]) {
        id resultClassModel = [MTLFMDBAdapter modelOfClass:className fromFMResultSet:resultSet error:&error];
        if(error != nil){
            NSLog(@"  %@",  error.description );
        }else{
            [array addObject:resultClassModel];
        }
    }
    return array;
}

-(id)_selectOne:(NSString*)sql className:(id)className db_queue:(FMDatabase*)db_temp {
    
    NSError *error = nil;
    FMResultSet *resultSet = [db_temp executeQuery:sql];
    while ([resultSet next]) {
        id resultClassModel = [MTLFMDBAdapter modelOfClass:className fromFMResultSet:resultSet error:&error];
        if(error != nil){
            NSLog(@"  %@",  error.description );
        }else{
            return resultClassModel;
        }
    }
    return nil;
}


@end
