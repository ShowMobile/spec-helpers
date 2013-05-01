//
//  UIView+ViewAnimationTesting.h
//  notecards
//
//  Created by Andrew J Wagner 4/21/13.
//  Copyright (c) 2012 Drewag. All rights reserved.
//

#import "UIView+ViewAnimationTesting.h"
#include <objc/runtime.h>


@implementation UIView (ViewAnimationTesting)

+ (void)mockAnimateWithDuration:(NSTimeInterval)duration animations:(void(^)())animations {
    animations();
}

+ (void)mockAnimateWithDuration:(NSTimeInterval)duration
                     animations:(void(^)())animations
                     completion:(void(^)(BOOL finished))completion
{
    animations();
    if (completion) {
        completion(YES);
    }
}

+ (void)executeAllAnimationsImmediatelyDuring:(void(^)())block {
    Method animateMethod = class_getClassMethod(self, @selector(animateWithDuration:animations:));
    Method animateWithCompletionMethod = class_getClassMethod(self, @selector(animateWithDuration:animations:completion:));

    Method mockAnimateMethod = class_getClassMethod(self, @selector(mockAnimateWithDuration:animations:));
    Method mockAnimateWithCompletionMethod = class_getClassMethod(self, @selector(mockAnimateWithDuration:animations:completion:));

    method_exchangeImplementations(animateMethod, mockAnimateMethod);
    method_exchangeImplementations(animateWithCompletionMethod, mockAnimateWithCompletionMethod);
    block();
    method_exchangeImplementations(mockAnimateMethod, animateMethod);
    method_exchangeImplementations(mockAnimateWithCompletionMethod, animateWithCompletionMethod);
}

@end
