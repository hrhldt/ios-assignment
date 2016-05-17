//
//  IATextField.h
//  ios-assignment
//
//  Created by Martin Herholdt Rasmussen on 13/05/16.
//  Copyright © 2016 Martin Herholdt Rasmussen. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface IATextFieldView : UIView <UITextFieldDelegate>

- (void)setAttributedPlaceholder:(NSString *)thePlaceholder;
- (void)setAsPasswordTextField;
- (void)setAsEmailTextField;
- (void)resetTextField;

@property (weak, nonatomic) IBOutlet UIImageView *icon;

@property (weak, nonatomic) IBOutlet UITextField *inputField;

@property (weak, nonatomic) IBOutlet UIView *sepLine;

@end
