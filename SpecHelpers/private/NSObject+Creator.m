//
//  NSObject+Creator.m
//  SpecHelpers
//
//  Created by Andrew J Wagner on 11/9/12.
//  Copyright (c) 2012 Drewag. All rights reserved.
//

#import "NSObject+Creator.h"

#import <objc/runtime.h>

@interface NSObject (PrivateCreator)

- (NSString*)getTypeNameFromPropertyNamed:(NSString *)name;
- (NSString *)classNameWithoutProtocol:(NSString *)oldClassName;
- (void)setValue:(id)value
          forKey:(NSString *)key
    forClassName:(NSString *)className;
- (void)setValue:(id)value
          forKey:(NSString *)key
        forClass:(Class)class;

@end


@implementation NSObject (Creator)

+ (id)instanceWithProperties:(NSDictionary *)dictionary {
    return [[[self alloc] initWithProperties:dictionary] autorelease];
}

- (id)initWithProperties:(NSDictionary *)dictionary {
    self = [self init];
    if (self) {
        [self updateWithProperties:dictionary];
    }
    return self;
}

- (id)updateWithProperties:(NSDictionary *)dictionary {
    [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        NSString *retClassname = [self getTypeNameFromPropertyNamed:key];
        if (retClassname) {
            [self setValue:obj forKey:key forClassName:retClassname];
        }
    }];
    return self;
}

@end

#pragma mark - Private Methods

@implementation NSObject (PrivateCreator)

- (void)setValue:(id)value
          forKey:(NSString *)key
    forClassName:(NSString *)className
{
    if ([className characterAtIndex:0] == '@') {
        // Is an object
        NSString *classString = [className substringWithRange:NSMakeRange(2,[className length] - 3)];
        classString = [self classNameWithoutProtocol:classString];

        Class valueClass = NSClassFromString(classString);
        if (valueClass) {
            [self setValue:value forKey:key forClass:valueClass];
        }
        else {
            @throw [NSException exceptionWithName:@"Failed to Find Class For Property" reason:@"Class of property could not be found" userInfo:@{
                @"property": key,
                @"classString": classString,
            }];
        }
    }
    else {
        [self setValue:value forKey:key];
    }
}

- (void)setValue:(id)value
          forKey:(NSString *)key
        forClass:(Class)class
{
    if ([value isEqual:[NSNull null]]) {
        [self setValue:nil forKey:key];
    }
    else if ([[value class] isSubclassOfClass:class]) {
        [self setValue:value forKey:key];
    }
    else if ([value isKindOfClass:[NSDictionary class]]) {
        NSObject *newValue = [[class alloc] initWithProperties:value];
        [self setValue:newValue forKey:key];
        [newValue release];
    }
    else if (class == [NSURL class] && [[value class] isSubclassOfClass:[NSString class]]) {
        NSURL *newValue = [NSURL URLWithString:value];
        [self setValue:newValue forKey:key];
    }
    else {
        @throw [NSException
            exceptionWithName:@"Failed to Set Property"
            reason:[NSString stringWithFormat:@"Value type for key (%@) doesn't match property type", key]
            userInfo:@{
            @"property": key,
            @"valueClass": NSStringFromClass([value class]),
            @"propertyClass": NSStringFromClass(class),
        }];
    }
}

-(NSString*)getTypeNameFromPropertyNamed:(NSString *)name {
    objc_property_t property = class_getProperty([self class], [name UTF8String]);
    if (!property) return nil;

    const char * attributes = property_getAttributes(property);

    NSString *returnTypeName = [NSString stringWithUTF8String:attributes + 1];
    NSUInteger i;
    for (i = 0; i < [returnTypeName length]; i++)
    {
        if ([returnTypeName characterAtIndex:i] == ',') {
            break;
        }
    }
    returnTypeName = [returnTypeName substringToIndex:i];
    return returnTypeName;
}

- (NSString *)classNameWithoutProtocol:(NSString *)oldClassName {
    NSUInteger endIndex = oldClassName.length;
    for (NSUInteger index = 0; index < oldClassName.length; index++) {
        if ([oldClassName characterAtIndex:index] == '<') {
            endIndex = index;
            break;
        }
    }
    return [oldClassName substringToIndex:endIndex];
}

@end
