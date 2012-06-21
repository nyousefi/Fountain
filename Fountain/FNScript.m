//
//  FNScript.m
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

#import "FNScript.h"
#import "FNElement.h"
#import "FountainParser.h"
#import "FountainWriter.h"

@implementation FNScript

@synthesize filename, elements, titlePage, suppressSceneNumbers;

- (id)initWithFile:(NSString *)path
{
    self = [self init];
    if (self) {
        [self loadFile:path];
    }
    return self;
}

- (id)initWithString:(NSString *)string
{
    self = [self init];
    if (self) {
        [self loadString:string];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.suppressSceneNumbers = NO;
    }    
    return self;
}

- (void)loadFile:(NSString *)path
{
    self.filename = [path lastPathComponent];
    self.elements = [FountainParser parseBodyOfFile:path];
    self.titlePage = [FountainParser parseTitlePageOfFile:path];
}

- (void)loadString:(NSString *)string
{
    self.filename = nil;
    self.elements = [FountainParser parseBodyOfString:string];
    self.titlePage = [FountainParser parseTitlePageOfString:string];
}

- (void)dealloc
{
    [filename release];
    [elements release];
    [titlePage release];
    [super dealloc];
}

- (NSString *)stringFromDocument
{
    return [FountainWriter documentFromScript:self];
}

- (NSString *)stringFromTitlePage
{
    return [FountainWriter titlePageFromScript:self];
}

- (NSString *)stringFromBody
{
    return [FountainWriter bodyFromScript:self];
}

- (BOOL)writeToFile:(NSString *)path
{
    // Get the document
    NSString *document = [FountainWriter documentFromScript:self];
    NSError *error = nil;
    BOOL success = [document writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (!success) {
        // Your error handling code goes here
    }
    return success;
}

- (BOOL)writeToURL:(NSURL *)url
{
    // Get the document
    NSString *document = [FountainWriter documentFromScript:self];
    NSError *error = nil;
    BOOL success = [document writeToURL:url atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (!success) {
        // Your error handling code goes here
    }
    return success;
}

- (NSString *)description
{
    return [FountainWriter documentFromScript:self];
}

@end
