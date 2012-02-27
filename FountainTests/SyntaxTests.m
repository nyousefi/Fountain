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
        STAssertEqualObjects(element.elementType, @"Scene Heading", @"Index %d: [%@] %@", indexes[i], element.elementType, element.elementText);
    }
}

- (void)testTransitions
{
    NSInteger indexes[] = {9};
    NSInteger maxIndexes = sizeof(indexes)/sizeof(NSInteger);
    for (int i=0; i < maxIndexes; i++) {
        FNElement *element = [self.script.elements objectAtIndex:indexes[i]];
        STAssertEqualObjects(element.elementType, @"Transition", @"Index %d: [%@] %@", indexes[i], element.elementType, element.elementText);
    }
}

- (void)testForcedSceneHeadings
{
    FNElement *forcedSceneHeading = [self.script.elements objectAtIndex:18];
    STAssertEqualObjects(forcedSceneHeading.elementType, @"Scene Heading", @"Index %d: [%@] %@", 18, forcedSceneHeading.elementType, forcedSceneHeading.elementText);
    
    FNElement *notSceneHeading = [self.script.elements objectAtIndex:19];
    STAssertEqualObjects(notSceneHeading.elementType, @"Action", @"Index %d: [%@] %@", 19, notSceneHeading.elementType, notSceneHeading.elementText);

}

@end
