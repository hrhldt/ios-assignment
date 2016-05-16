//
//  IANetworkDummy.h
//  ios-assignment
//
//  Created by Martin Herholdt Rasmussen on 16/05/16.
//  Copyright © 2016 Martin Herholdt Rasmussen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAUser.h"

#define kAcceptedDomain @"shopgun"
#define kWrongEmailError 1337
#define kWrongPasswordError 1338

@protocol IANetworkDummyDelegate <NSObject>

@required
- (void)networkDidFailWithError:(NSError *)error;

@optional
- (void)networkDidLoginWithUser:(IAUser *)user;

@end

@interface IANetworkDummy : NSObject

+ (void)requestLoginWithEmail:(NSString *)email password:(NSString *)password delegate:(id<IANetworkDummyDelegate>)delegate;

@end
