#import "clsFMDB.h"

@interface clsFMDB (utility2)

#pragma mark ドキュメントパスを取得する
-(NSString*)_getDocumentPath:(NSString*)dbName;
#pragma mark バンドルパスを取得する
-(NSString*)_getBundlePath:(NSString*)dbName;
#pragma mark 現在の時刻を取得
+(NSString*)_getNow_DateTime;
#pragma mark シュミレーターかどうか
- (BOOL)_isSimulator;
#pragma mark シュミレーターかどうか
+(BOOL)_isSimulator;

@end
