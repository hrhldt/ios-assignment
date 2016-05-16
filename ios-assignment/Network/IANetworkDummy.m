//
//  IANetworkDummy.m
//  ios-assignment
//
//  Created by Martin Herholdt Rasmussen on 16/05/16.
//  Copyright © 2016 Martin Herholdt Rasmussen. All rights reserved.
//

#import "IANetworkDummy.h"

@implementation IANetworkDummy


+ (void)requestLoginWithEmail:(NSString *)email password:(NSString *)password delegate:(id<IANetworkDummyDelegate>)delegate {

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *splittedEmail = [email componentsSeparatedByString:@"@"];
        NSString *domainPart = splittedEmail[1];

        if ( ![[self class] isEmailWithValidDomain:domainPart] ) {
            if ( [delegate respondsToSelector:@selector(networkDidFailWithError:)] ) {
                [delegate networkDidFailWithError:[NSError errorWithDomain:@"Wrong email domain" code:kWrongEmailError userInfo:nil]];
            }
        } else if ( ![[self class] isPasswordValidToEmail:email password:password] ) {
            if ( [delegate respondsToSelector:@selector(networkDidFailWithError:)] ) {
                [delegate networkDidFailWithError:[NSError errorWithDomain:@"Wrong email domain" code:kWrongPasswordError userInfo:nil]];
            }
        } else {
            if ( [delegate respondsToSelector:@selector(networkDidLoginWithUser:)] ) {
                [delegate networkDidLoginWithUser:[[self class] parseLoginSuccess:email]];
            }
        }
    });

}


#pragma mark - Helper methods

+ (BOOL)isEmailWithValidDomain:(NSString *)domain {
    NSArray *splitByDomain = [domain componentsSeparatedByString:@"."];

    NSString *cleanDomain = splitByDomain[0];
    if ( cleanDomain && cleanDomain.length > 0 && [cleanDomain isEqualToString:kAcceptedDomain] ) {
        return YES;
    }

    return NO;
}

+ (BOOL)isPasswordValidToEmail:(NSString *)email password:(NSString *)password {
    NSArray *firstAndSecondPart = [email componentsSeparatedByString:@"@"];

    NSArray *splitByDomain = [firstAndSecondPart[0] componentsSeparatedByString:@"."];

    NSString *localPart = splitByDomain[0];
    if ( localPart && localPart.length > 0 && [localPart isEqualToString:password] ) {
        return YES;
    }

    return NO;

}

+ (IAUser *)parseLoginSuccess:(NSString *)email {
    IAUser *user = [IAUser new];
    user.email = email;
    return user;
}

@end
