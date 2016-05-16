//
//  IAGradientView.m
//  ios-assignment
//
//  Created by Martin Herholdt Rasmussen on 13/05/16.
//  Copyright (c) 2015 Martin Herholdt Rasmussen. All rights reserved.
//

#import "IAGradientView.h"

@implementation IAGradientView
{
    BOOL useLightGradient;
}

static const CGFloat lighterColors [] = {
    0.0, 0.0, 0.0, 0.0,
    0.0, 0.0, 0.0, 0.05
};

static const CGFloat colors [] = {
    0.0, 0.0, 0.0, 0.25,
    0.0, 0.0, 0.0, 0.75,
    0.0, 0.0, 0.0, 1.0
};

- (void)setLightGradient {
    useLightGradient = YES;
    [self layoutSubviews];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGGradientRef gradient;
    
    if ( useLightGradient ) {
        gradient = CGGradientCreateWithColorComponents(colorSpace, lighterColors, (const CGFloat[2]){0.0f,1.0f}, 2);
    } else {
        gradient = CGGradientCreateWithColorComponents(colorSpace, colors, (const CGFloat[2]){0.0f,1.0f}, 2);
    }
    
    CGContextDrawLinearGradient(context, gradient, CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMinY(self.bounds)), CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds)), 0);
    
    CGColorSpaceRelease(colorSpace);
    CGContextRestoreGState(context);
}
@end
