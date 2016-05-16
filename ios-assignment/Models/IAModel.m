//
//  IAModel.h
//  ios-assignment
//
//  Created by Martin Herholdt Rasmussen on 04/05/15.
//  Copyright (c) 2015 Martin Herholdt Rasmussen. All rights reserved.
//

#import "IAModel.h"
#import <objc/runtime.h>

@implementation IAModel

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    
    return self;
}

- (id)initWithValue:(id)value
{
    self = [super init];
    
    if (self) {
        if ([value isKindOfClass:[NSDictionary class]]) {
            [self setValuesForKeysWithDictionary:value];
        } else if ([value isKindOfClass:[self class]]) {
            self = value;
        }
    }
    return self;
}

#pragma mark - Service

//- (id)valueForUndefinedKey:(NSString *)key {
//    NSArray *allKeys = [self allKeys];
//    id returnObject = nil;
//    BOOL keyFound = NO;
//    
//    for (NSString *propertyName in allKeys) {
//        if ([propertyName isEqualToString:key]) {
//            id object = [self performSelector:NSSelectorFromString(key)];
//            
//            returnObject = object ? object : [NSNull null];
//            keyFound = YES;
//            break;
//        }
//    }
//    
//    if (!keyFound) {
//        @throw [NSException exceptionWithName:NSUndefinedKeyException reason:[NSString stringWithFormat:@"key '%@' not found", key] userInfo:nil];
//    }
//    
//    return returnObject;
//}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
//    NSString *capitalizedString = [key stringByReplacingCharactersInRange:NSMakeRange(0,1)
//                                                               withString:[[key substringToIndex:1] capitalizedString]];
//    NSString *setterString = [NSString stringWithFormat:@"set%@:", capitalizedString];
//    
//    [self performSelector:NSSelectorFromString(setterString) withObject:value];
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    const char *propertyName = [key UTF8String];
    objc_property_t property = class_getProperty(self.class, propertyName);

    if (property != nil) {
        const char* propertyAttributes = property_getAttributes(property);
        char datatypeChar = propertyAttributes[1];
        
        
        //primitive datatypes
        if (datatypeChar == 'i' || datatypeChar == 'q' || datatypeChar == 's' || datatypeChar == 'I' || datatypeChar == 'C' || datatypeChar == 'S' || datatypeChar == 'L' || datatypeChar == 'Q' || datatypeChar == 'f' || datatypeChar == 'd' || datatypeChar == 'B' ) {
            [super setValue:value forKey:key];
            
        }
        //array, dict, union
        else if (datatypeChar == '[' || datatypeChar == '{' || datatypeChar == '(') {
            [super setValue:value forKey:key];
            
        }
        //object
        else if(datatypeChar == '@'){
            
            NSString *propertyAttributesString = [NSString stringWithUTF8String:propertyAttributes];
            NSUInteger commaLocation = propertyAttributesString.length;
            NSRange commaRange = [propertyAttributesString rangeOfString:@","];
            if (commaRange.location != NSNotFound) {
                commaLocation = commaRange.location;
            }
            NSString *firstAttributeString = [propertyAttributesString substringWithRange:NSMakeRange(1, commaLocation - 1)];
            NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"@\""];
            NSArray *substrings = [firstAttributeString componentsSeparatedByCharactersInSet:characterSet];
            
            NSString *className = [substrings componentsJoinedByString:@""];
            
            Class class = NSClassFromString(className);
            
            if ([class isSubclassOfClass:[IAModel class]]) {
                id object = (IAModel *)[[class alloc] initWithValue:value];
                
                NSString *iVarPropertyName = [NSString stringWithFormat:@"_%s", propertyName];
                Ivar propertyVar = class_getInstanceVariable(self.class, [iVarPropertyName UTF8String]);
                object_setIvar(self, propertyVar, object);
            } else {
                [super setValue:value forKey:key];
            }
        }

    }
}

- (void)setNilValueForKey:(NSString *)key {
    
    const char *propertyName = [key UTF8String];
    NSString *iVarPropertyName = [NSString stringWithFormat:@"_%s", propertyName];
    
    Ivar propertyVar = class_getInstanceVariable(self.class, [iVarPropertyName UTF8String]);
    const char *typeEncoding = ivar_getTypeEncoding(propertyVar);
    char firstChar = typeEncoding[0];

    //array, dict, union, object
    if (firstChar == '[' || firstChar == '{' || firstChar == '(' || firstChar == '@') {
        [super setNilValueForKey:key];

        
    }

}

- (NSArray *)allKeys {
    unsigned int propertyCount = 0;
    objc_property_t *properties = class_copyPropertyList(self.class, &propertyCount);
    NSMutableArray *propertyNames = [NSMutableArray array];
    
    for (unsigned int i = 0; i < propertyCount; ++i) {
        objc_property_t property = properties[i];
        const char *name = property_getName(property);
        
        [propertyNames addObject:[NSString stringWithUTF8String:name]];
    }
    
    free(properties);
    
    return propertyNames;
}

