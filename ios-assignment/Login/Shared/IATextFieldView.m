//
//  IATextField.m
//  ios-assignment
//
//  Created by Martin Herholdt Rasmussen on 13/05/16.
//  Copyright © 2016 Martin Herholdt Rasmussen. All rights reserved.
//

#import "IATextFieldView.h"

@implementation IATextFieldView

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

#pragma mark - setup view

- (void)awakeFromNib {
    [super awakeFromNib];
    self.sepLine.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
}

- (void)setAsPasswordTextField {
    UIImage *image = [UIImage imageNamed:@"ic_key"];
    UIImage *templateImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.icon setImage:templateImage];

    self.icon.tintColor = [UIColor colorWithWhite:1 alpha:0.3];
}

- (void)setAsEmailTextField {
    UIImage *image = [UIImage imageNamed:@"ic_user"];
    UIImage *templateImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.icon setImage:templateImage];

    self.icon.tintColor = [UIColor colorWithWhite:1 alpha:0.3];
}

- (void)setAttributedPlaceholder:(NSString *)thePlaceholder {
    UIColor *color = [UIColor colorWithWhite:1 alpha:0.3];
    self.inputField.attributedPlaceholder =
    [[NSAttributedString alloc]
     initWithString:thePlaceholder
     attributes:@{NSForegroundColorAttributeName:color, NSFontAttributeName:[UIFont boldSystemFontOfSize:16]}];
}

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

#pragma mark - selection states

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.sepLine.backgroundColor = [UIColor whiteColor];
    self.icon.tintColor = [UIColor whiteColor];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ( textField.text.length == 0 ) {
        self.icon.tintColor = [UIColor colorWithWhite:1 alpha:0.3];
        self.sepLine.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
    }
}

#pragma mark - Actions



@end

