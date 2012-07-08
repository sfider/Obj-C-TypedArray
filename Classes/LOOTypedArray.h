//
//  LOOTypedArray.h
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

#import <Foundation/Foundation.h>

@interface LOOTypedArray : NSObject

@property (nonatomic, assign) NSUInteger capacity;
@property (nonatomic, assign) NSUInteger count;

+ (id)array;
+ (id)arrayWithCapacity:(NSUInteger)capacity;
+ (id)arrayWithCount:(NSUInteger)count;

- (void)removeLastValue;
- (void)removeAllValues;

@end

@interface LOOTypedArray (Abstract)

- (id)init;
- (id)initWithCapacity:(NSUInteger)capacity;
- (id)initWithCount:(NSUInteger)count;

@end

#define LOO_TYPED_ARRAY_INTERFACE(__type) \
@property (nonatomic, readonly) __type *begin; \
@property (nonatomic, readonly) __type *end; \
 \
+ (id)arrayWithCount:(NSUInteger)count value:(__type)value; \
 \
- (id)initWithCount:(NSUInteger)count value:(__type)value; \
 \
- (void)setCount:(NSUInteger)count value:(__type)value; \
 \
- (void)addValue:(__type)value; \
 \
- (__type)valueAtIndex:(NSInteger)index; \
 \
- (__type)lastValueOr:(__type)orValue;
