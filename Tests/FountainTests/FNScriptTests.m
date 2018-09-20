//
//  FNScriptTests.m
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

#import "FNScriptTests.h"
#import "FNScript.h"
#import "FNElement.h"

@interface FNScriptTests ()
@property (nonatomic, strong) FNScript *script;
@end

@implementation FNScriptTests

@synthesize script;

- (void)setUp
{
    [super setUp];
    script = [[FNScript alloc] init];
}

- (void)tearDown
{
    [super tearDown];
}

#pragma mark - Tests

- (void)testInitFromString
{
    NSString *string = @"FADE IN:";
    FNScript *testScript = [[FNScript alloc] initWithString:string];
    STAssertNotNil(testScript, @"Script did not init with this string: %@", string);
}

- (void)testLoadFile
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:@"Big Fish" ofType:@"fountain"];
    [script loadFile:path];
    STAssertNotNil(script, @"Script did not load the file: %@", path);
}

- (void)testLoadString
{
    NSString *string = @"FADE IN:";
    [script loadString:string];
    STAssertNotNil(script, @"Script did not load the string: %@", string);
}

- (void)testStringFromTitlePage
{
    NSString *expectedString = @"Title: A Simple Script\nAuthor: Nima Yousefi\nDraft date: 2/1/2012\n";
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:@"Simple" ofType:@"fountain"];
    [script loadFile:path];
    STAssertEqualObjects(expectedString, [script stringFromTitlePage], nil);
}

- (void)testElementDescription
{
    NSString *string = @"FADE IN:\n\nINT. HOUSE - DAY\n\nMAN\nI'm in the house.\n\n> The end. <";
    [script loadString:string];
    NSArray *elements = script.elements;
    
    NSString *actualString;
    NSString *expectedString;
    
    // You need to call -description in order for the tests to work. If you omit the -description the tests will fail,
    // but the output will appear to be correct. I'm guessing this is because of how STAssertEqualObjects is doing the
    // checking. I don't care enough to investigate further.
    actualString = [elements[0] description];
    expectedString = @"Action: FADE IN:";
    STAssertEqualObjects(actualString, expectedString, nil);
    
    actualString = [elements[1] description];
    expectedString = @"Scene Heading: INT. HOUSE - DAY";
    STAssertEqualObjects(actualString, expectedString, nil);

    actualString = [elements[2] description];
    expectedString = @"Character: MAN";
    STAssertEqualObjects(actualString, expectedString, nil);

    actualString = [elements[3] description];
    expectedString = @"Dialogue: I'm in the house.";
    STAssertEqualObjects(actualString, expectedString, nil);

    actualString = [elements[4] description];
    expectedString = @"Action (centered): The end.";
    STAssertEqualObjects(actualString, expectedString, nil);
}

- (void)testScriptDescription
{
    NSString *string = @"FADE IN:\n\nINT. HOUSE - DAY\n\nMAN\nI'm in the house.\n\n> The end. <";
    [script loadString:string];
    
    // You need to call -description in order for the tests to work. If you omit the -description the tests will fail,
    // but the output will appear to be correct. I'm guessing this is because of how STAssertEqualObjects is doing the
    // checking. I don't care enough to investigate further.
    NSString *actualString = [script description];
    NSString *expectedString = string;
    STAssertEqualObjects(actualString, expectedString, nil);
}

- (void)testTitlesWithoutColons
{
    NSString *string = @"Title:\n\tI KNOW WHAT YOU DID\n\tLAST SUMMER";
    [script loadString:string];
    
    // You need to call -description in order for the tests to work. If you omit the -description the tests will fail,
    // but the output will appear to be correct. I'm guessing this is because of how STAssertEqualObjects is doing the
    // checking. I don't care enough to investigate further.
    NSString *actualString = [script description];
    NSString *expectedString = string;
    STAssertEqualObjects(actualString, expectedString, nil);
}

- (void)testTitlesWithColons
{
    NSString *string = @"Title:\n\tI KNOW WHAT YOU DID:\n\tLAST SUMMER";
    [script loadString:string];
    
    // You need to call -description in order for the tests to work. If you omit the -description the tests will fail,
    // but the output will appear to be correct. I'm guessing this is because of how STAssertEqualObjects is doing the
    // checking. I don't care enough to investigate further.
    NSString *actualString = [script description];
    NSString *expectedString = string;
    STAssertEqualObjects(actualString, expectedString, nil);
}

@end
