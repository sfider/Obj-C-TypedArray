//
//  LOOTypedArray.m
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
#import "LOOTypedArray+Protected.h"

@interface LOOTypedArray ()

@property (nonatomic, readonly) size_t sizeOfType;
@property (nonatomic, assign) void *data;

@end

@implementation LOOTypedArray

@synthesize sizeOfType = _sizeOfType;
@synthesize capacity = _capacity;
@synthesize count = _count;
@synthesize data = _data;

+ (id)array {
  return [[[[self class] alloc] init] autorelease];
}

+ (id)arrayWithCapacity:(NSUInteger)capacity {
  return [[[[self class] alloc] initWithCapacity:capacity] autorelease];
}

+ (id)arrayWithCount:(NSUInteger)count {
  return [[[[self class] alloc] initWithCount:count] autorelease];
}

- (id)initWithSizeOfType:(size_t)sizeOfType {
  return [self initWithSizeOfType:sizeOfType capacity:8];
}

- (id)initWithSizeOfType:(size_t)sizeOfType capacity:(NSUInteger)capacity {
  self = [super init];
  if (self) {
    _sizeOfType = sizeOfType;
    _capacity = capacity;
    _count = 0;
    _data = malloc(_capacity * _sizeOfType);
  }
  return self;
}

- (id)initWithSizeOfType:(size_t)sizeOfType count:(NSUInteger)count {
  self = [self initWithSizeOfType:sizeOfType capacity:count];
  if (self) {
    [self setCount:count];
  }
  return self;
}

- (id)initWithSizeOfType:(size_t)sizeOfType count:(NSUInteger)count valueAt:(const void *)value {
  self = [self initWithSizeOfType:sizeOfType capacity:count];
  if (self) {
    [self setCount:count valueAt:value];
  }
  return self;
}

- (void)dealloc {
  free(_data);
#if !__has_feature(objc_arc)
  [super dealloc];
#endif
}

- (void)setCapacity:(NSUInteger)capacity {
  NSAssert(capacity >= _count, @"Cannot set capacity less then the count of the array.");
  _capacity = capacity;
  void *newData = malloc(_capacity * _sizeOfType);
  memcpy(newData, _data, _count * _sizeOfType);
  free(_data);
  _data = newData;
}

- (void)setCount:(NSUInteger)count {
  if (count > _capacity) {
    [self setCapacity:count];
  }
  if (count > _count) {
    bzero(_data + _count * _sizeOfType, (count - _count) * _sizeOfType);
  }
  _count = count;
}

- (void)setCount:(NSUInteger)count valueAt:(const void *)value {
  if (count > _capacity) {
    [self setCapacity:count];
  }
  if (count > _count) {
    switch (_sizeOfType) {
    case 1: memset(_data + _count, *(unsigned char *)value, count - _count); break;
    case 4: memset_pattern4(_data + _count * 4, value, (count - _count) * 4); break;
    case 8: memset_pattern8(_data + _count * 8, value, (count - _count) * 8); break;
    case 16: memset_pattern16(_data + _count * 16, value, (count - _count) * 16); break;
    default:
      for (void *p = _data + _count * _sizeOfType, *pl = _data + count * _sizeOfType; p != pl; p += _sizeOfType) {
        memcpy(p, value, _sizeOfType);
      }
    }
  }
  _count = count;
}

- (void)addValueAt:(const void *)value {
  if (_count == _capacity) {
    [self setCapacity:(_capacity * 2)];
  }
  memcpy(_data + _count * _sizeOfType, value, _sizeOfType);
  ++_count;
}

- (void)removeLastValue {
  NSAssert(_count != 0, @"Tried to remove value from empty array.");
  --_count;
}

- (void)removeAllValues {
  [self setCount:0];
}

@end
