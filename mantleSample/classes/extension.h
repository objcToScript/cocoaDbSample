#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (ex)
- (NSString*)_toString;
@end

@interface NSDate (ex)
- (NSString*)_to_NSString;
@end


@interface NSMutableDictionary (ex)
- (NSString*)_toJson;
@end

@interface NSMutableArray (ex)
- (NSString*)_toJson;
@end

@interface NSString (ex)
- (NSString*)_toDate;
- (int)_indexOf:(NSString*)text;
@end

@interface NSObject (ex)
+ (NSDictionary*)_properties;
- (BOOL)_isNull;
@end

@interface NSArrayController (ex)
-(void)_resetIndex;
-(void)_setSelectIndex:(int)index;
-(void)_updateReload;
-(id)_getDataRow;
@end

@interface NSTableView (ex)
-(int)_getRowIndex;
-(int)_getColumnIndex;
@end




NS_ASSUME_NONNULL_END
