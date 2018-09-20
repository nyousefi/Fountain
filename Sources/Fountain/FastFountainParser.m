//
//  FastFountainParser.m
//
//  Copyright (c) 2012-2013 Nima Yousefi & John August
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

#import "FastFountainParser.h"
#import "FNElement.h"
#import "RegexKitLite.h"

static NSString * const kInlinePattern = @"^([^\\t\\s][^:]+):\\s*([^\\t\\s].*$)";
static NSString * const kDirectivePattern = @"^([^\\t\\s][^:]+):([\\t\\s]*$)";
static NSString * const kContentPattern = @"";

@interface FastFountainParser ()

@end

@implementation FastFountainParser

- (id)initWithString:(NSString *)string
{
    self = [super init];
    if (self) {
        _elements = [[NSMutableArray alloc] init];
        _titlePage = [[NSMutableArray alloc] init];
        [self parseContents:string];
    }
    return self;
}

- (id)initWithFile:(NSString *)filePath
{
    self = [super init];
    if (self) {
        _elements = [[NSMutableArray alloc] init];
        _titlePage = [[NSMutableArray alloc] init];
        
        NSError *error = nil;
        NSString *contents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
        if (error) {
            NSLog(@"Couldn't read the file %@", filePath);
            return self;
        }
        [self parseContents:contents];
    }
    return self;
}

