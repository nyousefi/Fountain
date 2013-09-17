//
//  IndentingTests.m
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

#import "IndentingTests.h"

@implementation IndentingTests

- (void)setUp
{
	[super setUp];
	
	[self loadTestFile:@"Indenting"];
}

#pragma mark - Tests

- (void)testTransition
{
	NSUInteger index = 0;
	STAssertEqualObjects([self elementTypeAtIndex:index], @"Transition", [self errorForIndex:index]);
}

- (void)testCharacterCue
{
    NSUInteger index = 3;
	STAssertEqualObjects([self elementTypeAtIndex:index], @"Character", [self errorForIndex:index]);
}

- (void)testDialogue
{
    NSUInteger index = 4;
	STAssertEqualObjects([self elementTypeAtIndex:index], @"Dialogue", [self errorForIndex:index]);
}

- (void)testParenthetical
{
    NSUInteger index = 6;
	STAssertEqualObjects([self elementTypeAtIndex:index], @"Parenthetical", [self errorForIndex:index]);
}

@end
