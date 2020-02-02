
#import "clsFile.h"
//#import "clsNSString.h"

@implementation clsFile {
  @private
}

+(NSString*)_getSearchFileNamePath_One:(NSString*)dirPath fileName:(NSString*)fileName filter:(NSString*)filter{
    
    NSMutableArray*array = [self _getSearchFileNamePath:dirPath fileName:fileName filter:filter];
    
    if([array count] > 0){
        return [array objectAtIndex:0];
    }
    
    return @"";
}

+(NSMutableArray*)_getSearchFileNamePath:(NSString*)dirPath fileName:(NSString*)fileName filter:(NSString*)filter{
    
     NSMutableArray*fileNamePathArray = [NSMutableArray new];
    
    NSArray*array = [self _getFileList_deep:dirPath filter:@""];

    for(NSString*filePath in array){
       if(![clsFile _isFile:filePath]){
            continue;
       }
        
       NSString*fileName_get = [filePath _getFileName_fromPath];
        if([fileName_get isEqual:fileName]){
            [fileNamePathArray addObject:filePath];
        }
    }

    return fileNamePathArray;
}

// ファイル移動
+ (BOOL)_moveFile:(NSString*)fromPath toPath:(NSString*)toPath
{
    NSError* error;
    BOOL isDirectory = NO;
    BOOL result = NO;

    @try {

        if ([[NSFileManager defaultManager] fileExistsAtPath:fromPath isDirectory:&isDirectory]) {
            if (!isDirectory) {
                
                if(![self _isFile:fromPath]){
                   return NO;
                }
                
                if([self _isFile:toPath]){
                    [self _deleteFile:toPath];
                }
                
                result = [[NSFileManager defaultManager] moveItemAtPath:fromPath toPath:toPath error:&error];

                if (error != nil) {
                    return NO;
                }

                return result;
            }
        }

    } @catch (NSException* exception) {
        NSLog(@"%@", exception.description);
    }
    return result;
}

+ (NSArray*)_getCategoryFileList_deep:(NSString*)filePath
{

    NSString* fileName;
    if ([filePath _indexOf:@"+"] != -1) {
        fileName = [filePath _getFileName_NoPlus_fromPath];
    } else {
        fileName = [filePath _getFileName_fromPath];
    }

    NSString* dirPath = [filePath _getDirPath_fromPath];

    NSArray* files = [self _getFileList_deep:dirPath filter:fileName];

    return files;
}

/*
 NSArray
 NSDictionary
 NSString
 NSDate
 NSNumber
 NSData
 NSURL
 NSView
 NSViewController
 */

+ (id)_loadObject:(NSString*)filePath
{

    NSArray* array = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    if (array) {
        return array;
    }
    return nil;
}

+ (BOOL)_saveObject:(id)array filePath:(NSString*)filePath
{

    NSError*error = nil; 
    
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:array requiringSecureCoding:YES error:&error];
    
    
    if (data) {
        NSLog(@"%@", @"データの保存に成功しました。");
        return YES;
    }

    return NO;
}

//変更日付を取得
+ (NSDate*)_getModificationDate:(NSString*)filePath
{

    NSFileHandle* fileHandle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    if (!fileHandle) {
        //NSLog(@"ファイルがありません．");
        return nil;
    }

    NSFileManager* fm = [NSFileManager defaultManager];
    NSDictionary* attribute = [fm attributesOfItemAtPath:filePath error:nil];
    NSDate* modificationDate = [attribute objectForKey:NSFileModificationDate];

    return modificationDate;
}

//ファイル情報を取得
+ (NSDictionary*)_getFileInfo:(NSString*)filePath
{

    NSFileHandle* fileHandle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    if (!fileHandle) {
        //NSLog(@"ファイルがありません．");
        return nil;
    }

    NSFileManager* fm = [NSFileManager defaultManager];
    NSDictionary* attribute = [fm attributesOfItemAtPath:filePath error:nil];
    //NSDate *creationDate = [attribute objectForKey:NSFileCreationDate];
    //NSDate *modificationDate = [attribute objectForKey:NSFileModificationDate];
    //NSNumber *fileSize = [attribute objectForKey:NSFileSize];
    //NSFileTypeDirectory

    return attribute;
}

