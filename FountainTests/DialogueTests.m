//
//  DialogueTests.m
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

#import "DialogueTests.h"
#import "FNElement.h"

@implementation DialogueTests

- (void)setUp
{
	[super setUp];
	[self loadTestFile:@"Dialogue"];
}

#pragma mark - Tests
#pragma mark Character Cues

- (void)testCharacterCue
{
	NSUInteger index = 0;
	STAssertEqualObjects([self elementTypeAtIndex:index], @"Character", [self errorForIndex:index]);
}

- (void)testCueWithParenthetical
{
	NSUInteger index = 2;
	STAssertEqualObjects([self elementTypeAtIndex:index], @"Character", [self errorForIndex:index]);
}

- (void)testCueWithLowercaseContd
{
	NSUInteger index = 9;
	STAssertEqualObjects([self elementTypeAtIndex:index], @"Character", [self errorForIndex:index]);
}

- (void)testCharacterCueWithNumbers
{
	NSUInteger index = 20;
	STAssertEqualObjects([self elementTypeAtIndex:index], @"Character", [self errorForIndex:index]);
}

- (void)testCueCannotBeALLNumerical
{
	NSUInteger index = 23;
	STAssertEqualObjects([self elementTypeAtIndex:index], @"Character", [self errorForIndex:index]);
}

- (void)testCueCanBeIndented
{
	NSUInteger index = 27;
	STAssertEqualObjects([self elementTypeAtIndex:index], @"Character", [self errorForIndex:index]);
}


#pragma mark Dual dialogue

- (void)testCueWithCaret
{
	NSUInteger index = 18;
	STAssertEqualObjects([self elementTypeAtIndex:index], @"Character", [self errorForIndex:index]);
}

- (void)testMatchingDualDialogue
{
	NSUInteger index = 16;
	STAssertEqualObjects([self elementTypeAtIndex:index], @"Character", [self errorForIndex:index]);
}

- (void)testRemovalOfCaretMarkup
{
	NSUInteger index = 18;
	NSString *expected = @"EVE";
	STAssertEqualObjects([self elementTextAtIndex:index], expected, [self errorForIndex:index]);
}


#pragma mark Parentheticals

- (void)testParenthetical
{
	NSUInteger index = 5;
	STAssertEqualObjects([self elementTypeAtIndex:index], @"Parenthetical", [self errorForIndex:index]);
}

- (void)testParentheticalAtEndOfBlock
{
	NSUInteger index = 15;
	STAssertEqualObjects([self elementTypeAtIndex:index], @"Parenthetical", [self errorForIndex:index]);
}

- (void)testParentheticalCanBeIndent
{
	NSUInteger index = 28;
	STAssertEqualObjects([self elementTypeAtIndex:index], @"Parenthetical", [self errorForIndex:index]);
}

#pragma mark Dialogue

- (void)testDialogue
{
	NSUInteger index = 1;
	STAssertEqualObjects([self elementTypeAtIndex:index], @"Dialogue", [self errorForIndex:index]);
}

- (void)testDialogueWithLineBreaks
{
	NSUInteger index = 12;
	STAssertEqualObjects([self elementTypeAtIndex:index], @"Dialogue", [self errorForIndex:index]);
}

- (void)testDialogueAllCaps
{
	NSUInteger index = 8;
	STAssertEqualObjects([self elementTypeAtIndex:index], @"Dialogue", [self errorForIndex:index]);
}

- (void)testDialogueWithEmptyLineInTheMiddle
{
	NSUInteger index = 26;
	STAssertEqualObjects([self elementTypeAtIndex:index], @"Dialogue", [self errorForIndex:index]);
}

- (void)testDialogueCanBeIndented
{
	NSUInteger index = 29;
	STAssertEqualObjects([self elementTypeAtIndex:index], @"Dialogue", [self errorForIndex:index]);
}

@end