- (void)parseContents:(NSString *)contents
{
    // Trim leading newlines from the document
    contents = [contents stringByReplacingOccurrencesOfRegex:@"^\\s*" withString:@""];
    contents = [contents stringByReplacingOccurrencesOfRegex:@"\\r\\n|\\r|\\n" withString:@"\n"];
    contents = [NSString stringWithFormat:@"%@\n\n", contents];
    
    // Find the first newline
    NSRange firstBlankLineRange = [contents rangeOfString:@"\n\n"];
    NSString *topOfDocument = [contents substringToIndex:firstBlankLineRange.location];
    
    // ----------------------------------------------------------------------
    // TITLE PAGE
    // ----------------------------------------------------------------------
    // Is the stuff at the top of the document the title page?
    BOOL foundTitlePage = NO;
    NSString *openKey = @"";
    NSMutableArray *openValues = [NSMutableArray array];
    NSArray *topLines = [topOfDocument componentsSeparatedByString:@"\n"];
    
    for (NSString *line in topLines) {
        if ([line isEqualToString:@""] || [line isMatchedByRegex:kDirectivePattern]) {
            foundTitlePage = YES;
            // If a key was open we want to close it
            if (![openKey isEqualToString:@""]) {
                NSDictionary *dict = @{openKey: openValues};
                [self.titlePage addObject:dict];
            }
            
            openKey = [[line stringByMatching:kDirectivePattern capture:1] lowercaseString];
            if ([openKey isEqualToString:@"author"]) {
                openKey = @"authors";
            }
        }
        else if ([line isMatchedByRegex:kInlinePattern]) {
            foundTitlePage = YES;
            // If a key was open we want to close it
            if (![openKey isEqualToString:@""]) {
                NSDictionary *dict = @{openKey: openValues};
                [self.titlePage addObject:dict];
                openKey = @"";
                openValues = [NSMutableArray array];
            }
            
            NSString *key = [[line stringByMatching:kInlinePattern capture:1] lowercaseString];
            NSString *value = [line stringByMatching:kInlinePattern capture:2];
            
            if ([key isEqualToString:@"author"]) {
                key = @"authors";
            }
            
            NSDictionary *dict = @{key: @[value]};
            [self.titlePage addObject:dict];
            openKey = @"";
            openValues = [NSMutableArray array];
        }
        else if (foundTitlePage) {
            [openValues addObject:[line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
        }
    }
    
    if (foundTitlePage) {
        if (![openKey isEqualToString:@""] && [openValues count] == 0 && [self.titlePage count] == 0) {
            // do nothing
        }
        else {
            // Close any remaining directives
            if (![openKey isEqualToString:@""]) {
                NSDictionary *dict = @{openKey: openValues};
                [self.titlePage addObject:dict];
                openKey = @"";
                openValues = [NSMutableArray array];
            }
            contents = [contents stringByReplacingOccurrencesOfString:topOfDocument withString:@""];
        }
    }
    
    // ----------------------------------------------------------------------
    // BODY
    // ----------------------------------------------------------------------
    // Contents by line
    contents = [NSString stringWithFormat:@"\n%@", contents];
    NSArray *lines = [contents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    NSUInteger newlinesBefore = 0;
    NSUInteger index = -1;
    BOOL isCommentBlock = NO;
    BOOL isInsideDialogueBlock = NO;
    NSMutableString *commentText = [NSMutableString string];
    for (NSString *line in lines) {
        index++;
        
        // If the line starts with a tilde and the previous element was a
		// lyric element, then we keep making lyrics.
		if ([line length] > 0 && [line characterAtIndex:0] == '~') {
            
            FNElement *lastElement = [self.elements lastObject];
			
            if (!lastElement) {
                FNElement *element = [FNElement elementOfType:@"Lyrics" text:line];
                [self.elements addObject:element];
                newlinesBefore = 0;
                continue;
            }
			
			if ([lastElement.elementType isEqualToString:@"Lyrics"] && newlinesBefore > 0) {
                FNElement *element = [FNElement elementOfType:@"Lyrics" text:@" "];
                [self.elements addObject:element];
            }
            
            FNElement *element = [FNElement elementOfType:@"Lyrics" text:line];
            [self.elements addObject:element];
            newlinesBefore = 0;
            continue;
		}
        
        if ([line length] > 0 && [line characterAtIndex:0] == '!') {
            FNElement *element = [FNElement elementOfType:@"Action" text:line];
            [self.elements addObject:element];
            newlinesBefore = 0;
            continue;
		}
        
        if ([line length] > 0 && [line characterAtIndex:0] == '@') {
            FNElement *element = [FNElement elementOfType:@"Character" text:line];
            [self.elements addObject:element];
            newlinesBefore = 0;
            isInsideDialogueBlock = YES;
            continue;
		}
        
		
        // Need to check for "empty" lines within dialogue -- denoted by two spaces inside a dialogue block
        if (([line isMatchedByRegex:@"^\\s{2}$"]) && isInsideDialogueBlock) {
            newlinesBefore = 0;
            // Check to see if the previous element was a dialogue
            NSUInteger lastIndex = [self.elements count] - 1;
            FNElement *previousElement = (self.elements)[lastIndex];
            
            if ([previousElement.elementType isEqualToString:@"Dialogue"]) {
                NSString *text = [NSString stringWithFormat:@"%@\n%@", previousElement.elementText, line];
                previousElement.elementText = text;
                [self.elements removeObjectAtIndex:lastIndex];
                [self.elements addObject:previousElement];
            }
            else {
                FNElement *element = [FNElement elementOfType:@"Dialogue" text:line];
                [self.elements addObject:element];
            }
            continue;
        }
        
        if (([line isMatchedByRegex:@"^\\s{2,}$"])) {
            FNElement *element = [FNElement elementOfType:@"Action" text:line];
            [self.elements addObject:element];
            newlinesBefore = 0;
            continue;
        }

        // Blank line.
        if (([line isEqualToString:@""]) && !isCommentBlock) {
            isInsideDialogueBlock = NO;
            newlinesBefore++;
            continue;
        }
        
        // Open Boneyard            
        if ([line isMatchedByRegex:@"^\\/\\*"]) {
            if ([line isMatchedByRegex:@"\\*\\/\\s*$"]) {
                NSString *text = [[line stringByReplacingOccurrencesOfString:@"/*" withString:@""] stringByReplacingOccurrencesOfString:@"*/" withString:@""];
                isCommentBlock = NO;
                FNElement *element = [FNElement elementOfType:@"Boneyard" text:text];
                [self.elements addObject:element];
                newlinesBefore = 0;
            }
            else {
                isCommentBlock = YES;
                [commentText appendString:@"\n"];
            }
            continue;
        }
        
        // Close Boneyard
        if ([line isMatchedByRegex:@"\\*\\/\\s*$"]) {
            NSString *text = [line stringByReplacingOccurrencesOfString:@"*/" withString:@""];
            if (!text || [text isMatchedByRegex:@"^\\s*$"]) {
                [commentText appendString:[text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
            }
            isCommentBlock = NO;
            FNElement *element = [FNElement elementOfType:@"Boneyard" text:commentText];
            [self.elements addObject:element];
            commentText = [NSMutableString string];
            newlinesBefore = 0;
            continue;
        }
        
        // Inside the Boneyard
        if (isCommentBlock) {
            [commentText appendString:line];
            [commentText appendString:@"\n"];
            continue;
        }
        
        // Page Breaks -- three or more '=' signs
        if ([line isMatchedByRegex:@"^={3,}\\s*$"]) {
            FNElement *element = [FNElement elementOfType:@"Page Break" text:line];
            [self.elements addObject:element];
            newlinesBefore = 0;
            continue;
        }
        
        // Synopsis -- a single '=' at the start of the line
        if ([[line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] > 0 && [[line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] characterAtIndex:0] == '=') {
            NSRange markupRange = [line rangeOfRegex:@"^\\s*={1}"];
            NSString *text = [line stringByReplacingCharactersInRange:markupRange withString:@""];
            FNElement *element = [FNElement elementOfType:@"Synopsis" text:text];
            [self.elements addObject:element];
            continue;
        }
        
        // Comment -- double brackets [[Comment]]
        if (newlinesBefore > 0 && [line isMatchedByRegex:@"^\\s*\\[{2}\\s*([^\\]\\n])+\\s*\\]{2}\\s*$"]) {
            NSString *text = [[[line stringByReplacingOccurrencesOfString:@"[[" withString:@""] stringByReplacingOccurrencesOfString:@"]]" withString:@""] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            FNElement *element = [FNElement elementOfType:@"Comment" text:text];
            [self.elements addObject:element];
            continue;
        }
        
        // Section heading -- one or more '#' at the start of the line, the number of chars == the section depth
        if ([[line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] > 0 && [[line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] characterAtIndex:0] == '#') {
            newlinesBefore = 0;
            
            // Get the depth of the section
            NSRange markupRange = [line rangeOfRegex:@"^\\s*#+"];
            NSUInteger depth = markupRange.length;
            
            // Cleanse the line
            NSString *text = [line substringFromIndex:(markupRange.location + markupRange.length)];
            if (!text || [text isEqualToString:@""]) {
                NSLog(@"Error in the Section Heading");
                continue;
            }
            
            FNElement *element = [FNElement elementOfType:@"Section Heading" text:text];
            element.sectionDepth = depth;
            [self.elements addObject:element];
            continue;
        }
        
        // Forced scene heading -- look for a single '.' at the start of a line
        if ([line length] > 1 && [line characterAtIndex:0] == '.' && [line characterAtIndex:1] != '.') {
            newlinesBefore = 0;
            NSString *sceneNumber = nil;
            NSString *text = nil;
            // Check for scene numbers
            if ([line isMatchedByRegex:@"#([^\\n#]*?)#\\s*$"]) {
                sceneNumber = [line stringByMatching:@"#([^\\n#]*?)#\\s*$" capture:1];
                text = [line stringByReplacingOccurrencesOfRegex:@"#([^\\n#]*?)#\\s*$" withString:@""];
                text = [[text substringFromIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            }
            else {
                text = [[line substringFromIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            }
            
            FNElement *element = [FNElement elementOfType:@"Scene Heading" text:text];  
            if (sceneNumber) {
                element.sceneNumber = sceneNumber;
            }
            [self.elements addObject:element];
            continue;
        }
        
        // Scene Headings
        if (newlinesBefore > 0 && [line isMatchedByRegex:@"^(INT|EXT|EST|(I|INT)\\.?\\/(E|EXT)\\.?)[\\.\\-\\s][^\\n]+$" options:RKLCaseless inRange:NSMakeRange(0, line.length) error:nil]) {
            newlinesBefore = 0;
            NSString *sceneNumber = nil;
            NSString *text = nil;
            // Check for scene numbers
            if ([line isMatchedByRegex:@"#([^\\n#]*?)#\\s*$"]) {
                sceneNumber = [line stringByMatching:@"#([^\\n#]*?)#\\s*$" capture:1];
                text = [line stringByReplacingOccurrencesOfRegex:@"#([^\\n#]*?)#\\s*$" withString:@""];
            }
            else {
                text = line;
            }
            
            FNElement *element = [FNElement elementOfType:@"Scene Heading" text:text];
            if (sceneNumber) {
                element.sceneNumber = sceneNumber;
            }
            [self.elements addObject:element];
            continue;
        }
        
        // Transitions
        // We need to trim leading whitespace from the line because whitespace at the end of the line
        // nullifies Transitions.
        if ([line isMatchedByRegex:@"[^a-z]*TO:$"]) {
            newlinesBefore = 0;
            FNElement *element = [FNElement elementOfType:@"Transition" text:line];
            [self.elements addObject:element];
            continue;
        }
        
        NSString *lineWithTrimmedLeading = [line stringByReplacingOccurrencesOfRegex:@"^\\s*" withString:@""];
        NSSet *transitions = [NSSet setWithArray:@[@"FADE OUT.", @"CUT TO BLACK.", @"FADE TO BLACK."]];
        if ([transitions containsObject:lineWithTrimmedLeading]) {
            newlinesBefore = 0;
            FNElement *element = [FNElement elementOfType:@"Transition" text:line];
            [self.elements addObject:element];
            continue;
        }
        
        // Forced transitions
        if ([line characterAtIndex:0] == '>') {
            if (line.length > 1 && [line characterAtIndex:(line.length - 1)] == '<') {
                // Remove the extra characters
                NSString *text = [[line substringFromIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                text = [[text substringToIndex:(text.length - 1)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

                FNElement *element = [FNElement elementOfType:@"Action" text:text];
                element.isCentered = YES;
                [self.elements addObject:element];
                newlinesBefore = 0;
                continue;
            }
            else {
                NSString *text = [[line substringFromIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                FNElement *element = [FNElement elementOfType:@"Transition" text:text];
                [self.elements addObject:element];
                newlinesBefore = 0;
                continue;
            }
        }
        
        // Character
        if (newlinesBefore > 0 && [line isMatchedByRegex:@"^[^a-z]+(\\(cont'd\\))?$"]) {
            // look ahead to see if the next line is blank
            NSUInteger nextIndex = index + 1;
            if (nextIndex < [lines count]) {
                NSString *nextLine = lines[index+1];
                if (![nextLine isEqualToString:@""]) {
                    newlinesBefore = 0;
                    FNElement *element = [FNElement elementOfType:@"Character" text:line];
                    
                    if ([line isMatchedByRegex:@"\\^\\s*$"]) {
                        element.isDualDialogue = YES;
                        element.elementText = [element.elementText stringByReplacingOccurrencesOfRegex:@"\\s*\\^\\s*$" withString:@""];
                        BOOL foundPreviousCharacter = NO;
                        NSInteger index = [self.elements count] - 1;
                        while ((index >= 0) && !foundPreviousCharacter) {
                            FNElement *previousElement = (self.elements)[index];
                            if ([previousElement.elementType isEqualToString:@"Character"]) {
                                previousElement.isDualDialogue = YES;
                                foundPreviousCharacter = YES;
                            }
                            index--;
                        }
                    }
                    
                    [self.elements addObject:element];
                    isInsideDialogueBlock = YES;
                    continue;
                }
            }
        }
        
        // Dialogue and Parentheticals
        if (isInsideDialogueBlock) {
            // Find out which type of element we have
            if (newlinesBefore == 0 && [line isMatchedByRegex:@"^\\s*\\("]) {
                FNElement *element = [FNElement elementOfType:@"Parenthetical" text:line];
                [self.elements addObject:element];
                continue;
            }
            else {
                // Check to see if the previous element was a dialogue
                NSUInteger lastIndex = [self.elements count] - 1;
                FNElement *previousElement = (self.elements)[lastIndex];
                if ([previousElement.elementType isEqualToString:@"Dialogue"]) {
                    NSString *text = [NSString stringWithFormat:@"%@\n%@", previousElement.elementText, line];
                    previousElement.elementText = text;
                    [self.elements removeObjectAtIndex:lastIndex];
                    [self.elements addObject:previousElement];
                }
                else {
                    FNElement *element = [FNElement elementOfType:@"Dialogue" text:line];
                    [self.elements addObject:element];
                }
                continue;
            }
        }
        
        // This is for when inter element lines aren't separated by blank lines.
        if (newlinesBefore == 0 && [self. elements count] > 0) {
            // Get the previous action line and merge this one into it
            NSUInteger lastIndex = [self.elements count] - 1;
            FNElement *previousElement = (self.elements)[lastIndex];
            // Scene Heading must be surrounded by blank lines
            if ([previousElement.elementType isEqualToString:@"Scene Heading"]) {
                previousElement.elementType = @"Action";
            }            
            
            NSString *text = [NSString stringWithFormat:@"%@\n%@", previousElement.elementText, line];
            previousElement.elementText = text;
            [self.elements removeObjectAtIndex:lastIndex];
            [self.elements addObject:previousElement];
            newlinesBefore = 0;
            continue;
        }
        else {
            FNElement *element = [FNElement elementOfType:@"Action" text:line];
            [self.elements addObject:element];
            newlinesBefore = 0;
            continue;
        }
    }
}

@end
