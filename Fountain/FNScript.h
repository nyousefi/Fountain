//
//  FNScript.h
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

#import <Foundation/Foundation.h>

@class FNElement;

typedef enum {
    FNParserTypeFast = 0,
    FNParserTypeRegexes = 1,
} FNParserType;

@interface FNScript : NSObject {
    NSString *filename;
    NSArray *elements;
    NSArray *titlePage;
    BOOL suppressSceneNumbers;
}

@property (nonatomic, copy) NSString *filename;
@property (nonatomic, retain) NSArray *elements;
@property (nonatomic, retain) NSArray *titlePage;
@property (nonatomic, assign) BOOL suppressSceneNumbers;

- (id)initWithFile:(NSString *)path;
- (id)initWithString:(NSString *)string;

- (void)loadFile:(NSString *)path;
- (void)loadString:(NSString *)string;

- (NSString *)stringFromDocument;
- (NSString *)stringFromTitlePage;
- (NSString *)stringFromBody;

- (BOOL)writeToFile:(NSString *)path;
- (BOOL)writeToURL:(NSURL *)url;

// These methods are here so you can use the old parser. You should move away from the old parser ASAP.
- (id)initWithFile:(NSString *)path parser:(FNParserType)parserType;
- (id)initWithString:(NSString *)string parser:(FNParserType)parserType;
- (void)loadFile:(NSString *)path parser:(FNParserType)parserType;
- (void)loadString:(NSString *)string parser:(FNParserType)parserType;

@end
