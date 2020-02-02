
@interface MTLModel_Common : MTLModel

+ (NSDateFormatter *)dateFormatter;

+ (NSDateFormatter *)dateFormatter_MYSQL;

-(id)_searchTreeViewFilter:(NSString*)keyName value:(id)value;

-(void)_deleteNil;

-(void)_fetch_dic:(NSMutableDictionary*)paramDic;

-(void)_fetch_ToMantleModel_fromModel:(id)modelObj;

-(id)_fetch_To_SwaggerModel:(id)swaggerModel;


@end
