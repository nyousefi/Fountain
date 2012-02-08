//
//  FountainWriter.m
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

#import "FountainWriter.h"
#import "FNScript.h"
#import "FNElement.h"
#import "FountainRegexes.h"
#import "RegexKitLite.h"

@implementation FountainWriter

+ (NSString *)documentFromScript:(FNScript *)script
{
    NSString *documentContent  = [self bodyFromScript:script];
    NSString *titlePageContent = [self titlePageFromScript:script];
    
    NSMutableString *document = [NSMutableString string];
    
    if ([titlePageContent length] > 0) {
        [document appendFormat:@"%@\n", titlePageContent];
    }
    
    if ([documentContent length] > 0) {
        [document appendFormat:@"%@", documentContent];
    }
    
    // trim newlines from the top and bottom of the document
    return [document stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+ (NSString *)bodyFromScript:(FNScript *)script
{
    NSMutableString *fountainContent = [NSMutableString string];
    
    NSInteger dualDialogueCount = 0;
    
    for (FNElement *element in script.elements) {
        // data check
        if (([element.elementText isMatchedByRegex:@"^[\\s\\n\\t]*$"] || element.elementText == nil) && ![element.elementType isEqualToString:@"Page Break"]) {
            continue;
        }
        
        NSString *textToWrite = nil;    // need to set to nil to avoid logic warnings
        if ([element.elementType isEqualToString:@"Comment"]) {
            // check if the comment text has any newlines, indicating that it's a multi-line comment
            textToWrite = [NSString stringWithFormat:@"\n[[%@]]", element.elementText];
        }
        else if ([element.elementType isEqualToString:@"Boneyard"]) {
            textToWrite = [NSString stringWithFormat:@"/*\n%@\n*/", element.elementText];
        }
        else if ([element.elementType isEqualToString:@"Synopsis"]) {
            textToWrite = [NSString stringWithFormat:@"=%@", element.elementText];
        }        
        else if ([element.elementType isEqualToString:@"Scene Heading"]) {
            if (!script.suppressSceneNumbers && element.sceneNumber) {
                textToWrite = [NSString stringWithFormat:@"%@ #%@#", element.elementText, element.sceneNumber];
            }
            else {
                textToWrite = element.elementText;
            }
        }
        else if ([element.elementType isEqualToString:@"Page Break"]) {
            textToWrite = @"====";
        }
        else if ([element.elementType isEqualToString:@"Section Heading"]) {
            NSMutableString *sectionDepthMarkup = [NSMutableString string];
            for (NSInteger depthLevel = 1; depthLevel <= element.sectionDepth; depthLevel++) {
                [sectionDepthMarkup appendString:@"#"];
            }
            textToWrite = [NSString stringWithFormat:@"%@ %@", sectionDepthMarkup, element.elementText];
        }
        else if ([[NSString stringWithFormat:@"\n%@\n", element.elementText] isEqualToString:@"Transition"]) {
            if (![element.elementText isMatchedByRegex:TRANSITION_PATTERN]) {
                textToWrite = [NSString stringWithFormat:@"> %@", element.elementText];
            }
        }        
        else {
            textToWrite = element.elementText;
        }
        
        if (element.isCentered) {
            // There should be a space between the end of the line and the < char, if there isn't already one there.
            if ([textToWrite isMatchedByRegex:@"[ ]$"]) {
                textToWrite = [NSString stringWithFormat:@"> %@<", textToWrite];
            }
            else {
                textToWrite = [NSString stringWithFormat:@"> %@ <", textToWrite];
            }
        }
        
        if ([element.elementType isEqualToString:@"Character"] && element.isDualDialogue) {
            dualDialogueCount++;
            if (dualDialogueCount == 2) {
                textToWrite = [NSString stringWithFormat:@"%@ ^", textToWrite];
                dualDialogueCount = 0;
            }
        }
        
        NSSet *dialogueTypes = [NSSet setWithObjects:@"Dialogue", @"Parenthetical", @"Comment", nil];
        if ([dialogueTypes containsObject:element.elementType]) {
            [fountainContent appendFormat:@"%@\n", textToWrite];
        }
        else {
            [fountainContent appendFormat:@"\n%@\n", textToWrite];
        }
    }        
    return fountainContent;
}

+ (NSString *)titlePageFromScript:(FNScript *)script
{
    NSMutableString *titlePageContent = [NSMutableString string];

    if (!script.titlePage) {
        return titlePageContent;
    }
    
    for (NSDictionary *dict in script.titlePage) {
        [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            // Make the key pretty by capitalizing the first char
            NSString *keyString = [key stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[key substringToIndex:1] uppercaseString]];            
            if ([obj count] == 1) {
                // Fix for authors vs author when only one author's name is given
                if ([key isEqualToString:@"authors"]) {
                    keyString = @"Author";
                }
                [titlePageContent appendFormat:@"%@: %@\n", keyString, [obj objectAtIndex:0]];
            }
            else {
                [titlePageContent appendFormat:@"%@:\n", keyString];
                for (NSString *value in obj) {
                    [titlePageContent appendFormat:@"\t%@\n", value];
                }
            }
        }];
    }    
    return titlePageContent;
}


@end
