//
//  NSObject+Creator.h
//  SpecHelpers
//
//  Created by Andrew J Wagner on 11/9/12.
//  Copyright (c) 2012 Drewag. All rights reserved.
//

@interface NSObject (Creator)

+ (id)instanceWithProperties:(NSDictionary *)dictionary;
- (id)initWithProperties:(NSDictionary *)dictionary;
- (id)updateWithProperties:(NSDictionary *)dictionary;

@end