// フォルダーサイズ
+ (unsigned long long int)_folderSize:(NSString*)folderPath
{
    NSArray* filesArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:folderPath error:nil];
    NSEnumerator* filesEnumerator = [filesArray objectEnumerator];
    NSString* fileName;
    unsigned long long int fileSize = 0;

    while (fileName = [filesEnumerator nextObject]) {
        NSDictionary* fileDictionary = [[NSFileManager defaultManager]
            attributesOfItemAtPath:[folderPath stringByAppendingPathComponent:fileName]
                             error:nil];
        fileSize += [fileDictionary fileSize];
    }

    return fileSize;
}

// ファイル読み込み配列として返す
+ (NSArray*)_loadArrayLine:(NSString*)filePath
{
    NSString* text = [self _loadText:filePath];
    NSArray* array = [text componentsSeparatedByString:@"\n"];
    return array;
}

// データ読み込み
- (NSData*)_loadData:(NSString*)filePath
{

    @try {

        NSFileHandle* fileHandle = [NSFileHandle fileHandleForReadingAtPath:filePath];
        if (!fileHandle) {
            NSLog(@"ファイルがありません．");
            return nil;
        }

        NSData* data = [fileHandle readDataToEndOfFile];

        return data;

    } @catch (NSException* exception) {
        NSLog(@"%@", exception.description);
        //  //
    }
    return nil;
}

// データ読み込み
+ (NSData*)_loadData:(NSString*)filePath
{

    @try {

        NSFileHandle* fileHandle = [NSFileHandle fileHandleForReadingAtPath:filePath];
        if (!fileHandle) {
            NSLog(@"ファイルがありません．");
            return nil;
        }

        NSData* data = [NSData dataWithContentsOfFile:filePath];

        return data;

    } @catch (NSException* exception) {
        NSLog(@"%@", exception.description);
    }
    return nil;
}

+ (BOOL)_copyFile:(NSString*)motoFilePath toFilePath:(NSString*)toFilePath
{

    NSError* error;
    BOOL result = NO;
    @try {

        if (![self _isFile:motoFilePath]) {
            NSLog(@" 元のファイルがない");
            return NO;
        }
        
        if([clsFile _isFile:toFilePath]){
            [clsFile _deleteFile:toFilePath];
        }

        result = [[NSFileManager defaultManager] copyItemAtPath:motoFilePath
                                                         toPath:toFilePath
                                                          error:&error];

        if (!result) {
            if (error) {
                NSLog(@"  %@", error.description);
            }
        }

    } @catch (NSException* exception) {
        NSLog(@"%@", exception.description);
        //  //
    }
    return result;
}

// ファイル読み込み
- (NSString*)_loadText:(NSString*)filePath
{
    NSError* error;
    BOOL isDirectory = NO;
    NSString* text = @"";
    @try {

        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory]) {
            if (!isDirectory) {
                //主にテキストファイルだけになる
                text = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
                if (error) {
                    NSLog(@"  %@", error.description);
                }
                return text;
            }
        }

    } @catch (NSException* exception) {
        NSLog(@"%@", exception.description);
        // //
    }
    return text;
}

// ファイル読み込み
+ (NSString*)_loadBundleText:(NSString*)fileName
{
    NSString* bunndleFile = [clsFile _getBundlePath:fileName];
    return [clsFile _loadText:bunndleFile];
}

// ファイル読み込み
+ (NSString*)_loadText:(NSString*)filePath
{
    NSError* error;
    BOOL isDirectory = NO;
    NSString* text = @"";
    @try {

        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory]) {
            if (!isDirectory) {
                //主にテキストファイルだけになる
                text = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
                if (error) {
                    NSLog(@"  %@", error.description);
                }
                return text;
            }
        }

    } @catch (NSException* exception) {
        NSLog(@"%@", exception.description);
    }
    return text;
}

// NSAarry読み込み
+ (NSArray*)_loadArrayData:(NSString*)filePath
{

    @try {

        NSArray* items = nil;

        NSFileManager* fileManager = [NSFileManager defaultManager];
        BOOL success = [fileManager fileExistsAtPath:filePath];
        if (success) {
            items = [[NSArray alloc] initWithContentsOfFile:filePath];
        };

        return items;

    } @catch (NSException* exception) {
        NSLog(@"%@", exception.description);
        //    //
    }

    return nil;
}

