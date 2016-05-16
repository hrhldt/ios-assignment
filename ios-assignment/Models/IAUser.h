//
//  IAUser.h
//  ios-assignment
//
//  Created by Martin Herholdt Rasmussen on 16/05/16.
//  Copyright © 2016 Martin Herholdt Rasmussen. All rights reserved.
//

#import "IAModel.h"

@interface IAUser : IAModel

@property (strong, nonatomic) NSString *ID;
@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) NSString *email;

@end
