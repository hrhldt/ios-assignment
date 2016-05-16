//
//  IAModel.h
//  ios-assignment
//
//  Created by Martin Herholdt Rasmussen on 04/05/15.
//  Copyright (c) 2015 Martin Herholdt Rasmussen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IAModel : NSObject <NSCopying, NSCoding>

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSArray *)allKeys;
- (NSDictionary *)JSONDictionary;
- (id)JSONValueForKey:(NSString *)key;
- (NSString *)JSONKeyForKey:(NSString *)key;
- (NSArray *)ignoredKeys;
- (id)initWithValue:(id)value;

@end