// NSAarryのファイルに保存
+ (BOOL)_saveArrayData:(NSArray*)items filePath:(NSString*)filePath
{

    NSError* error;
    BOOL isDirectory = NO;
    BOOL result = NO;

    @try {

        NSArray* items_t = items;

        if ([items isKindOfClass:[NSMutableArray class]]) {
            items_t = [items copy];
        }

        NSString* dirPath = [filePath stringByDeletingLastPathComponent];

        //dirを作成
        if (![[NSFileManager defaultManager] fileExistsAtPath:dirPath isDirectory:&isDirectory]) {
            isDirectory = [[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:&error];
        }

        result = [items_t writeToFile:filePath atomically:YES];

        if (!result) {
            NSLog(@"ファイルの書き込みに失敗しました");
            if (error) {
                NSLog(@"  %@", error.description);
            }
        }

    } @catch (NSException* exception) {
        NSLog(@"%@", exception.description);
        //    //
    }

    return result;
}

// バイナリーファイルに保存
- (BOOL)_saveData:(NSData*)data filePath:(NSString*)filePath
{
    NSError* error;
    BOOL isDirectory = NO;
    BOOL result = NO;

    @try {

        NSString* dirPath = [filePath stringByDeletingLastPathComponent];

        //dirを作成
        if (![[NSFileManager defaultManager] fileExistsAtPath:dirPath isDirectory:&isDirectory]) {
            isDirectory = [[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:&error];
        }

        result = [data writeToFile:filePath atomically:YES];

        if (!result) {
            NSLog(@"データーの書き込みに失敗しました");
            if (error) {
                NSLog(@"  %@", error.description);
            }
        }

    } @catch (NSException* exception) {
        NSLog(@"%@", exception.description);
        //   //
    }

    return result;
}

+ (BOOL)_saveData:(NSData*)data filePath:(NSString*)filePath
{
    NSError* error;
    BOOL isDirectory = NO;
    BOOL result = NO;

    @try {

        NSString* dirPath = [filePath stringByDeletingLastPathComponent];

        //dirを作成
        if (![[NSFileManager defaultManager] fileExistsAtPath:dirPath isDirectory:&isDirectory]) {
            isDirectory = [[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:&error];
        }

        result = [data writeToFile:filePath atomically:YES];

        if (!result) {
            NSLog(@"データーの書き込みに失敗しました");
            if (error) {
                NSLog(@"  %@", error.description);
            }
        }

    } @catch (NSException* exception) {
        NSLog(@"%@", exception.description);
        //   //
    }

    return result;
}

// ファイルに保存
+ (BOOL)_save:(NSString*)text filePath:(NSString*)filePath
{
    NSError* error;
    BOOL isDirectory = NO;
    BOOL result = NO;

    @try {

        NSString* dirPath = [filePath stringByDeletingLastPathComponent];

        //dirを作成
        if (![[NSFileManager defaultManager] fileExistsAtPath:dirPath isDirectory:&isDirectory]) {
            isDirectory = [[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:&error];
        }

        result = [text writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];

        if (!result) {
            NSLog(@"ファイルの書き込みに失敗しました");
            if (error) {
                NSLog(@"  %@", error.description);
            }
        }

    } @catch (NSException* exception) {
        NSLog(@"%@", exception.description);
        //  //
    }

    return result;
}

//ファイルリネーム
+ (BOOL)_fileReName:(NSString*)filePath_old filePath_new:(NSString*)filePath_new
{

    if (![self _isFile:filePath_old]) {
        return NO;
    }

    NSError* error;

    BOOL result = [[NSFileManager defaultManager] moveItemAtPath:filePath_old toPath:filePath_new error:&error];
    if (result) {
        //NSLog(@"ファイル名の変更に成功：%@", filePath_new);
        return YES;
    } else {

        NSLog(@"  ファイル名変更失敗 %@ old %@ new %@", [filePath_new _getFileName_fromPath], filePath_old, filePath_new);
    }
    return NO;
}

// imageSage
// ファイルに追記書き込み
+ (void)_addSave:(NSString*)addText filePath:(NSString*)filePath
{
    @try {

        if (![self _isFile:filePath]) {
            [self _createTextFile:filePath];
        }

        NSString* text = [self _loadText:filePath];
        NSString* str = [text stringByAppendingString:addText];
        [self _save:str filePath:filePath];

    } @catch (NSException* exception) {
        NSLog(@"%@", exception.description);
    }
}

// ファイルに追記書き込み 改行
+ (void)_addSaveWithReturn:(NSString*)addText filePath:(NSString*)filePath
{
    @try {

        if (![self _isFile:filePath]) {
            [self _createTextFile:filePath];
        }

        NSString* text = [self _loadText:filePath];
        NSString* str = [text stringByAppendingString:@"\n"];
        str = [str stringByAppendingString:addText];
        [self _save:str filePath:filePath];

    } @catch (NSException* exception) {
        NSLog(@"%@", exception.description);
    }
}

+ (BOOL)_createTextFile:(NSString*)filePath
{
    BOOL result = [@"" writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:NULL];
    return result;
}
+ (BOOL)_createDataFile:(NSString*)filePath
{
    return [[NSFileManager defaultManager] createFileAtPath:filePath contents:[NSData data] attributes:nil];
}
// ファイル削除する
+ (BOOL)_deleteFile:(NSString*)filePath
{
    NSError* error;
    BOOL isDirectory = NO;
    BOOL flag = NO;
    @try {
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory]) {
            if (!isDirectory) {
                flag = [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
                if (error) {
                    NSLog(@"削除失敗  %@", error.description);
                }
                return flag;
            }
        }
    } @catch (NSException* exception) {
        NSLog(@"%@", exception.description);
    }
    return flag;
}

// ファイルがあるかどうか
+ (BOOL)_isFile:(NSString*)filePath
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

// バンドルファイルがあるかどうか
+ (BOOL)_isBundleFile:(NSString*)bundleFileName
{
    BOOL isDirectory = NO;
    BOOL flag = NO;
    @try {

        NSString* filePath = [clsFile _getBundlePath:bundleFileName];

        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory]) {
            if (!isDirectory) {
                return YES;
            }
        }
    } @catch (NSException* exception) {
        NSLog(@"%@", exception.description);
        //  self.errorMes = exception.description;
    }
    return flag;
}

// バンドルパス取得
+ (NSString*)_getCacheDirPath:(NSString*)filePath
{
    NSArray* paths =
        NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    if ([paths count] > 0) {
        return [NSString stringWithFormat:@"%@/%@", [paths objectAtIndex:0], filePath];

    } else {
        return @"";
    }
}

// Temporaryパス取得
+ (NSString*)_getTemporaryDirPath:(NSString*)filePath
{

    NSString* tempPath = NSTemporaryDirectory();

    return [NSString stringWithFormat:@"%@/%@", tempPath, filePath];

}

// バンドルパス取得
+ (NSString*)_getCacheDirPath
{

    NSArray* paths =
        NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    if ([paths count] > 0) {

        return [NSString stringWithFormat:@"%@", [paths objectAtIndex:0]];

    } else {
        return @"";
    }
}

// 一時ファイルパス取得
+ (NSString*)_getTempFilePath
{
    NSString* path = NSTemporaryDirectory();
    return path;
}

// リソースファイル読み込み
+ (NSString*)_loadResourceText:(NSString*)fileName
{
    NSString* bunndleFile = [clsFile _getResourcePath:fileName];
    return [clsFile _loadText:bunndleFile];
}

// documentファイル読み込み
+ (NSString*)_loadDocumentText:(NSString*)fileName
{
    NSString* bunndleFile = [clsFile _getDocumentPath:fileName];
    return [clsFile _loadText:bunndleFile];
}

// リソースパス取得
+ (NSString*)_getResourcePath:(NSString*)filePath
{
    return [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], filePath];
}

