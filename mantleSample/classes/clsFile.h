
@interface clsFile : NSObject {
    
}

+(NSString*)_getSearchFileNamePath_One:(NSString*)dirPath fileName:(NSString*)fileName filter:(NSString*)filter;

+(NSMutableArray*)_getSearchFileNamePath:(NSString*)dirPath fileName:(NSString*)fileName filter:(NSString*)filter;

//+ (NSString*)_getLocalApplicationDirectoryPath:(NSString*)filePathOrFileName;

// アプリケーションデイレクトリパスを取得する
//+ (NSString*)_getLocalApplicationDirectoryPath;

// ファイル移動
+ (BOOL)_moveFile:(NSString*)fromPath toPath:(NSString*)toPath;

//テキストファイル作成
+ (BOOL)_createTextFile:(NSString*)filePath;

//dataファイル作成
+ (BOOL)_createDataFile:(NSString*)filePath;

//カテゴリーファイル
+ (NSArray*)_getCategoryFileList_deep:(NSString*)filePath;

//ファイルの変更日時
+ (NSDate*)_getModificationDate:(NSString*)filePath;

// フォルダーサイズ
+ (unsigned long long int)_folderSize:(NSString*)folderPath;

// ファイル読み込み配列として返す
+ (NSArray*)_loadArrayLine:(NSString*)filePath;

// データ読み込み
+ (NSData*)_loadData:(NSString*)filePath;

//ファイルをコピーする
+ (BOOL)_copyFile:(NSString*)filePath toFilePath:(NSString*)toFilePath;
// ファイル読み込み
+ (NSString*)_loadText:(NSString*)filePath;

//documentファイルを読み込み
+ (NSString*)_loadDocumentText:(NSString*)fileName;

//ファイルバンドル読み込み
+ (NSString*)_loadBundleText:(NSString*)fileName;

+ (NSString*)_loadResourceText:(NSString*)fileName;

// NSAarry読み込み
+ (NSArray*)_loadArrayData:(NSString*)filePath;
// NSAarryのファイルに保存
+ (BOOL)_saveArrayData:(NSArray*)items filePath:(NSString*)filePath;

// バイナリーファイルに保存
+ (BOOL)_saveData:(NSData*)data filePath:(NSString*)filePath;
// ファイルに保存
+ (BOOL)_save:(NSString*)text filePath:(NSString*)filePath;
//ファイルリネーム
+ (BOOL)_fileReName:(NSString*)filePath_old filePath_new:(NSString*)filePath_new;

// imageSage
// ファイルに追記書き込み
+ (void)_addSave:(NSString*)addText filePath:(NSString*)filePath;

+ (void)_addSaveWithReturn:(NSString*)addText filePath:(NSString*)filePath;

// ファイル削除する
+ (BOOL)_deleteFile:(NSString*)filePath;

// ファイルがあるかどうか
+ (BOOL)_isFile:(NSString*)filePath;

// バンドルファイルがあるかどうか
+ (BOOL)_isBundleFile:(NSString*)bundleFileName;

// APPと同じ階層のパスの取得
+ (NSString*)_getAppExePath:(NSString*)filePath;

// バンドルパス取得
+ (NSString*)_getCacheDirPath:(NSString*)filePath;

//キャッシュパス
+ (NSString*)_getCacheDirPath;

// 一時ファイルパス取得
+ (NSString*)_getTempFilePath;

// リソースパス取得
+ (NSString*)_getResourcePath:(NSString*)filePath;

// exeパス取得
+ (NSString*)_getExeContentPath:(NSString*)filePath;

// バンドルパス取得
+ (NSString*)_getBundlePath:(NSString*)filePath;

+ (NSString*)_getBundlePath;

+ (NSString*)_getBundleDirPath;

+ (NSString*)_getBundleDirPath:(NSString*)filePath;

// tempファイルパスを取得する
+ (NSString*)_getTemporaryDirPath:(NSString*)filePath;

// ドキュメントパスを取得する
+ (NSString*)_getDocumentPath:(NSString*)filePath;

// ドキュメントデイレクトリパスを取得する
+ (NSString*)_getDocumentDirPath;

// ApplicationSupportDirectory パスとファイル名を取得する
+ (NSString*)_getApplicationSupportDirectory_Path:(NSString*)appNameFolder filePathOrFileName:(NSString*)filePathOrFileName;

+ (NSString*)_getApplicationSupportDirectory_FileNameOnly:(NSString*)filePathOrFileName;

//ApplicationSupportDirectory パスを取得する
+ (NSString*)_getApplicationSupportDirectory_DirPath;

// ファイル一覧を取得する
+ (NSArray*)_getFileList:(NSString*)dirPath;

+ (NSArray*)_getFileList:(NSString*)dirPath filter:(NSString*)filter;

+ (NSString*)_getFileList_one:(NSString*)dirPath filter:(NSString*)filter;

+ (NSArray*)_getFileList_deep:(NSString*)dirPath filter:(NSString*)filter;

//ファイル１つのみ
+ (NSString*)_getFileList_deep_one:(NSString*)dirPath filter:(NSString*)filter;

//オブジェクトを読み込む
+ (id)_loadObject:(NSString*)filePath;

//オブジェクトを保存する
+ (BOOL)_saveObject:(id)array filePath:(NSString*)filePath;

// ファイル情報を取得する
+ (NSDictionary*)_getFileInfo:(NSString*)filePath;

//ファイルリストを取得しソートする
+ (NSArray*)_getFileListSort:(NSString*)dirPath isAsc:(BOOL)isAsc extension:(NSString*)extension;

@end
