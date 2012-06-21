//
//  FountainParser.m
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

#import "FountainParser.h"
#import "FNElement.h"
#import "FountainRegexes.h"
#import "RegexKitLite.h"

@interface FountainParser ()

+ (NSString *)bodyOfString:(NSString *)string;
+ (NSString *)titlePageOfString:(NSString *)string;

@end


@implementation FountainParser

# pragma mark - Body parsing

+ (NSArray *)parseBodyOfString:(NSString *)string
{
    NSMutableString *scriptContent = [NSMutableString stringWithString:[self bodyOfString:string]];
    
    // Three-pass parsing method. 
    // 1st we check for block comments, and manipulate them for regexes
    // 2nd we run regexes against the file to convert it into a marked up format 
    // 3rd we split the marked up elements, and loop through them adding each to 
    //   an our array of FNElements.
    //
    // The intermediate marked up format makes subsequent parsing very simple, 
    // even if it means less efficiency overall.
    //

    // 1st pass - Block comments
    // The regexes aren't smart enough (yet) to deal with newlines in the
    // comments, so we need to convert them before processing.
    NSArray *blockCommentMatches = [scriptContent componentsMatchedByRegex:BLOCK_COMMENT_PATTERN capture:1];
    for (NSString *blockComment in blockCommentMatches) {
        NSString *modifiedBlock = [blockComment stringByReplacingOccurrencesOfString:@"\n" withString:NEWLINE_REPLACEMENT];
        [scriptContent replaceOccurrencesOfString:blockComment withString:modifiedBlock options:NSCaseInsensitiveSearch range:NSMakeRange(0, [scriptContent length])];
    }    
    NSArray *bracketCommentMatches = [scriptContent componentsMatchedByRegex:BRACKET_COMMENT_PATTERN capture:1];
    for (NSString *bracketComment in bracketCommentMatches) {
        NSString *modifiedBlock = [bracketComment stringByReplacingOccurrencesOfString:@"\n" withString:NEWLINE_REPLACEMENT];
        [scriptContent replaceOccurrencesOfString:bracketComment withString:modifiedBlock options:NSCaseInsensitiveSearch range:NSMakeRange(0, [scriptContent length])];
    }
    
    // Sanitize < and > chars for conversion to the markup
    [scriptContent replaceOccurrencesOfString:@"<" withString:@"&lt;" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [scriptContent length])];
    [scriptContent replaceOccurrencesOfString:@">" withString:@"&gt;" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [scriptContent length])];
    [scriptContent replaceOccurrencesOfString:@"..." withString:@"::trip::" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [scriptContent length])];

    // 2nd pass - Regexes
    // Blast the script with regexes. 
    // Make sure pattern and template regexes match up!
    NSArray *patterns  = [NSArray arrayWithObjects:UNIVERSAL_LINE_BREAKS_PATTERN, BLOCK_COMMENT_PATTERN, 
                          BRACKET_COMMENT_PATTERN, SYNOPSIS_PATTERN, PAGE_BREAK_PATTERN, FALSE_TRANSITION_PATTERN, FORCED_TRANSITION_PATTERN,
                          SCENE_HEADER_PATTERN, FIRST_LINE_ACTION_PATTERN, TRANSITION_PATTERN, 
                          CHARACTER_CUE_PATTERN, PARENTHETICAL_PATTERN, DIALOGUE_PATTERN, SECTION_HEADER_PATTERN,
                          ACTION_PATTERN, CLEANUP_PATTERN, NEWLINE_REPLACEMENT, nil];
    
    NSArray *templates = [NSArray arrayWithObjects:UNIVERSAL_LINE_BREAKS_TEMPLATE, BLOCK_COMMENT_TEMPLATE, 
                          BRACKET_COMMENT_TEMPLATE, SYNOPSIS_TEMPLATE, PAGE_BREAK_TEMPLATE, FALSE_TRANSITION_TEMPLATE, FORCED_TRANSITION_TEMPLATE,
                          SCENE_HEADER_TEMPLATE, FIRST_LINE_ACTION_TEMPLATE, TRANSITION_TEMPLATE, 
                          CHARACTER_CUE_TEMPLATE, PARENTHETICAL_TEMPLATE, DIALOGUE_TEMPLATE, SECTION_HEADER_TEMPLATE,
                          ACTION_TEMPLATE, CLEANUP_TEMPLATE, NEWLINE_RESTORE, nil];
    
    // Validate the array counts (protection against programmer stupidity)
    NSInteger arrayMax = [patterns count];
    if (arrayMax != [templates count]) {
        NSLog(@"The pattern and template arrays don't have the same number of objects!");
        return nil;
    }
    
    // Run the regular expressions
    for (NSInteger i = 0; i < arrayMax; i++) {
        [scriptContent replaceOccurrencesOfRegex:[patterns objectAtIndex:i] withString:[templates objectAtIndex:i]];
    }
    
    // ------------------------------------------------------------------------ 
    // FOR DEBUG ONLY
    // Make the intermediate content human readable
    // ------------------------------------------------------------------------
    // NSString *closingTag = @"(<\\/[a-zA-Z\\s]+>)";
    // [scriptContent replaceOccurrencesOfRegex:@"\\n+" withString:@""];
    // [scriptContent replaceOccurrencesOfRegex:closingTag withString:@"$1\n"];
    // NSLog(@"\n%@\n", scriptContent);
    
    
    // 3rd pass - Array construction
    NSString *tagMatching   = @"<([a-zA-Z\\s]+)>([^<>]*)<\\/[a-zA-Z\\s]+>";
    NSArray  *elementText   = [scriptContent componentsMatchedByRegex:tagMatching capture:2];
    NSArray  *elementType   = [scriptContent componentsMatchedByRegex:tagMatching capture:1];
    NSInteger max           = [elementText count];
    
    // Validate the _Text and _Type counts match
    if ([elementText count] != [elementType count]) {
        NSLog(@"Text and Type counts don't match.");
        return nil;
    }
    
    NSMutableArray *elementsArray = [NSMutableArray array];
    
    for (NSInteger i = 0; i < max; i++) {
        FNElement *element = [[FNElement alloc] init];
        
        // Convert < and > back to normal
        NSMutableString *cleanedText = [NSMutableString stringWithString:[elementText objectAtIndex:i]];
        [cleanedText replaceOccurrencesOfString:@"&lt;" withString:@"<" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [cleanedText length])];
        [cleanedText replaceOccurrencesOfString:@"&gt;" withString:@">" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [cleanedText length])];
        [cleanedText replaceOccurrencesOfString:@"::trip::" withString:@"..." options:NSCaseInsensitiveSearch range:NSMakeRange(0, [cleanedText length])];

        // Deal with scene numbers if we are in a scene heading
        NSString *sceneNumber = nil;
        NSString *fullSceneNumberText = nil;
        if ([[elementType objectAtIndex:i] isEqualToString:@"Scene Heading"]) {
            sceneNumber = [cleanedText stringByMatching:SCENE_NUMBER_PATTERN options:RKLCaseless inRange:NSMakeRange(0, [cleanedText length]) capture:2 error:nil];
            fullSceneNumberText = [cleanedText stringByMatching:SCENE_NUMBER_PATTERN options:RKLCaseless inRange:NSMakeRange(0, [cleanedText length]) capture:1 error:nil];
            if (sceneNumber) {
                element.sceneNumber = sceneNumber;
                [cleanedText replaceOccurrencesOfString:fullSceneNumberText withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [cleanedText length])];
            }
        }                
        
        element.elementType     = [elementType objectAtIndex:i];        
        element.elementText     = [cleanedText stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];        
        
        
        // More refined processing of elements based on text/type
        if ([element.elementText isMatchedByRegex:CENTERED_TEXT_PATTERN]) {
            element.isCentered = YES;
            element.elementText = [[element.elementText stringByMatching:@"(>?)\\s*([^<>\\n]*)\\s*(<?)" capture:2] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        }
        
        if ([element.elementType isEqualToString:@"Scene Heading"]) {
            // Check for a forced scene heading. Remove preceeding dot.
            element.elementText = [element.elementText stringByMatching:@"^\\.?(.+)" capture:1];
        }
        
        if ([element.elementType isEqualToString:@"Section Heading"]) {
            // Clean the section text, and get the section depth
            NSString *depthChars = [element.elementText stringByMatching:SECTION_HEADER_PATTERN capture:2];
            NSUInteger depth = [depthChars length];
            element.sectionDepth = depth;
            element.elementText = [element.elementText stringByMatching:SECTION_HEADER_PATTERN capture:3];
        }
        
        if (i > 1 && [element.elementType isEqualToString:@"Character"] && [element.elementText isMatchedByRegex:DUAL_DIALOGUE_PATTERN]) {
            element.isDualDialogue = YES;
            
            // clean the ^ mark
            element.elementText = [element.elementText stringByReplacingOccurrencesOfRegex:@"\\s*\\^$" withString:@""];
            
            // find the previous character cue
            NSInteger j = i - 1;
            
            FNElement *previousElement;
            NSSet *dialogueBlockTypes   = [NSSet setWithObjects:@"Dialogue", @"Parenthetical", nil];
            do {
                previousElement = [elementsArray objectAtIndex:j];
                if ([previousElement.elementType isEqualToString:@"Character"]) {
                    previousElement.isDualDialogue = YES;
                    previousElement.elementText = [previousElement.elementText stringByReplacingOccurrencesOfString:@"^" withString:@""];
                }
                j--;
            } while (j >= 0 && [dialogueBlockTypes containsObject:previousElement.elementType]);
        }
        
        [elementsArray addObject:element];
        [element release];
    }    
    return [NSArray arrayWithArray:elementsArray];
}