// APPの中exeパス取得
+ (NSString*)_getExeContentPath:(NSString*)filePath
{
    return [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] executablePath], filePath];
}

// APPと同じ階層のパスの取得
+ (NSString*)_getAppExePath:(NSString*)filePath
{

    NSString* path = [[NSBundle mainBundle] bundlePath];
    NSArray* splitArray = [path _split:@"/"];

    NSArray* array = [splitArray _slice:0 length:[splitArray count] - 1];

    NSString* splitPath = [array _join:@"/"];

    return [NSString stringWithFormat:@"%@/%@", splitPath, filePath];
}

// バンドルパス取得
+ (NSString*)_getBundlePath:(NSString*)filePath
{
    return [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] bundlePath], filePath];
}

+ (NSString*)_getBundlePath
{
    return [NSString stringWithFormat:@"%@/", [[NSBundle mainBundle] bundlePath]];
}

+ (NSString*)_getBundleDirPath
{
    return [NSString stringWithFormat:@"%@", [[[NSBundle mainBundle] bundlePath] _getDirPath_fromPath]];
}

+ (NSString*)_getBundleDirPath:(NSString*)filePath
{
    return [NSString stringWithFormat:@"%@/%@", [[[NSBundle mainBundle] bundlePath] _getDirPath_fromPath], filePath];
}

