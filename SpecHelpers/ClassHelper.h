//
//  ClassHelper.h
//  SpecHelpers
//
//  Created by Andrew J Wagner on 2/14/13.
//  Copyright (c) 2012 Drewag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface ClassHelper : NSObject

+ (void)enumerateClassesWithPrefix:(NSString *)prefix
                         withBlock:(void(^)(NSString *className, Class class))block;

+ (void)enumerateObjectPropertiesOfClass:(Class)objectClass
                               withBlock:(void(^)(NSString *key, Class propertyClass))block;

+ (BOOL)canSetPropertyWithName:(NSString *)propertyName onObject:(NSObject *)object;

@end
