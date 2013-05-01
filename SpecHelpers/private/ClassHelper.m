//
//  ClassHelper.m
//  SpecHelpers
//
//  Created by Andrew J Wagner on 2/14/13.
//  Copyright (c) 2013 Drewag. All rights reserved.
//

#import "ClassHelper.h"

@interface ClassHelper()

+ (NSString *)getTypeOfProperty:(objc_property_t)property;
+ (Class)classForProperty:(objc_property_t)property;

@end

@implementation ClassHelper

+ (void)enumerateClassesWithPrefix:(NSString *)prefix
                         withBlock:(void(^)(NSString *className, Class class))block
{
    Class *classes = NULL;
    int numClasses = objc_getClassList(NULL, 0);
    classes = (Class *)malloc(sizeof(Class) * numClasses);
    numClasses = objc_getClassList(classes, numClasses);

    for (int classIndex = 0; classIndex < numClasses; classIndex++) {
        Class objectClass = classes[classIndex];
        NSString *className = NSStringFromClass(objectClass);

        if (className.length > 2
            && [[className substringToIndex:prefix.length] isEqualToString:prefix]
            && [objectClass isSubclassOfClass:[NSObject class]]) {
            block(className, objectClass);
        }
    }

    free(classes);
}

+ (void)enumerateObjectPropertiesOfClass:(Class)class
                               withBlock:(void(^)(NSString *key, Class propertyClass))block
{
    unsigned int propertyCount = 0;
    objc_property_t *properties = class_copyPropertyList(class, &propertyCount);
    if(!properties) { return; }

    for (unsigned int propertyIndex = 0; propertyIndex < propertyCount; propertyIndex++) {
        objc_property_t property = properties[propertyIndex];

        NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
        if (!propertyName) { continue; }

        Class propertyClass = [self classForProperty:property];
        if (!propertyClass) { continue; }

        block(propertyName, propertyClass);
    }
}

+ (BOOL)canSetPropertyWithName:(NSString *)propertyName onObject:(NSObject *)object {
    NSString *firstLetter = [[propertyName substringToIndex:1] uppercaseString];
    NSString *remainingLetters = [propertyName substringFromIndex:1];
    NSString *selectorString = [NSString stringWithFormat:@"set%@%@:", firstLetter, remainingLetters];

    return [object respondsToSelector:NSSelectorFromString(selectorString)];
}

#pragma mark - Private Methods


+ (Class)classForProperty:(objc_property_t)property {
    NSString *propertyType = [self getTypeOfProperty:property];
    return NSClassFromString(propertyType);
}

+ (NSString *)getTypeOfProperty:(objc_property_t)property {
    const char *attributes = property_getAttributes(property);

    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (attribute[0] == 'T' && attribute[1] != '@') {
            // it's a C primitive type:
            /*
             if you want a list of what will be returned for these primitives, search online for
             "objective-c" "Property Attribute Description Examples"
             apple docs list plenty of examples of what you get for int "i", long "l", unsigned "I", struct, etc.
             */
            NSString *name = [[NSString alloc] initWithBytes:attribute + 1 length:strlen(attribute) - 1 encoding:NSASCIIStringEncoding];
            return [name autorelease];
        }
        else if (attribute[0] == 'T' && attribute[1] == '@' && strlen(attribute) == 2) {
            // it's an ObjC id type:
            return @"id";
        }
        else if (attribute[0] == 'T' && attribute[1] == '@') {
            // it's another ObjC object type:
            NSString *name = [[NSString alloc] initWithBytes:attribute + 3 length:strlen(attribute) - 4 encoding:NSASCIIStringEncoding];
            return [name autorelease];
        }
    }
    return @"";
}

@end
