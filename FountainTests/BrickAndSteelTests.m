//
//  BrickAndSteelTests.m
//
//  Copyright (c) 2012 Nima Yousefi & John August
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

#import "BrickAndSteelTests.h"
#import "FNScript.h"
#import "FNElement.h"

@interface BrickAndSteelTests ()
@property (nonatomic, retain) FNScript *script;
@end


@implementation BrickAndSteelTests

@synthesize script;

- (void)setUp
{
    [super setUp];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:@"Brick And Steel" ofType:@"txt"];
    script = [[FNScript alloc] initWithFile:path];
}

- (void)tearDown
{
    [script release];
    [super tearDown];
}

#pragma mark - Body tests

- (void)testScriptLoading
{
    STAssertNotNil(self.script, @"The script wasn't able to load.");
}

- (void)testSceneHeadings
{
    NSInteger indexes[] = {0, 23, 32, 40, 49, 55};
    NSInteger maxIndexes = sizeof(indexes)/sizeof(NSInteger);
    for (int i=0; i < maxIndexes; i++) {
        FNElement *element = [self.script.elements objectAtIndex:indexes[i]];
        STAssertEqualObjects(element.elementType, @"Scene Heading", @"Index %d: [%@] %@", indexes[i], element.elementType, element.elementText);
    }

}

- (void)testCharacters
{
    NSInteger indexes[] = {3, 5, 18, 20, 25};
    NSInteger maxIndexes = sizeof(indexes)/sizeof(NSInteger);
    for (int i=0; i < maxIndexes; i++) {
        FNElement *element = [self.script.elements objectAtIndex:indexes[i]];
        STAssertEqualObjects(element.elementType, @"Character", @"Index %d: [%@] %@", indexes[i], element.elementType, element.elementText);
    }
}

- (void)testDialogues
{
    NSInteger indexes[] = {4, 12, 27};
    NSInteger maxIndexes = sizeof(indexes)/sizeof(NSInteger);
    for (int i=0; i < maxIndexes; i++) {
        FNElement *element = [self.script.elements objectAtIndex:indexes[i]];
        STAssertEqualObjects(element.elementType, @"Dialogue", @"Index %d: [%@] %@", indexes[i], element.elementType, element.elementText);
    }
}

- (void)testParentheticals
{
    NSInteger indexes[] = {11, 26};
    NSInteger maxIndexes = sizeof(indexes)/sizeof(NSInteger);
    for (int i=0; i < maxIndexes; i++) {
        FNElement *element = [self.script.elements objectAtIndex:indexes[i]];
        STAssertEqualObjects(element.elementType, @"Parenthetical", @"Index %d: [%@] %@", indexes[i], element.elementType, element.elementText);
    }
}

- (void)testTransitions
{
    NSInteger indexes[] = {22, 31, 68, 77};
    NSInteger maxIndexes = sizeof(indexes)/sizeof(NSInteger);
    for (int i=0; i < maxIndexes; i++) {
        FNElement *element = [self.script.elements objectAtIndex:indexes[i]];
        STAssertEqualObjects(element.elementType, @"Transition", @"Index %d: [%@] %@", indexes[i], element.elementType, element.elementText);
    }
}

- (void)testActions
{
    NSInteger indexes[] = {1, 16, 30, 52};
    NSInteger maxIndexes = sizeof(indexes)/sizeof(NSInteger);
    for (int i=0; i < maxIndexes; i++) {
        FNElement *element = [self.script.elements objectAtIndex:indexes[i]];
        STAssertEqualObjects(element.elementType, @"Action", @"Index %d: [%@] %@", indexes[i], element.elementType, element.elementText);
    }
}

- (void)testCenteredElements
{
    NSInteger indexes[] = {50, 51};
    NSInteger maxIndexes = sizeof(indexes)/sizeof(NSInteger);
    for (int i=0; i < maxIndexes; i++) {
        FNElement *element = [self.script.elements objectAtIndex:indexes[i]];
        STAssertTrue(element.isCentered, @"Index %d: [%@] %@", indexes[i], element.elementType, element.elementText);
    }
}

- (void)testDualDialogue
{
    NSInteger indexes[] = {18, 20};
    NSInteger maxIndexes = sizeof(indexes)/sizeof(NSInteger);
    for (int i=0; i < maxIndexes; i++) {
        FNElement *element = [self.script.elements objectAtIndex:indexes[i]];
        STAssertTrue(element.isDualDialogue, @"Index %d: [%@] %@", indexes[i], element.elementType, element.elementText);
    }
}

- (void)testPreserveSpaces
{
    NSString *expectedString = @"	*Did you know Brick and Steel are retired?*";
    FNElement *element = [self.script.elements objectAtIndex:27];
    STAssertEqualObjects(element.elementText, expectedString, nil);
}

#pragma mark - Title page tests

- (void)testTitlePage
{
    NSInteger numberOfTitlePageElements = [self.script.titlePage count];
    NSInteger expectedNumberOfElements = 6;
    STAssertEquals(expectedNumberOfElements, numberOfTitlePageElements, nil);
}

- (void)testTitle
{
    NSArray *title = [[self.script.titlePage objectAtIndex:0] objectForKey:@"title"];
    NSInteger actualCount = [title count];
    NSInteger expectedCount = 2;
    STAssertEquals(actualCount, expectedCount, nil);
}


@end