- (id)copyWithZone:(NSZone *)zone
{

    id newObject = [[self.class alloc] init];
    
    Class aggregateClass = self.class;
    
    do {
        unsigned int propertyCount = 0;
        objc_property_t *properties = class_copyPropertyList(aggregateClass, &propertyCount);
        
        for (unsigned int i = 0; i < propertyCount; ++i) {
            objc_property_t property = properties[i];
            const char *propertyName = property_getName(property);
            NSString *iVarPropertyName = [NSString stringWithFormat:@"_%s", propertyName];
            
            Ivar propertyVar = class_getInstanceVariable(aggregateClass, [iVarPropertyName UTF8String]);
            const char *typeEncoding = ivar_getTypeEncoding(propertyVar);
            if (typeEncoding && typeEncoding[0]) {
                char firstChar = typeEncoding[0];
                
                //primitive datatypes
                if (firstChar == 'i' || firstChar == 'q' || firstChar == 's' || firstChar == 'I' || firstChar == 'C' || firstChar == 'S' || firstChar == 'L' || firstChar == 'Q' || firstChar == 'f' || firstChar == 'd' || firstChar == 'B' ) {
                    NSNumber *number = [self valueForKey:[NSString stringWithUTF8String:propertyName]];
                    [newObject setValue:number forKey:[NSString stringWithUTF8String:propertyName]];
                    
                }
                //array, dict, union
                else if (firstChar == '[' || firstChar == '{' || firstChar == '(') {
                    NSValue *value = [self valueForKey:[NSString stringWithUTF8String:propertyName]];
                    [newObject setValue:value forKey:[NSString stringWithUTF8String:propertyName]];
                    
                }
                //object
                else if(firstChar == '@'){
                    id propertyObject = object_getIvar(self, propertyVar);
                    id copyObject = [propertyObject copy];
                    
                    object_setIvar(newObject, propertyVar, copyObject);
                }

            }
            
        }
        
        free(properties);
        
        if ([aggregateClass superclass]) {
            aggregateClass = [aggregateClass superclass];
        }
        else
        {
            aggregateClass = nil;
        }
        
    } while (aggregateClass);



    
    return newObject;
}


- (void)encodeWithCoder:(NSCoder *)aCoder
{
    NSArray *keys = [self allKeys];
    NSDictionary *pairs = [self dictionaryWithValuesForKeys:keys];
    for (NSString *key in keys) {
        [aCoder encodeObject:[pairs objectForKey:key] forKey:key];
    }
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self)
    {
        
        unsigned int propertyCount = 0;
        objc_property_t *properties = class_copyPropertyList(self.class, &propertyCount);
        
        for (unsigned int i = 0; i < propertyCount; ++i) {
            
            objc_property_t property = properties[i];
            const char *propertyName = property_getName(property);
            NSString *iVarPropertyName = [NSString stringWithFormat:@"_%s", propertyName];
            
            Ivar propertyVar = class_getInstanceVariable(self.class, [iVarPropertyName UTF8String]);
            const char *typeEncoding = ivar_getTypeEncoding(propertyVar);
            char firstChar = typeEncoding[0];

            
            id value = [aDecoder decodeObjectForKey:[NSString stringWithUTF8String:propertyName]];

            if ([value isEqual:[NSNull null]]) {
                //primitive datatypes
                if (firstChar == 'i' || firstChar == 'q' || firstChar == 's' || firstChar == 'I' || firstChar == 'C' || firstChar == 'S' || firstChar == 'L' || firstChar == 'Q' || firstChar == 'f' || firstChar == 'd' || firstChar == 'B' ) {
//                    NSValue *value = [self valueForKey:[NSString stringWithUTF8String:propertyName]];
//                    [self setValue:value forKey:[NSString stringWithUTF8String:propertyName]];
//
                }
                //array, dict, union
                else if (firstChar == '[' || firstChar == '{' || firstChar == '(') {
//                    NSValue *value = [self valueForKey:[NSString stringWithUTF8String:propertyName]];
//                    [self setValue:value forKey:[NSString stringWithUTF8String:propertyName]];
                    
                }
                //object
                else if(firstChar == '@'){
//                    id propertyObject = object_getIvar(self, propertyVar);
//                    id copyObject = [propertyObject copy];
//                    
//                    object_setIvar(self, propertyVar, copyObject);
                    
                }

            }
            else{
                [self setValue:value forKey:[NSString stringWithUTF8String:propertyName]];
            }
        }
    }
    return self;
}
//static const char *getPropertyType(objc_property_t property) {
//    const char *attributes = property_getAttributes(property);
//    char buffer[1 + strlen(attributes)];
//    strcpy(buffer, attributes);
//    char *state = buffer, *attribute;
//    while ((attribute = strsep(&state, ",")) != NULL) {
//        if (attribute[0] == 'T') {
//            return (const char *)[[NSData dataWithBytes:(attribute + 3) length:strlen(attribute) - 4] bytes];
//        }
//    }
//    return "@";
//}

- (NSDictionary *)JSONDictionary
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    for (NSString *key in self.allKeys) {
        BOOL ignored = NO;
        for (NSString *ignoredKey in self.ignoredKeys) {
            if ([key isEqualToString:ignoredKey]) {
                ignored = YES;
            }
        }
        if (!ignored) {
            [dict setValue:[self JSONValueForKey:key] forKey:[self JSONKeyForKey:key]];
        }
    }
    
    return dict;
}

- (NSArray *)ignoredKeys
{
    return nil;
}
- (id)JSONValueForKey:(NSString *)key
{
    id object = [self valueForKey:key];
    if ([object isKindOfClass:[NSArray class]]) {
        NSMutableArray *returnArray = [[NSMutableArray alloc] init];
        for (id subObject in object) {
            if ([subObject isKindOfClass:[IAModel class]]) {
                IAModel *subObjectModel = subObject;
                [returnArray addObject:[subObjectModel JSONDictionary]];
            }
            else
            {
                [returnArray addObject:subObject];
            }
        }
        return [NSArray arrayWithArray:returnArray];
    }
    else{
        return [self valueForKey:key];

    }
}

- (NSString *)JSONKeyForKey:(NSString *)key
{
    return key;
}

-(NSString *)description
{
    return [[self JSONDictionary] description];
}
@end


