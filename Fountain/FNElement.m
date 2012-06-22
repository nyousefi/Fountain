//
//  FNElement.m
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

#import "FNElement.h"

@interface FNElement ()
@end


@implementation FNElement

@synthesize elementType, elementText, isCentered, sceneNumber, isDualDialogue, sectionDepth;

- (id)init
{
    self = [super init];
    if (self) {
        // defaults
        isDualDialogue = NO;
        isCentered = NO;
        sceneNumber = nil;
        sectionDepth = 0;
    }    
    return self;
}

- (void)dealloc
{
    [elementType release];
    [elementText release];
    [sceneNumber release];
    [super dealloc];
}

- (NSString *)description
{
    NSString *textOutput = self.elementText;
    NSMutableString *typeOutput = [NSMutableString stringWithFormat:self.elementType];
    
    if (self.isCentered) {
        [typeOutput appendString:@" (centered)"];
    }
    else if (self.isDualDialogue) {
        [typeOutput appendString:@" (dual dialogue)"];
    }
    else if (self.sectionDepth) {
        [typeOutput appendFormat:@" (%d)", self.sectionDepth];
    }
    
    return [NSString stringWithFormat:@"%@: %@", typeOutput, textOutput];
}

// Convenience class method
+ (FNElement *)elementOfType:(NSString *)elementType text:(NSString *)elementText
{
    FNElement *element = [[FNElement alloc] init];
    element.elementType = elementType;
    element.elementText = elementText;
    return [element autorelease];
}


@end
