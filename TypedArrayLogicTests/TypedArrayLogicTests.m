//
//  TypedArrayLogicTests.m
//  TypedArrayLogicTests
//
//  Created by Marcin Swiderski on 1/25/12.
//  Copyright (c) 2012 LoonyWare. All rights reserved.
//

#import "TypedArrayLogicTests.h"
#import "LOOTypedArray+Protected.h"
#import "LOOBoolArray.h"
#import "LOOCGPointArray.h"
#import "LOOCGRectArray.h"
#import "LOONSIntegerArray.h"
#import "LOOUInt16Array.h"

@implementation TypedArrayLogicTests

#define ARRAY_TEST(__arrayType, __valueType) \
do { \
  __arrayType *array = [[__arrayType alloc] init]; \
  STAssertEquals([array sizeOfType], sizeof(__valueType), @"Array sizeOfType should be equal to size of value type."); \
  STAssertEquals([array count], (NSUInteger)0, @"Array count after initialization should be 0."); \
  STAssertEquals([array begin] + [array count], [array end], @"Array end should point past the end of the array."); \
   \
  [array setCount:10]; \
  STAssertEquals([array count], (NSUInteger)10, @"Array count should be exactly as set."); \
  STAssertTrue([array count] <= [array capacity], @"Array count should be less or equal to it's capacity."); \
  STAssertEquals([array begin] + [array count], [array end], @"Array end should point past the end of the array."); \
  for (__valueType *i = [array begin], *il = [array end]; i != il; ++i) { \
    STAssertEquals(*i, (__valueType){0}, @"Uninitialized values created with setCount: should be zeroed (index: %d).", i - [array begin]); \
  } \
   \
  [array setCount:5 value:(__valueType){1}]; \
  STAssertEquals([array count], (NSUInteger)5, @"Array count should be exactly as set."); \
  STAssertTrue([array count] <= [array capacity], @"Array count should be less or equal to it's capacity."); \
  STAssertEquals([array begin] + [array count], [array end], @"Array end should point past the end of the array."); \
  for (__valueType *i = [array begin], *il = [array end]; i != il; ++i) { \
    STAssertEquals(*i, (__valueType){0}, @"setCount:value: should not change old values (index: %d).", i - [array begin]); \
  } \
   \
  [array setCount:15 value:(__valueType){1}]; \
  STAssertEquals([array count], (NSUInteger)15, @"Array count should be exactly as set."); \
  STAssertTrue([array count] <= [array capacity], @"Array count should be less or equal to it's capacity."); \
  STAssertEquals([array begin] + [array count], [array end], @"Array end should point past the end of the array."); \
  for (__valueType *i = [array begin], *il = [array begin] + 5; i != il; ++i) { \
    STAssertEquals(*i, (__valueType){0}, @"setCount:value: should not change old values (index: %d).", i - [array begin]); \
  } \
  for (__valueType *i = [array begin] + 5, *il = [array end]; i != il; ++i) { \
    STAssertEquals(*i, (__valueType){1}, @"setCount:value: should initialize new values with it's second argument (index: %d).", i - [array begin]); \
  } \
   \
  for (NSInteger i = 0; i != 5; ++i) { \
    [array removeLastValue]; \
  } \
  STAssertEquals([array count], (NSUInteger)10, @"Array count should be less by 5."); \
  STAssertTrue([array count] <= [array capacity], @"Array count should be less or equal to it's capacity."); \
  STAssertEquals([array begin] + [array count], [array end], @"Array end should point past the end of the array."); \
  for (__valueType *i = [array begin], *il = [array begin] + 5; i != il; ++i) { \
    STAssertEquals(*i, (__valueType){0}, @"removeLastValue should not change old values (index: %d).", i - [array begin]); \
  } \
  for (__valueType *i = [array begin] + 5, *il = [array end]; i != il; ++i) { \
    STAssertEquals(*i, (__valueType){1}, @"removeLastValue should not change old values (index: %d).", i - [array begin]); \
  } \
   \
  for (NSInteger i = 0; i != 10; ++i) { \
    [array addValue:(__valueType){0}]; \
  } \
  STAssertEquals([array count], (NSUInteger)20, @"Array count should be greater by 10."); \
  STAssertTrue([array count] <= [array capacity], @"Array count should be less or equal to it's capacity."); \
  STAssertEquals([array begin] + [array count], [array end], @"Array end should point past the end of the array."); \
  for (__valueType *i = [array begin], *il = [array begin] + 5; i != il; ++i) { \
    STAssertEquals(*i, (__valueType){0}, @"addValue: should not change old values (index: %d).", i - [array begin]); \
  } \
  for (__valueType *i = [array begin] + 5, *il = [array begin] + 10; i != il; ++i) { \
    STAssertEquals(*i, (__valueType){1}, @"addValue: should not change old values (index: %d).", i - [array begin]); \
  } \
  for (__valueType *i = [array begin] + 10, *il = [array end]; i != il; ++i) { \
    STAssertEquals(*i, (__valueType){0}, @"addValue: should set new values to its argument (index: %d).", i - [array begin]); \
  } \
   \
  [array release]; \
   \
  array = [[__arrayType alloc] initWithCount:8]; \
  STAssertEquals([array sizeOfType], sizeof(__valueType), @"Array sizeOfType should be equal to size of value type."); \
  STAssertEquals([array count], (NSUInteger)8, @"Array count after initialization should be 8."); \
  STAssertTrue([array count] <= [array capacity], @"Array count should be less or equal to it's capacity."); \
  STAssertEquals([array begin] + [array count], [array end], @"Array end should point past the end of the array."); \
  for (__valueType *i = [array begin], *il = [array end]; i != il; ++i) { \
    STAssertEquals(*i, (__valueType){0}, @"Uninitialized values created with initWithCount: should be zeroed (index: %d).", i - [array begin]); \
  } \
  [array release]; \
   \
  array = [[__arrayType alloc] initWithCount:8 value:(__valueType){1}]; \
  STAssertEquals([array sizeOfType], sizeof(__valueType), @"Array sizeOfType should be equal to size of value type."); \
  STAssertEquals([array count], (NSUInteger)8, @"Array count after initialization should be 8."); \
  STAssertTrue([array count] <= [array capacity], @"Array count should be less or equal to it's capacity."); \
  STAssertEquals([array begin] + [array count], [array end], @"Array end should point past the end of the array."); \
  for (__valueType *i = [array begin], *il = [array end]; i != il; ++i) { \
    STAssertEquals(*i, (__valueType){1}, @"initWithCount:value: should initialize new values with it's second argument (index: %d).", i - [array begin]); \
  } \
  [array release]; \
} while (NO)

- (void)testBoolArray {
  STAssertEquals(sizeof(BOOL), (size_t)1, @"This method should test array with 1 byte sized values.");
  ARRAY_TEST(LOOBoolArray, BOOL);
}

- (void)testUInt16Array {
  STAssertEquals(sizeof(uint16_t), (size_t)2, @"This method should test array with 2 bytes sized values.");
  ARRAY_TEST(LOOUInt16Array, uint16_t);
  
}

- (void)testUInt32Array {
  STAssertEquals(sizeof(NSInteger), (size_t)4, @"This method should test array with 4 bytes sized values.");
  ARRAY_TEST(LOONSIntegerArray, NSInteger);
}

- (void)testCGPointArray {
  STAssertEquals(sizeof(CGPoint), (size_t)8, @"This method should test array with 8 bytes sized values.");
  ARRAY_TEST(LOOCGPointArray, CGPoint);
}

- (void)testCGRectArray {
  STAssertEquals(sizeof(CGRect), (size_t)16, @"This method should test array with 16 bytes sized values.");
  ARRAY_TEST(LOOCGRectArray, CGRect);
}

@end
