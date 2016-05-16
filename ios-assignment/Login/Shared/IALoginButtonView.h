//
//  IALoginButton.h
//  ios-assignment
//
//  Created by Martin Herholdt Rasmussen on 13/05/16.
//  Copyright © 2016 Martin Herholdt Rasmussen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IALoginButtonViewDelegate <NSObject>

- (void)loginButtonDidEndLoginAnimation;
- (void)loginButtonDidEndResetAnimation;

@end

IB_DESIGNABLE
@interface IALoginButtonView : UIView

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginButtonWidthConstraint;

@property (weak, nonatomic) id<IALoginButtonViewDelegate> delegate;

- (void)executeRedirectNavigation;
- (void)resetButtonState;
- (void)didPressLoginButton;
- (void)reenableLoginButton;

@end
