
Pod::Spec.new do |s|
  s.name         = "spec-helpers"
  s.version      = "0.0.1"
  s.summary      = "Collection of classes to help with spec writing"

  s.description  = <<-DESC
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
                   DESC

  s.homepage     = "https://github.com/ShowMobile/spec-helpers"
  s.license      = "MIT"
  s.author             = { "Spencer Comerford" => "Spencer.Comerford@ShowMobile.com" }
  s.source       = { :git => "https://github.com/ShowMobile/spec-helpers.git", :tag => '0.0.1' }
  s.platform = :ios
  s.source_files  = "SpecHelpers", "SpecHelpers/*.{h,m}", "SpecHelpers/**/*.{h,m}"
  s.public_header_files = "SpecHelpers/*.h"
  s.requires_arc = false
  s.frameworks = 'Foundation'

end