+ (NSArray *)parseBodyOfFile:(NSString *)path
{
    NSError  *error = nil;
    NSString *fileContents  = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        // handle the error
    }    
    return [self parseBodyOfString:fileContents];
}

# pragma mark - Title page parsing

+ (NSArray *)parseTitlePageOfString:(NSString *)string
{
    NSMutableString *rawTitlePage = [NSMutableString stringWithString:[self titlePageOfString:string]];
    NSMutableArray *contents = [NSMutableArray array];
    
    // Line by line parsing
    // split the title page using newlines, then walk through the array and determine what is what
    // this allows us to look for very specific things and better handle non-uniform title pages
    
    // split the string
    NSArray *splitTitlePage = [rawTitlePage componentsSeparatedByString:@"\n"];
    
    NSString *openDirective = nil;
    NSMutableArray *directiveData = [NSMutableArray array];
    
    for (NSString *line in splitTitlePage) {        
        // is this an inline directive or a multi-line one?        
        if ([line isMatchedByRegex:INLINE_DIRECTIVE_PATTERN]) {            
            // if there's an openDirective with data, save it
            if (openDirective != nil && [directiveData count] > 0) {
                [contents addObject:[NSDictionary dictionaryWithObject:directiveData forKey:openDirective]];
                directiveData = [NSMutableArray array];
            }
            openDirective = nil;
            
            NSString *key = [[line stringByMatching:INLINE_DIRECTIVE_PATTERN capture:1] lowercaseString];
            NSString *val = [line stringByMatching:INLINE_DIRECTIVE_PATTERN capture:2];
            
            // validation
            if ([key isEqualToString:@"author"] || [key isEqualToString:@"author(s)"]) {
                key = @"authors";
            }
            
            [contents addObject:[NSDictionary dictionaryWithObject:[NSArray arrayWithObject:val] forKey:key]];
        }
        else if ([line isMatchedByRegex:MULTI_LINE_DIRECTIVE_PATTERN]) {
            // if there's an openDirective with data, save it
            if (openDirective != nil && [directiveData count] > 0) {
                [contents addObject:[NSDictionary dictionaryWithObject:directiveData forKey:openDirective]];
            }
            
            openDirective = [[line stringByMatching:MULTI_LINE_DIRECTIVE_PATTERN capture:1] lowercaseString];
            directiveData = [NSMutableArray array];
            
            // validation
            if ([openDirective isEqualToString:@"author"] || [openDirective isEqualToString:@"author(s)"]) {
                openDirective = @"authors";
            }
        }
        else {
            if ([line stringByMatching:MULTI_LINE_DATA_PATTERN capture:2]) {
                [directiveData addObject:[line stringByMatching:MULTI_LINE_DATA_PATTERN capture:2]];
            }
        }
    }
    
    if (openDirective != nil && [directiveData count] > 0) {
        [contents addObject:[NSDictionary dictionaryWithObject:directiveData forKey:openDirective]];
    }    
    return contents;
}

