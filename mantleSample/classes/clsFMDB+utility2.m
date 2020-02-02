#import "clsFMDB+utility2.h"

@implementation clsFMDB (utility2)

#pragma mark ドキュメントパスを取得する
-(NSString*)_getDocumentPath:(NSString*)dbName{
    NSArray* appPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString* dir  = [appPath objectAtIndex:0];
    NSString*  dbDocumentPath_t = [NSString stringWithFormat:@"%@/%@", dir, dbName];
    return dbDocumentPath_t;
}

#pragma mark バンドルパスを取得する
-(NSString*)_getBundlePath:(NSString*)dbName{
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle bundlePath];
    
    return path;
}

#pragma mark 現在の時刻を取得
+(NSString*)_getNow_DateTime{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString=[dateFormat stringFromDate:[NSDate dateWithTimeIntervalSinceNow:[[NSTimeZone systemTimeZone] secondsFromGMT]]];
    return dateString;
}

#pragma mark シュミレーターかどうか
- (BOOL)_isSimulator{
    
#if TARGET_OS_IOS
    if(TARGET_OS_SIMULATOR != 0){
        return  YES;
    }
#endif
    
    return NO;
}

#pragma mark シュミレーターかどうか
+(BOOL)_isSimulator{
    
#if TARGET_OS_IOS
    
    if(TARGET_OS_SIMULATOR != 0){
        return  YES;
    }
    
#endif
    
    
    return NO;
}



@end
