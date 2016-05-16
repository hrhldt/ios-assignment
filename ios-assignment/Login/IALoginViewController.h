//
//  ViewController.h
//  ios-assignment
//
//  Created by Martin Herholdt Rasmussen on 13/05/16.
//  Copyright © 2016 Martin Herholdt Rasmussen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IATextFieldView.h"
#import "IALoginButtonView.h"
#import "IANetworkDummy.h"
#import "Utils.h"

@interface IALoginViewController : UIViewController <IANetworkDummyDelegate, IALoginButtonViewDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet IATextFieldView *emailTextFieldView;

@property (weak, nonatomic) IBOutlet IATextFieldView *passwordTextFieldView;

@property (weak, nonatomic) IBOutlet IALoginButtonView *loginButtonView;

@end