// ドキュメントパスを取得する
+ (NSString*)_getDocumentPath:(NSString*)filePathOrFileName
{
    NSArray* appPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* dir = [appPath objectAtIndex:0];
    NSString* dbDocumentPath_t = [NSString stringWithFormat:@"%@/%@", dir, filePathOrFileName];
    return dbDocumentPath_t;
}

// ドキュメントデイレクトリパスを取得する
+ (NSString*)_getDocumentDirPath
{
    NSArray* appPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* dir = [appPath objectAtIndex:0];
    return dir;
}

// ApplicationSupportDirectory パスとファイル名を取得する
+ (NSString*)_getApplicationSupportDirectory_FileNameOnly:(NSString*)filePathOrFileName
{

    NSFileManager* sharedFM = [NSFileManager defaultManager];

    NSArray* possibleURLs = [sharedFM URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask];
    NSURL* dir = [possibleURLs objectAtIndex:0];

    NSString* dirStr = [dir.absoluteString _replace:@"file://" replaceStr:@""];
    dirStr = [dirStr _replace:@"%20" replaceStr:@" "];

    NSString* appNameDir = [NSString stringWithFormat:@"%@%@", dirStr, [clsUtility _getAppName]];

    if (![clsDirectory _isDirectory:appNameDir]) {
        [clsDirectory _mkDirectory:appNameDir];
    }

    NSString* dbDocumentPath_t = [NSString stringWithFormat:@"%@%@", dirStr, filePathOrFileName];

    return dbDocumentPath_t;
}

// ApplicationSupportDirectory パスとファイル名を取得する
+ (NSString*)_getApplicationSupportDirectory_Path:(NSString*)appNameFolder filePathOrFileName:(NSString*)filePathOrFileName
{

    NSFileManager* sharedFM = [NSFileManager defaultManager];

    NSArray* possibleURLs = [sharedFM URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask];
    NSURL* dir = [possibleURLs objectAtIndex:0];

    NSString* dirStr = [dir.absoluteString _replace:@"file://" replaceStr:@""];
    dirStr = [dirStr _replace:@"%20" replaceStr:@" "];

    NSString* appNameDir = [NSString stringWithFormat:@"%@%@", dirStr, appNameFolder];

    if (![clsDirectory _isDirectory:appNameDir]) {
        [clsDirectory _mkDirectory:appNameDir];
    }

    NSString* dbDocumentPath_t = [NSString stringWithFormat:@"%@%@/%@", dirStr, appNameFolder, filePathOrFileName];

    return dbDocumentPath_t;
}

//ApplicationSupportDirectory パスを取得する
+ (NSString*)_getApplicationSupportDirectory_DirPath
{
    NSFileManager* sharedFM = [NSFileManager defaultManager];

    NSArray* possibleURLs = [sharedFM URLsForDirectory:NSApplicationSupportDirectory
                                             inDomains:NSUserDomainMask];
    NSURL* dir = [possibleURLs objectAtIndex:0];

    NSString* dirStr = [dir.absoluteString _replace:@"file://" replaceStr:@""];
    dirStr = [dirStr _replace:@"%20" replaceStr:@" "];

    dirStr = [NSString stringWithFormat:@"%@%@", dirStr, [clsUtility _getAppName]];

    return dirStr;
}

// ファイル一覧を取得する
+ (NSArray*)_getFileList:(NSString*)dirPath
{

    return [self _getFileList:dirPath filter:@""];
}

