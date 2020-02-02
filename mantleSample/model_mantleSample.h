#import <Mantle/MTLModel.h>
#import <Mantle/Mantle.h>
#import "MTLModel_Common.h"
#import "MTLFMDBAdapter.h"



@interface db_testTable : MTLModel_Common<MTLJSONSerializing,MTLFMDBSerializing>{
	NSInteger _test_id;
	NSString *_name;
	NSDate *_date;
	NSNumber *_deleteFlag;

}

	@property (nonatomic, assign) NSInteger test_id;
	@property (nonatomic, copy) NSString *name;
	@property (nonatomic, copy) NSDate *date;
	@property (nonatomic, copy) NSNumber *deleteFlag;


+(NSDictionary *)_getDefaultPropertyValue;

+(NSArray *)_getColumns;

+(NSDictionary *)FMDBColumnsByPropertyKey;

+(NSDictionary *)JSONKeyPathsByPropertyKey;

@end
