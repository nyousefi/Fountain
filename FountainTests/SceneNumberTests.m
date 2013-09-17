//
//  SceneNumberTests.m
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

#import "SceneNumberTests.h"
#import "FNElement.h"

@implementation SceneNumberTests

- (void)setUp
{
	[super setUp];
	[self loadTestFile:@"SceneNumbers"];
}

- (NSString *)sceneNumberForElementAtIndex:(NSUInteger)index
{
    FNElement *element = self.elements[index];
    return element.sceneNumber;
}

#pragma mark - Tests

- (void)testNumber
{
    NSUInteger index = 0;
    NSString *expectedText = @"1";
    
	STAssertEqualObjects([self elementTypeAtIndex:index], @"Scene Heading", [self errorForIndex:index]);
    STAssertEqualObjects([self elementTextAtIndex:index], @"INT. HOUSE - DAY ", [self errorForIndex:index]);
    STAssertEqualObjects([self sceneNumberForElementAtIndex:index], expectedText, [self errorForIndex:index]);
}

- (void)testNumberAndLetter
{
    NSUInteger index = 1;
    NSString *expectedText = @"1A";
    
	STAssertEqualObjects([self elementTypeAtIndex:index], @"Scene Heading", [self errorForIndex:index]);
    STAssertEqualObjects([self elementTextAtIndex:index], @"INT. HOUSE - DAY ", [self errorForIndex:index]);
    STAssertEqualObjects([self sceneNumberForElementAtIndex:index], expectedText, [self errorForIndex:index]);
}

- (void)testNumberAndLowercaseLetter
{
    NSUInteger index = 2;
    NSString *expectedText = @"1a";
    
	STAssertEqualObjects([self elementTypeAtIndex:index], @"Scene Heading", [self errorForIndex:index]);
    STAssertEqualObjects([self elementTextAtIndex:index], @"INT. HOUSE - DAY ", [self errorForIndex:index]);
    STAssertEqualObjects([self sceneNumberForElementAtIndex:index], expectedText, [self errorForIndex:index]);
}

- (void)testLetterAndNumber
{
    NSUInteger index = 3;
    NSString *expectedText = @"A1";
    
	STAssertEqualObjects([self elementTypeAtIndex:index], @"Scene Heading", [self errorForIndex:index]);
    STAssertEqualObjects([self elementTextAtIndex:index], @"INT. HOUSE - DAY ", [self errorForIndex:index]);
    STAssertEqualObjects([self sceneNumberForElementAtIndex:index], expectedText, [self errorForIndex:index]);
}

- (void)testDashes
{
    NSUInteger index = 4;
    NSString *expectedText = @"I-1-A";
    
	STAssertEqualObjects([self elementTypeAtIndex:index], @"Scene Heading", [self errorForIndex:index]);
    STAssertEqualObjects([self elementTextAtIndex:index], @"INT. HOUSE - DAY ", [self errorForIndex:index]);
    STAssertEqualObjects([self sceneNumberForElementAtIndex:index], expectedText, [self errorForIndex:index]);
}

- (void)testNumberWithPeriod
{
    NSUInteger index = 5;
    NSString *expectedText = @"1.";
    
	STAssertEqualObjects([self elementTypeAtIndex:index], @"Scene Heading", [self errorForIndex:index]);
    STAssertEqualObjects([self elementTextAtIndex:index], @"INT. HOUSE - DAY ", [self errorForIndex:index]);
    STAssertEqualObjects([self sceneNumberForElementAtIndex:index], expectedText, [self errorForIndex:index]);
}

- (void)testSceneHeaderWithExtraInfo
{
    NSUInteger index = 6;
    NSString *expectedText = @"110A";
    
	STAssertEqualObjects([self elementTypeAtIndex:index], @"Scene Heading", [self errorForIndex:index]);
    STAssertEqualObjects([self elementTextAtIndex:index], @"INT. HOUSE - DAY - FLASHBACK (1944) ", [self errorForIndex:index]);
    STAssertEqualObjects([self sceneNumberForElementAtIndex:index], expectedText, [self errorForIndex:index]);
}

@end
