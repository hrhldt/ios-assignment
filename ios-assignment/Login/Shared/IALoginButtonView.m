//
//  IALoginButton.m
//  ios-assignment
//
//  Created by Martin Herholdt Rasmussen on 13/05/16.
//  Copyright © 2016 Martin Herholdt Rasmussen. All rights reserved.
//

#import "IALoginButtonView.h"
#import "UIImage+ImageUtilities.h"

@implementation IALoginButtonView
{
    CGFloat viewHeight;
}

#pragma mark - init methods

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // load view frame XIB
        [self commonSetup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // load view frame XIB
        [self commonSetup];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    //self.loginButton.layer.cornerRadius = self.loginButton.frame.size.height / 2;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    UIColor *defaultColor = HEXCOLOR(0x188900, 1);
    UIColor *highlightedColor = HEXCOLOR(0x188900, 0.3);
    [self.loginButton setBackgroundImage:[UIImage imageWithColor:defaultColor frame:self.loginButton.frame] forState:UIControlStateNormal];
    [self.loginButton setBackgroundImage:[UIImage imageWithColor:highlightedColor frame:self.loginButton.frame] forState:UIControlStateHighlighted];

    [self.loginButton setTitleColor:[UIColor colorWithWhite:1 alpha:0.3] forState:UIControlStateHighlighted];

    [self.loginButton setTitle:NSLocalizedString(@"Login", @"loginButtonTitle") forState:UIControlStateNormal];

    viewHeight = self.frame.size.height;

    self.loginButton.layer.cornerRadius = viewHeight * 0.5;
    self.loginButton.layer.masksToBounds = YES;

    self.loginButtonWidthConstraint.constant = self.frame.size.width;
    [self.loginButton setNeedsUpdateConstraints];
    [self.loginButton layoutIfNeeded];
//    self.layer.cornerRadius = viewHeight * 0.5;
//    self.layer.masksToBounds = YES;
}

#pragma mark - setup view

- (UIView *)loadViewFromNib {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];

    //  An exception will be thrown if the xib file with this class name not found,
    UIView *view = [[bundle loadNibNamed:NSStringFromClass([self class])  owner:self options:nil] firstObject];
    return view;
}

- (void)commonSetup {
    UIView *nibView = [self loadViewFromNib];
    nibView.frame = self.bounds;
    // the autoresizingMask will be converted to constraints, the frame will match the parent view frame
    nibView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    // Adding nibView on the top of our view
    [self addSubview:nibView];
}

#pragma mark - actions

- (void)reenableLoginButton {
    [self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
    self.loginButton.enabled = YES;
    self.activityIndicator.hidden = YES;
}

- (void)didPressLoginButton {
    [self.loginButton setTitle:@"" forState:UIControlStateNormal];
    self.activityIndicator.alpha = 1;
    self.loginButton.enabled = NO;
    self.activityIndicator.hidden = NO;
}

- (void)executeRedirectNavigation {
    [self.activityIndicator setNeedsUpdateConstraints];
    self.loginButtonWidthConstraint.constant = viewHeight;

    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.activityIndicator.alpha = 0;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.activityIndicator.hidden = YES;
        [self loginSucceeded];
    }];
}

- (void)loginSucceeded {
    __weak IALoginButtonView *weakSelf = self;

    CGFloat scaleFactor = [UIApplication sharedApplication].keyWindow.frame.size.height  / viewHeight;

    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.activityIndicator.alpha = 0;
        self.loginButton.transform =
        CGAffineTransformScale(self.loginButton.transform, scaleFactor * 2, scaleFactor * 2);
    } completion:^(BOOL finished) {
        self.activityIndicator.hidden = YES;

        if ( weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(loginButtonDidEndLoginAnimation)] ) {
            [weakSelf.delegate loginButtonDidEndLoginAnimation];
        }
    }];
}

- (void)resetButtonState {
    [self.activityIndicator setNeedsUpdateConstraints];
    self.loginButtonWidthConstraint.constant = self.frame.size.width;

    self.activityIndicator.hidden = NO;

    __weak IALoginButtonView *weakSelf = self;

    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self layoutIfNeeded];
        self.loginButton.transform = CGAffineTransformIdentity;
        self.activityIndicator.alpha = 0;
    } completion:^(BOOL finished) {
        [self.loginButton setTitle:NSLocalizedString(@"Login", @"loginButtonTitle") forState:UIControlStateNormal];

        if ( weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(loginButtonDidEndResetAnimation)] ) {
            [weakSelf.delegate loginButtonDidEndResetAnimation];
        }
    }];
}

@end
