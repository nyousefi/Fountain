//
//  FountainWriterTests.m
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

#import "FountainWriterTests.h"
#import "FNScript.h"
#import "FNElement.h"

@interface FountainWriterTests ()
@property (nonatomic, strong) FNScript *script;
@end


@implementation FountainWriterTests

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

// This is a horrible way to do a unit test. We're just reading the file, then
// seeing if we can print the exact same file out. Catching problems requires
// manually comparing the output to the original. DON'T WRITE TESTS LIKE THIS!
//
// (Says the jerk that wrote this test.)
//
- (void)testSimpleReadWrite
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:@"Simple" ofType:@"fountain"];
    [self.script loadFile:path];
    
    NSString *input = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSString *output = [self.script stringFromDocument];
    STAssertEqualObjects(output, input, @"Elements: %@", self.script.elements);
}

@end
