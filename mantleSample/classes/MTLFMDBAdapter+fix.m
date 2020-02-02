#import "MTLFMDBAdapter+fix.h"

@implementation MTLFMDBAdapter (fix)

+ (NSString *)insertStatementForModelWithOutPrimaryKey:(MTLModel<MTLFMDBSerializing> *)model {
    
    NSDictionary *columns = [model.class FMDBColumnsByPropertyKey];
    NSArray *primayArray = [model.class FMDBPrimaryKeys];
    NSSet *propertyKeys = [model.class propertyKeys];
    NSArray *Keys = [[propertyKeys allObjects] sortedArrayUsingSelector:@selector(compare:)];
    NSMutableArray *stats = [NSMutableArray array];
    NSMutableArray *qmarks = [NSMutableArray array];
    for (NSString *propertyKey in Keys)
      {
        NSString *keyPath = columns[propertyKey];
        keyPath = keyPath ? : propertyKey;
        
        if (keyPath != nil && ![keyPath isEqual:[NSNull null]])
          {
            if( [primayArray containsObject:keyPath]){
                continue;
            }

            keyPath = [self _isYoyakugo:keyPath];
            
            [stats addObject:keyPath];
            [qmarks addObject:@"?"];
          }
      }

    NSString *statement = [NSString stringWithFormat:@"insert into %@ (%@) values (%@)", [model.class FMDBTableName], [stats componentsJoinedByString:@", "], [qmarks componentsJoinedByString:@", "]];
    
    return statement;
}


+ (NSArray *)columnValuesWithOutPrimaryKey:(MTLModel<MTLFMDBSerializing> *)model {
    
    NSDictionary *columns = [model.class FMDBColumnsByPropertyKey];
    NSArray *primayArray = [model.class FMDBPrimaryKeys];
    NSSet *propertyKeys = [model.class propertyKeys];
    NSArray *Keys = [[propertyKeys allObjects] sortedArrayUsingSelector:@selector(compare:)];
    NSDictionary *dictionaryValue = model.dictionaryValue;
    NSMutableArray *values = [NSMutableArray array];
    for (NSString *propertyKey in Keys)
      {
        NSString *keyPath = columns[propertyKey];
        keyPath = keyPath ? : propertyKey;
        
        if (keyPath != nil && ![keyPath isEqual:[NSNull null]])
          {
            if( [primayArray containsObject:keyPath]){
                continue;
            }            
            id v = [dictionaryValue valueForKey:propertyKey];
            if (v == nil) {
                NSLog(@"Warning: value for key %@ is nil", propertyKey);
                v = [NSNull null];
            }
            // TODO: apply transformation
            NSDictionary *transformers = [self valueTransformersForModelClass:model.class];
            NSValueTransformer *transformer = [transformers objectForKey:propertyKey]; //[self FMDBTransformerForKey:propertyKey];
            if (transformer != nil) {
                if ([transformer.class allowsReverseTransformation]) {
                    // Map NSNull -> nil for the transformer, and then back for the
                    // dictionaryValue we're going to insert into.
                    if (![v isEqual:NSNull.null]) {
                        v = [transformer reverseTransformedValue:v];
                    }
                }
            }
            
            //追加 insert時に mutableをシリアライズする
            if([v isKindOfClass:[NSMutableDictionary class]] ||
               [v isKindOfClass:[NSDictionary class]]){
                NSString* str = [((NSMutableDictionary*)v) _toJson];
                [values addObject:str];
            }else if([v isKindOfClass:[NSMutableArray class]] ||
                     [v isKindOfClass:[NSArray class]]){
                NSString* str = [((NSMutableArray*)v) _toJson];
                [values addObject:str];
            }else if([v isKindOfClass:[NSDate class]]){
                NSString* str = [((NSDate*)v) _to_NSString];
                [values addObject:str];
            }else if([v isKindOfClass:[NSData class]]){
                NSString* str = [((NSData*)v) _toString];
                [values addObject:str];
            }else{
                [values addObject:v];
            }
            
          }
      }
    return values;
}

@end
