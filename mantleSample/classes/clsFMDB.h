#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "MTLModel_Common.h"


static NSString*dbPath_static;
static BOOL developMode_static;
static NSString*dbName_static;

@interface clsFMDB : NSObject{
    
    FMDatabase *db;    
    NSString* errorMes;
    NSString* dbDocumentPath;
    NSString* privateDocumentPath;
    
    NSDateFormatter*_dateFormat;
}

@property (strong, nonatomic) NSString* errorMes;
@property (strong, nonatomic) NSString* dbDocumentPath;


+(clsFMDB*)_sharedManager;

-(void)_initDbFile_MacOS:(NSString*)simulator_DbPath dbName:(NSString*)dbName developMode:(BOOL)developMode;

-(FMDatabase*)_getFMDB;
+(NSString*)_getDbName;
+(NSString*)_getDbPath;
+(BOOL)_getDevelopMode;


@end

#import "clsFMDB+utility.h"
#import "clsFMDB+utility2.h"
#import "clsFMDB+query.h"
#import "clsFMDB+commit.h"

