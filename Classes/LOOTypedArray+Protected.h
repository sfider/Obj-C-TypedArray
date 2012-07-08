//
//  LOOTypedArray+Protected.h
//
//  Created by Marcin Swiderski on 1/24/12.
//  Copyright (c) 2012 Marcin Swiderski. All rights reserved.
//
//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//  
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//  
//  1. The origin of this software must not be misrepresented; you must not
//     claim that you wrote the original software. If you use this software
//     in a product, an acknowledgment in the product documentation would be
//     appreciated but is not required.
//  2. Altered source versions must be plainly marked as such, and must not be
//     misrepresented as being the original software.
//  3. This notice may not be removed or altered from any source distribution.
//

#import "LOOTypedArray.h"

@interface LOOTypedArray (Protected)

@property (nonatomic, readonly) size_t sizeOfType;
@property (nonatomic, readonly, assign) void *data;

- (id)initWithSizeOfType:(size_t)sizeOfType;
- (id)initWithSizeOfType:(size_t)sizeOfType capacity:(NSUInteger)capacity;
- (id)initWithSizeOfType:(size_t)sizeOfType count:(NSUInteger)count;
- (id)initWithSizeOfType:(size_t)sizeOfType count:(NSUInteger)count valueAt:(const void *)value;

- (void)setCount:(NSUInteger)count valueAt:(const void *)value;

- (void)addValueAt:(const void *)value;

@end

#define LOO_TYPED_ARRAY_IMPLEMENTATION(__type) \
- (__type *)begin { \
  return (__type *)[self data]; \
} \
\
- (__type *)end { \
  return (__type *)[self data] + [self count]; \
} \
\
+ (id)arrayWithCount:(NSUInteger)count value:(__type)value { \
  return [[[[self class] alloc] initWithCount:count value:value] autorelease]; \
} \
\
- (id)init { \
  return self = [super initWithSizeOfType:sizeof(__type)]; \
} \
\
- (id)initWithCapacity:(NSUInteger)capacity { \
  return self = [super initWithSizeOfType:sizeof(__type) capacity:capacity]; \
} \
\
- (id)initWithCount:(NSUInteger)count { \
  return self = [super initWithSizeOfType:sizeof(__type) count:count]; \
} \
\
- (id)initWithCount:(NSUInteger)count value:(__type)value { \
  return self = [super initWithSizeOfType:sizeof(__type) count:count valueAt:&value]; \
} \
\
- (void)setCount:(NSUInteger)count value:(__type)value { \
  [super setCount:count valueAt:&value]; \
} \
\
- (void)addValue:(__type)value { \
  [super addValueAt:&value]; \
} \
\
- (__type)valueAtIndex:(NSInteger)index { \
  return [self begin][index]; \
} \
\
- (__type)lastValueOr:(__type)orValue { \
  return [self count] ? *([self end] - 1) : orValue; \
}
