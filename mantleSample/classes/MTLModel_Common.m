
#import "MTLModel_Common.h"

@implementation MTLModel_Common

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    return dateFormatter;
}


-(void)_deleteNil{
    
    NSDictionary*defalutValueDic = [[self class] performSelector:@selector(_getDefaultPropertyValue)];
    
    NSArray* primaryKeys;
    if([[self class] respondsToSelector:@selector(FMDBPrimaryKeys)]){
        primaryKeys = [[self class] performSelector:@selector(FMDBPrimaryKeys)];
    }else if([[self class] respondsToSelector:@selector(MYSQLPrimaryKeys)]){
        primaryKeys = [[self class] performSelector:@selector(MYSQLPrimaryKeys)];
    }

    NSDictionary * propertyNameValue = [[self class] _properties];

    for(NSString*key in [propertyNameValue allKeys]){
        if([self respondsToSelector:NSSelectorFromString(key)]){
            
            id value_temp = [self valueForKey:key];
            //  id value_temp = [self performSelector:NSSelectorFromString(key)];
            if(value_temp == nil){
                
                NSString*type = [propertyNameValue objectForKey:key];
                NSString*defalutValue = [defalutValueDic objectForKey:key];
                
                if([primaryKeys containsObject:key]){
                     continue;
                }
                                
               
                if(type == nil && defalutValue == nil ){
                    [self setValue:[NSNull null] forKey:key];
                    continue;
                }

                if([type _indexOf:@"NSNumber"] != -1 ){
                    
                    if([defalutValue _isNull] || defalutValue == nil){
                        [self setValue:[NSNumber numberWithInt:0] forKey:key];
                    }else{
                        [self setValue:[NSNumber numberWithInt:[defalutValue intValue]] forKey:key];
                    }
                
                }else if([type _indexOf:@"NSInteger"] != -1){
                    
                    if([defalutValue _isNull] || defalutValue == nil){
                        [self setValue:[NSNumber numberWithInteger:0] forKey:key];
                    }else{
                        [self setValue:[NSNumber numberWithInteger:[defalutValue integerValue]] forKey:key];
                    }
                    
                }else if([type _indexOf:@"NSString"] != -1){
                    
                    if([defalutValue _isNull] || defalutValue == nil){
                        [self setValue:@"" forKey:key];
                    }else{
                        [self setValue:defalutValue forKey:key];
                    }
       
                }else{
                    [self setValue:[NSNull null] forKey:key];
                }

            }
        }
    }
    
}





@end
