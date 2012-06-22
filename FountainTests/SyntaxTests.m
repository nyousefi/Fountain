//
//  SyntaxTests.m
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

#import "SyntaxTests.h"
#import "FNScript.h"
#import "FNElement.h"

@interface SyntaxTests ()
@property (nonatomic, retain) FNScript *script;
@end


@implementation SyntaxTests

@synthesize script;

- (void)setUp
{
    [super setUp];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:@"Simple" ofType:@"fountain"];
    script = [[FNScript alloc] initWithFile:path];
}

- (void)tearDown
{
    [script release];
    [super tearDown];
}

// Tests

- (void)testSceneHeadings
{
    NSInteger indexes[] = {1, 7};
    NSInteger maxIndexes = sizeof(indexes)/sizeof(NSInteger);
    for (int i=0; i < maxIndexes; i++) {
        FNElement *element = [self.script.elements objectAtIndex:indexes[i]];
        STAssertEqualObjects(element.elementType, @"Scene Heading", @"[%d] %@", indexes[i], [element description]);
    }
}

- (void)testTransitions
{
    NSInteger indexes[] = {9};
    NSInteger maxIndexes = sizeof(indexes)/sizeof(NSInteger);
    for (int i=0; i < maxIndexes; i++) {
        FNElement *element = [self.script.elements objectAtIndex:indexes[i]];
        STAssertEqualObjects(element.elementType, @"Transition", @"[%d] %@", indexes[i], [element description]);
    }
}

- (void)testForcedSceneHeadings
{
    FNElement *forcedSceneHeading = [self.script.elements objectAtIndex:18];
    STAssertEqualObjects(forcedSceneHeading.elementType, @"Scene Heading", @"[%d] %@", 18, [forcedSceneHeading description]);
    
    FNElement *notSceneHeading = [self.script.elements objectAtIndex:19];
    STAssertEqualObjects(notSceneHeading.elementType, @"Action", @"[%d] %@", 19, [notSceneHeading description]);
    
}

- (void)testSectionHeadings
{
    NSUInteger sectionOneIndex = 14;
    FNElement *sectionOne = [self.script.elements objectAtIndex:sectionOneIndex];
    STAssertEqualObjects(sectionOne.elementType, @"Section Heading", @"[%d] %@", sectionOneIndex, sectionOne.elementType);
    STAssertEquals((int)sectionOne.sectionDepth, 1, @"");
    STAssertEqualObjects(sectionOne.elementText, @" Section 1", @"[%d] %@", sectionOneIndex, sectionOne.elementText);
    
    NSUInteger sectionTwoIndex = 16;
    FNElement *sectionTwo = [self.script.elements objectAtIndex:sectionTwoIndex];
    STAssertEqualObjects(sectionTwo.elementType, @"Section Heading", @"[%d] %@", sectionTwoIndex, sectionTwo.elementType);
    STAssertEquals((int)sectionTwo.sectionDepth, 2, @"");
    STAssertEqualObjects(sectionTwo.elementText, @" Section 1-1", @"[%d] %@", sectionTwoIndex, sectionTwo.elementText);
}

- (void)testBoneyard
{
    NSUInteger index = 13;
    FNElement *element = [self.script.elements objectAtIndex:index];
    STAssertEqualObjects(element.elementType, @"Boneyard", @"[%d] %@", index, [element description]);
    STAssertEqualObjects(element.elementText, @"\nThis text is in the boneyard.\n", @"[%d] %@", index, [element description]);
}

- (void)testInLineBoneyard
{
    NSUInteger index = 20;
    FNElement *element = [self.script.elements objectAtIndex:index];
    STAssertEqualObjects(element.elementType, @"Boneyard", @"[%d] %@", index, [element description]);
    STAssertEqualObjects(element.elementText, @" Boneyard 2 ", @"[%d] %@", index, [element description]);
}

- (void)testSynopsis
{
    NSUInteger index = 12;
    FNElement *element = [self.script.elements objectAtIndex:index];
    STAssertEqualObjects(element.elementType, @"Synopsis", @"[%d] %@", index, [element description]);
    STAssertEqualObjects(element.elementText, @" Synopsis", @"[%d] %@", index, [element description]);
}

- (void)testComments
{
    NSUInteger index = 11;
    FNElement *element = [self.script.elements objectAtIndex:index];
    STAssertEqualObjects(element.elementType, @"Comment", @"[%d] %@", index, [element description]);
    STAssertEqualObjects(element.elementText, @"Comment", @"[%d] %@", index, [element description]);
}

- (void)testFalseSectionHeading
{
    NSUInteger index = 21;
    FNElement *element = [self.script.elements objectAtIndex:index];
    STAssertEqualObjects(element.elementType, @"Action", @"Index %d: [%@] %@", index, element.elementType);
    STAssertEqualObjects(element.elementText, @"Scott exasperatedly throws down the card on the table and picks up the phone, hitting speed dial #1...", @"Index %d: [%@] %@", index, element.elementText);
}

@end
