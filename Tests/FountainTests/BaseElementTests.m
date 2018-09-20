//
//  FTNParsingElementsTests.m
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

#import "BaseElementTests.h"
#import "FNElement.h"
#import "FastFountainParser.h"

@implementation BaseElementTests

- (void)setUp
{
	[super setUp];
}

- (void)tearDown
{
	[super tearDown];
}

#pragma mark - Helpers

- (NSString *)pathForFile:(NSString *)filename
{
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	NSString *filetype = @"fountain";
	NSString *path = [bundle pathForResource:filename ofType:filetype];
	
	return path;
}

- (void)loadTestFile:(NSString *)filename
{
	NSString *path = [self pathForFile:filename];
	FastFountainParser *parser = [[FastFountainParser alloc] initWithFile:path];
    self.elements = [parser.elements copy];
}

- (NSString *)elementTypeAtIndex:(NSUInteger)index
{
	FNElement *element = self.elements[index];
	return element.elementType;
}

- (NSString *)elementTextAtIndex:(NSUInteger)index
{
	FNElement *element = self.elements[index];
	return element.elementText;
}

- (NSString *)errorForIndex:(NSUInteger)index
{
	NSString *pattern = @"%@¶";
	NSString *description = [self.elements[index] description];
	return [NSString stringWithFormat:pattern, description];
}

@end
