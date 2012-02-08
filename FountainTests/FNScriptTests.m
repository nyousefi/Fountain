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
@property (nonatomic, retain) FNScript *script;
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
    [script release];
    [super tearDown];
}

#pragma mark - Tests

- (void)testInitFromString
{
    NSString *string = @"FADE IN:";
    FNScript *testScript = [[FNScript alloc] initWithString:string];
    STAssertNotNil(testScript, @"Script did not init with this string: %@", string);
    [testScript release];
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


@end
