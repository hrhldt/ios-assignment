//
//  IAUser.m
//  ios-assignment
//
//  Created by Martin Herholdt Rasmussen on 16/05/16.
//  Copyright © 2016 Martin Herholdt Rasmussen. All rights reserved.
//

#import "IAUser.h"

@implementation IAUser

- (void)setValue:(id)value forKey:(NSString *)key {
    if ( [key isEqualToString:@"id"] ) {
        self.ID = value;
    } else {
        [super setValue:value forKey:key];
    }
}

@end
