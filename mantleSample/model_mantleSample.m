#import "model_mantleSample.h"



@implementation db_testTable

+ (NSDictionary *)FMDBColumnsByPropertyKey{
    return @{
        @"test_id": @"test_id",@"name": @"name",@"date": @"date",@"deleteFlag": @"deleteFlag"
    };
}

+ (NSArray *)_getColumns{
    return @[@"test_id",@"name",@"date",@"deleteFlag"];
}

+ (NSDictionary *)_getDefaultPropertyValue{
    return @{@"deleteFlag":@"0"};
}

+ (NSArray *)FMDBPrimaryKeys{
    return @[@"test_id"];
}

+ (NSString *)FMDBTableName {
    return @"testTable";
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"test_id": @"test_id",@"name": @"name",@"date": @"date",@"deleteFlag": @"deleteFlag"
    };
}

 + (NSValueTransformer *)test_idJSONTransformer {

    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSDictionary *value, BOOL *success, NSError *__autoreleasing *error) {

        if(value== nil){
            return [[NSNumber alloc] initWithInteger:0];
        }

        return value;

}reverseBlock:^id(id  value, BOOL *success, NSError *__autoreleasing *error) {

        return value;

}];

}

+ (NSValueTransformer *)test_idFMDBTransformer {

    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSDictionary *value, BOOL *success, NSError *__autoreleasing *error) {

        if(value== nil){
            return [[NSNumber alloc] initWithInteger:0];
        }

        return value;

}reverseBlock:^id(id  value, BOOL *success, NSError *__autoreleasing *error) {

        return value;

}];

}

+ (NSValueTransformer *)dateJSONTransformer {

return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {

    if([dateString isKindOfClass:[NSDate class]]){
        return dateString;
    }else{
        return [dateString _toDate];
    }

} reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
    return [self.dateFormatter stringFromDate:date];

}];
}

+ (NSValueTransformer *)dateFMDBTransformer {
return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {

    if([dateString isKindOfClass:[NSDate class]]){
        return dateString;
    }else{
        return [dateString _toDate];
    }

} reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {

    return [self.dateFormatter stringFromDate:date];

}];
}
+ (NSValueTransformer *)deleteFlagJSONTransformer {

return [NSValueTransformer valueTransformerForName:MTLBooleanValueTransformerName];
}

+ (NSValueTransformer *)deleteFlagFMDBTransformer {

return [NSValueTransformer valueTransformerForName:MTLBooleanValueTransformerName];
}



@end
