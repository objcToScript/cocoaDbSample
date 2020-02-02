
#import "extension.h"
#import <objc/runtime.h>

@implementation NSObject (ex)

static const char* _getPropertyType(objc_property_t property)
{
    const char* attributes = property_getAttributes(property);
    // printf("attributes=%s\n", attributes);
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (attribute[0] == 'T' && attribute[1] != '@') {
            // it's a C primitive type:
            /*
             if you want a list of what will be returned for these primitives, search online for
             "objective-c" "Property Attribute Description Examples"
             apple docs list plenty of examples of what you get for int "i", long "l", unsigned "I", struct, etc.
             */
            return (const char*)[[NSData dataWithBytes:(attribute + 1) length:strlen(attribute) - 1] bytes];
        } else if (attribute[0] == 'T' && attribute[1] == '@' && strlen(attribute) == 2) {
            // it's an ObjC id type:
            return "id";
        } else if (attribute[0] == 'T' && attribute[1] == '@') {
            // it's another ObjC object type:
            return (const char*)[[NSData dataWithBytes:(attribute + 3) length:strlen(attribute) - 4] bytes];
        }
    }
    return "";
}


+ (NSDictionary*)_properties
{
    NSMutableDictionary* results = [[NSMutableDictionary alloc] init];
    
    unsigned int outCount, i;
    objc_property_t* properties = class_copyPropertyList(self, &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char* propName = property_getName(property);
        if (propName) {
            const char* propType = _getPropertyType(property);
            NSString* propertyName = [NSString stringWithUTF8String:propName];
            NSString* propertyType = [NSString stringWithUTF8String:propType];
            
            if (![propertyType isEqual:@"Q"] && ![propertyType isEqual:@"#"]) {
                if ([propertyType isEqual:@"q"]) {
                    propertyType = @"NSInteger";
                }
                [results setObject:propertyType forKey:propertyName];
            }
        }
    }
    
    //NSLog(@" results %@",   results  );
    
    free(properties);
    
    // returning a copy here to make sure the dictionary is immutable
    return [NSDictionary dictionaryWithDictionary:results];
}
@end

@implementation NSData (ex)
- (NSString*)_toString
{
    NSString* string = [[NSString alloc] initWithData:self
                                             encoding:NSUTF8StringEncoding];
    return string;
}
@end


@implementation NSDate (ex)
- (NSString*)_to_NSString
{
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY/MM/dd HH:mm:ss"];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    // 型変換：NSDate->NSString
    NSString* now_dateStr = [formatter stringFromDate:self];
    
    return now_dateStr;
}

@end

@implementation NSMutableArray (ex)
#pragma mark Json化
- (NSString*)_toJson
{
    NSError* error;
    
    id dic = [self copy];
    
    if ([NSJSONSerialization isValidJSONObject:dic]) {
        
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                           options:0
                                                             error:&error];
        if (!jsonData) {
            NSLog(@"bv_jsonStringWithPrettyPrint: arrayの中の値がobjの可能性あり error: %@", error.localizedDescription);
            return @"{}";
        } else {
            return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
    }
    
    NSLog(@"bv_jsonStringWithPrettyPrint: error: %@", error.localizedDescription);
    
    return @"{}";
}
@end



@implementation NSMutableDictionary (ex)
#pragma mark Json化
- (NSString*)_toJson
{
    NSError* error;
    
    id dic = [self copy];
    
    if ([NSJSONSerialization isValidJSONObject:dic]) {
        
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                           options:0
                                                             error:&error];
        if (!jsonData) {
            NSLog(@"bv_jsonStringWithPrettyPrint: error: %@", error.localizedDescription);
            return @"{}";
        } else {
            return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
    }
    
    NSLog(@"bv_jsonStringWithPrettyPrint: error: %@", error.localizedDescription);
    
    return @"{}";
}
@end

@implementation NSString (ex)
- (NSDate*)_toDate
{
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    
    if ([self _indexOf:@"Z"] != -1 && [self _indexOf:@"."] != -1) {
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
        
    } else if ([self _indexOf:@"Z"] != -1 && [self _indexOf:@"'"] != -1) {
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    } else if ([self _indexOf:@"Z"] != -1) {
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    } else {
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    
    //タイムゾーンの指定 日本時間になる
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    NSDate* date = [formatter dateFromString:self];
    
    return date;
}

- (int)_indexOf:(NSString*)text
{
    
    if (text == nil) {
        return -1;
    }
    
    NSRange range = [self rangeOfString:text];
    if (range.length > 0) {
        return (int)range.location;
    } else {
        return -1;
    }
}

- (BOOL)_isNull
{
    return [[NSNull null] isEqual:self];
}
@end

@implementation NSArrayController (ex)

-(void)_resetIndex{
    [self setSelectionIndex:-1];
}

-(void)_setSelectIndex:(int)index{
    [self setSelectionIndex:index];
}

-(void)_updateReload{
    
    [self rearrangeObjects];
    
}

-(id)_getDataRow{
    
    NSMutableArray* selectedObjects = self.arrangedObjects;
    
    if([selectedObjects count] > 0 && self.selectionIndex != -1){
        id dataRow = [selectedObjects objectAtIndex:[self selectionIndex]];
        return dataRow;
    }
    return nil;
}
@end

@implementation NSTableView (ex)
-(int)_getRowIndex{
    NSInteger selectedIndex = self.clickedRow;
    return (int)selectedIndex;
}

-(int)_getColumnIndex{
    NSInteger selectedIndex = self.clickedColumn;
    return (int)selectedIndex;
}


@end