// ファイル一覧を取得する
+ (NSArray*)_getFileList:(NSString*)dirPath filter:(NSString*)filter
{

    dirPath = [dirPath _rTrim:@"/"];
    dirPath = [dirPath _addStr:@"/"];

    NSArray* fileLists = [[NSMutableArray alloc] init];
    NSMutableArray* fileLists_temp = [[NSMutableArray alloc] init];

    @try {
        // ファイルマネージャを作成
        NSFileManager* fileManager2 = [NSFileManager defaultManager];
        NSError* error;
        NSArray* Lists = [fileManager2 contentsOfDirectoryAtPath:dirPath
                                                           error:&error];

        if (Lists == nil) {

            NSLog(@"ファイル一覧がない");
            if (error != nil) {
                NSLog(@"%@ ", error.description);
            }

            return nil;
        }

        if ([filter _indexOf:@"|"] != -1 && filter != nil && ![filter isEqual:@""]) {
            NSArray* filterArray = [filter _split:@"|"];
            for (NSString* path in Lists) {
                for (NSString* filterStr in filterArray) {
                    if ([[path lastPathComponent] _indexOf:filterStr] != -1) {
                        [fileLists_temp addObject:[dirPath _addStr:path]];
                    }
                }
            }
            fileLists = [fileLists_temp copy];
        } else if (filter != nil && ![filter isEqual:@""]) {
            for (NSString* path in Lists) {
                if ([[path lastPathComponent] _indexOf:filter] != -1) {
                    [fileLists_temp addObject:[dirPath _addStr:path]];
                }
            }

            fileLists = [fileLists_temp copy];
        } else {

            for (NSString* path in Lists) {
                [fileLists_temp addObject:[dirPath _addStr:path]];
            }

            fileLists = [fileLists_temp copy];
        }

        if (error != nil) {
            NSLog(@"  %@", error.description);
        }

    } @catch (NSException* exception) {
        NSLog(@"%@", exception.description);
        //  //
    }

    return fileLists;
}

// ファイル一覧を取得する
+ (NSString*)_getFileList_one:(NSString*)dirPath filter:(NSString*)filter
{

    NSArray* array = [self _getFileList:dirPath filter:filter];

    if ([array count] > 0) {
        NSString* url = [array objectAtIndex:0];

        return url;
    }
    return @"";
}

// ファイル一覧を取得する 一つのみ
+ (NSString*)_getFileList_deep_one:(NSString*)dirPath filter:(NSString*)filter
{
    NSArray* array = [self _getFileList_deep:dirPath filter:filter];

    if ([array count] > 0) {
        return [array objectAtIndex:0];
    }
    return @"";
}

// ファイル一覧を取得する
+ (NSArray*)_getFileList_deep:(NSString*)dirPath filter:(NSString*)filter
{

    NSArray* fileLists = [[NSMutableArray alloc] init];

    @try {
        
        if([dirPath isEqual:@""]){
            NSMutableArray* fileLists_temp = [[NSMutableArray alloc] init];
            return fileLists_temp;            
        }

        NSDirectoryEnumerator* URLEnum = [[NSFileManager defaultManager] enumeratorAtURL:[NSURL fileURLWithPath:dirPath] includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles errorHandler:nil];

        NSMutableArray* fileLists_temp = [[NSMutableArray alloc] init];

        NSURL* filePath;

        if ([filter _indexOf:@"|"] != -1 &&
            filter != nil &&
            ![filter isEqual:@""]) {

            NSArray* filterArray = [filter _split:@"|"];
            while ((filePath = [URLEnum nextObject])) {

                NSString* fileName_only = [filePath.absoluteString pathExtension];
                for (NSString* filterStr in filterArray) {
                    NSString* filterStr_t = [filterStr _replace:@"." replaceStr:@""];
                    if ([fileName_only isEqual:filterStr_t]) {

                        NSString* filePath2 = [filePath.absoluteString _replace:@"file://" replaceStr:@""];
                        filePath2 = [filePath2 _replace:@"%20" replaceStr:@" "];
                        [fileLists_temp addObject:filePath2];

                        continue;
                    }
                }
            }
            fileLists = [fileLists_temp copy];

        } else if (filter != nil &&
                   ![filter isEqual:@""]) {

            filter = [filter _replace:@"." replaceStr:@""];

            while ((filePath = [URLEnum nextObject])) {

                NSString* fileName_only = [filePath.absoluteString pathExtension];
                if ([fileName_only isEqual:filter]) {

                    NSString* filePath2 = [filePath.absoluteString _replace:@"file://" replaceStr:@""];
                    filePath2 = [filePath2 _replace:@"%20" replaceStr:@" "];
                    [fileLists_temp addObject:filePath2];
                }
            }

            fileLists = [fileLists_temp copy];

        } else {
            while ((filePath = [URLEnum nextObject])) {

                NSString* filePath2 = [filePath.absoluteString _replace:@"file://" replaceStr:@""];
                filePath2 = [filePath2 _replace:@"%20" replaceStr:@" "];
                [fileLists_temp addObject:filePath2];
            }
            fileLists = [fileLists_temp copy];
        }

    } @catch (NSException* exception) {
        NSLog(@"%@", exception.description);
    }

    return fileLists;
}

