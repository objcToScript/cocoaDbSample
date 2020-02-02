#import "MTLFMDBAdapter.h"

@interface MTLFMDBAdapter (fix)

+ (NSArray *)columnValuesWithOutPrimaryKey:(MTLModel<MTLFMDBSerializing> *)model;

+ (NSString *)insertStatementForModelWithOutPrimaryKey:(MTLModel<MTLFMDBSerializing> *)model;

@end

