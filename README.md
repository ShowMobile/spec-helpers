spec-helpers
============

Collection of classes to help with spec writing

Features
============

Animation Testing
-----------------
**UIView+ViewAnimationTesting.h**

Allows you to wrap code in a block that executes animations immediately. This is useful for when you have code
in an onComplete of an animation that you would like to spec.

Test Object Factory
-------------------
**NSObject+Creator.h**

Sometimes you need a domain object for testing but you don't want to use the real initialization because it is
out of the scope of the text. This NSObject extentsion lets you initialize an object with a dictionary instead.
You simply call `createWithProperties:` on an allocated instance of your class.

An example would be:
    [[MyObject alloc] createWithProperties:@{
        @"stringProperty": @"A String",
        @"dictionaryProperty": @{},
        @"arrayProperty": @[],
        @numberProperty": @72,
        @"objectOfAnyClassProperty": @{
            @"stringProperty": @"Another String",
        },
    }];

The class of "objectOfAnyClassProperty" will be determined from the MyObject class. It will then alloc an object
and apply the same `createWithProperties:` method with the given dictionary.

Class Meta Programming Helpers
------------------------------
**ClassHelpers.h**

I like to write global specs sometimes that test all of my classes in a generic way. This collection of methods
allows you to iterate through all classes with a given prefix and also iterate through the properties of a class.
It also provides a method to see if a property is writable.