/*
 NSFileCreationDate = "2013-02-21 16:40:55 +0000";
 NSFileExtendedAttributes = {
 "com.apple.TextEncoding" = <7574662d 383b3133
 34323137 393834>;
 };
 NSFileExtensionHidden = 0;
 NSFileGroupOwnerAccountID = 20;
 NSFileGroupOwnerAccountName = staff;
 NSFileModificationDate = "2013-02-21 16:40:55 +0000";
 NSFileOwnerAccountID = 501;
 NSFileOwnerAccountName = xxxx;
 NSFilePosixPermissions = 420;
 NSFileReferenceCount = 1;
 NSFileSize = 7;
 NSFileSystemFileNumber = 24420983;
 NSFileSystemNumber = 234881026;
 NSFileType = NSFileTypeRegular;
 }
 
 
 
 // 現在日付を文字列で取得する処理
 - (NSString *)getCurrentDateString {
 
 // 現在の日付を取得
 NSDate *currentDate = [NSDate dateWithTimeIntervalSinceNow:[[NSTimeZone systemTimeZone] secondsFromGMT]];
 // 日付フォーマットオブジェクトの生成
 NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
 // フォーマットを指定の日付フォーマットに設定
 [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss.SSS"];
 // 日付型の文字列を生成
 NSString *dateString = [dateFormatter stringFromDate:currentDate];
 
 return dateString;
 } 
 
 せっかくなんで、大体のフォーマットも書いておく。
 
 G：時代(AD)
 yy：西暦の下2桁(12)
 yyyy：西暦(2012)
 M：月(1～12)
 MM：月(01～12)
 MMM：月(1月)
 MMMM：月(1月)
 d：日(5)
 dd：日(05)
 EEE：曜日(水)
 EEEE：曜日(水曜日)
 aa：午前/午後
 H：時(0～23)
 HH：時(00～23)
 K：時(0～11)
 KK：時(00～11)
 m：分(0～59)
 mm：分(00～59)
 s：秒(0～59)
 ss：秒(00～59)
 S：ミリ秒
 
 */

+ (NSArray*)_getFileListSort:(NSString*)dirPath isAsc:(BOOL)isAsc extension:(NSString*)extension
{

    NSArray* fileArray = [clsFile _getFileList:dirPath filter:extension];

    // 属性情報を格納する配列
    NSMutableArray* attributes = [NSMutableArray array];

    // ファイル配列をループ
    for (NSString* filePath in fileArray) {

        // ファイル属性にファイルパスを追加するためにDictionaryを用意しておく
        NSMutableDictionary* tmpDictionary = [NSMutableDictionary dictionary];

        //  NSString *filepath = [path stringByAppendingPathComponent:file];
        // ファイル情報（属性）を取得
        // 取得できる情報については <a href="http://d.hatena.ne.jp/csouls/20110105/1295185197">csoulsの日記</a> を参考に！
        NSDictionary* attr = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];

        // tmp配列に属性を格納
        [tmpDictionary setDictionary:attr];

        // tmp配列にファイルパスを格納
        [tmpDictionary setObject:filePath forKey:@"filePath"];

        [attributes addObject:tmpDictionary];
    }

    // ソートさせる
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:NSFileCreationDate ascending:isAsc];
    NSArray* sortarray = [NSArray arrayWithObject:sortDescriptor];

    // 並び替えられたファイル配列
    NSArray* resultarray = [attributes sortedArrayUsingDescriptors:sortarray];

    // array dic

    return resultarray;
}

@end
