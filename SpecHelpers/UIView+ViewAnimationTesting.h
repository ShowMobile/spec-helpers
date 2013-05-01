//
//  UIView+ViewAnimationTesting.h
//  notecards
//
//  Created by Andrew J Wagner 4/21/13.
//  Copyright (c) 2012 Drewag. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIView (ViewAnimationTesting)

+ (void)executeAllAnimationsImmediatelyDuring:(void(^)())block;

@end