+ (NSArray *)parseTitlePageOfFile:(NSString *)path
{
    NSError  *error = nil;
    NSString *fileContents  = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        // handle the error
    }    
    return [self parseTitlePageOfString:fileContents];
}

# pragma mark - Private Helpers

// Extract the body content from the string.
+ (NSString *)bodyOfString:(NSString *)string
{
    NSMutableString *body = [NSMutableString stringWithString:string];
    [body replaceOccurrencesOfRegex:@"^\\n+" withString:@""];
    
    // Find title page by looking for the first blank line, then checking the
    // text above it. If a title page is found we remove it, leaving only the
    // body content.
    NSRange firstBlankLine = [body rangeOfString:@"\n\n"];
    if (firstBlankLine.length > 0) {
        NSRange beforeBlankRange = NSMakeRange(0, firstBlankLine.location+1);
        NSMutableString *documentTop = [NSMutableString stringWithString:[body substringWithRange:beforeBlankRange]];
        [documentTop appendString:@"\n"];   // fix for programmer laziness
        
        // Check if this is a title page
        BOOL foundTitlePage = [documentTop isMatchedByRegex:TITLE_PAGE_PATTERN];
        if (foundTitlePage) {
            [body deleteCharactersInRange:beforeBlankRange];
        }
    }
    return [NSString stringWithFormat:@"\n\n%@\n\n", body];
}

// Extract the title page content from the string.
+ (NSString *)titlePageOfString:(NSString *)string
{
    NSMutableString *body = [NSMutableString stringWithString:string];
    [body replaceOccurrencesOfRegex:@"^\\n+" withString:@""];
    
    // Find title page by looking for the first blank line, then checking the
    // text above it. If a title page is found we return it.
    NSRange firstBlankLine = [body rangeOfString:@"\n\n"];
    if (firstBlankLine.length > 0) {
        NSRange beforeBlankRange = NSMakeRange(0, firstBlankLine.location+1);
        NSMutableString *documentTop = [NSMutableString stringWithString:[body substringWithRange:beforeBlankRange]];
        [documentTop appendString:@"\n"];   // fix for programmer laziness
        
        // Check if this is a title page
        BOOL foundTitlePage = [documentTop isMatchedByRegex:TITLE_PAGE_PATTERN];
        if (foundTitlePage) {
            [documentTop replaceOccurrencesOfRegex:@"^\n+" withString:@""];
            [documentTop replaceOccurrencesOfRegex:@"\n+$" withString:@""];
            return documentTop;
        }
    }    
    // If there's no title page to be found
    return @"";
}

@end
