//
//  UIImage+ImageUtilities.h
//  ios-assignment
//
//  Created by Martin Herholdt Rasmussen on 13/05/16.
//  Copyright (c) 2015 Martin Herholdt Rasmussen. All rights reserved.
//

#import <UIKit/UIKit.h>

#define HEXCOLOR(c, a) [UIColor colorWithRed:((c>>16)&0xFF)/255.0 green:((c>>8)&0xFF)/255.0 blue:(c&0xFF)/255.0 alpha:a];
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface UIImage (BOImageUtilities)

+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color frame:(CGRect)theRect;
@end
