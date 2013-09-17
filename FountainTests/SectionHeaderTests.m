//
//  SectionHeaderTests.m
//  Fountain
//
//  Copyright (c) 2013 Nima Yousefi & John August
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//

#import "SectionHeaderTests.h"
#import "FNElement.h"

@implementation SectionHeaderTests

- (void)setUp
{
	[super setUp];
	[self loadTestFile:@"SectionHeaders"];
}

- (NSUInteger)sectionDepthOfElementAtIndex:(NSUInteger)index
{
	FNElement *element = self.elements[index];
	return element.sectionDepth;
}

#pragma mark - Tests

- (void)testSectionHeader
{
	NSUInteger index = 0;
	STAssertEqualObjects([self elementTypeAtIndex:index], @"Section Heading", [self errorForIndex:index]);
}

- (void)testNoSpaceBetweenHashAndHeader
{
	NSUInteger index = 1;
	STAssertEqualObjects([self elementTypeAtIndex:index], @"Section Heading", [self errorForIndex:index]);
}

- (void)testAllCapsNoSpace
{
	NSUInteger index = 2;
	STAssertEqualObjects([self elementTypeAtIndex:index], @"Section Heading", [self errorForIndex:index]);
}

- (void)testAllCaps
{
	NSUInteger index = 3;
	STAssertEqualObjects([self elementTypeAtIndex:index], @"Section Heading", [self errorForIndex:index]);
}

- (void)testNumberOnly
{
	NSUInteger index = 4;
	STAssertEqualObjects([self elementTypeAtIndex:index], @"Section Heading", [self errorForIndex:index]);
}

- (void)testSectionDepth
{
	NSUInteger index = 5;
	STAssertEqualObjects([self elementTypeAtIndex:index], @"Section Heading", [self errorForIndex:index]);
	STAssertEquals([self sectionDepthOfElementAtIndex:index], (NSUInteger)2, [self errorForIndex:index]);
	
	index = 6;
	STAssertEqualObjects([self elementTypeAtIndex:index], @"Section Heading", [self errorForIndex:index]);
	STAssertEquals([self sectionDepthOfElementAtIndex:index], (NSUInteger)3, [self errorForIndex:index]);
}

@end
