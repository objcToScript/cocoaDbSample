
#import "clsFMDB.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

//import add

//import end"

#pragma clang diagnostic pop

@implementation clsFMDB

@synthesize errorMes;
@synthesize dbDocumentPath = _dbDocumentPath;

static clsFMDB* clsFMDB_static = nil;
static clsFMDB* clsFMDB_2_static = nil;
static clsFMDB* clsFMDB_3_static = nil;

+(clsFMDB*)_sharedManager{
    @synchronized(self){
        if (!clsFMDB_static) {
            clsFMDB_static = [clsFMDB new];
        }
        return clsFMDB_static;
    }    
    return nil;
}




-(id)init{
    
    self = [super init];
    
    
    return self;
}

-(void)_initDbFile_MacOS:(NSString*)dbPath1
              dbName:(NSString*)dbName
         developMode:(BOOL)developMode{
    
    NSString*dbDocumentPath = @"";
    if (dbPath1 != nil && ![dbPath1 isEqual:@""]) {
        dbDocumentPath = dbPath1;
    }else{
       dbDocumentPath = [self _getDocumentPath:dbName];
    }

    dbPath_static = dbDocumentPath;
    dbName_static = dbName;

    if(![self _isFile:dbDocumentPath]){
        NSLog(@"エラー dbファイルがない  %@" , dbDocumentPath );
        return;
    }

    db = [FMDatabase databaseWithPath:dbDocumentPath];
    
    BOOL reuslt = [db open];
    
    if(!reuslt){
        NSLog(@"エラー db接続に失敗しました。"  );
        return;
    }
    
    [self _setOnForeignKey];
    NSLog(@"db接続しました。"  );
}


-(FMDatabase*)_getFMDB{    
    return db;
}

+(NSString*)_getDbName{
    return dbName_static;
}

+(NSString*)_getDbPath{
    return dbPath_static;
}

+(BOOL)_getDevelopMode{
    return developMode_static;
}

// ファイルがあるかどうか
- (BOOL)_isFile:(NSString*)filePath
{
    BOOL isDirectory = NO;
    BOOL flag = NO;
    @try {
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory]) {
            if (!isDirectory) {
                return YES;
            }
        }
    } @catch (NSException* exception) {
        NSLog(@"%@", exception.description);
        //   //
    }
    return flag;
}

@end
