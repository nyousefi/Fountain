//
//  RegexConstants.m
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

#import "FountainRegexes.h"

NSString * const UNIVERSAL_LINE_BREAKS_PATTERN  = @"\\r\\n|\\r|\\n";
NSString * const UNIVERSAL_LINE_BREAKS_TEMPLATE = @"\n";

#pragma mark - Patterns

NSString * const SCENE_HEADER_PATTERN       = @"(?<=\\n)(([iI][nN][tT]|[eE][xX][tT]|[^\\w][eE][sS][tT]|\\.|[iI]\\.?\\/[eE]\\.?)([^\\n]+))\\n";
NSString * const ACTION_PATTERN             = @"([^<>]*?)(\\n{2}|\\n<)";
NSString * const MULTI_LINE_ACTION_PATTERN  = @"\n{2}(([^a-z\\n:]+?[\\.\\?,\\s!\\*_]*?)\n{2}){1,2}";
NSString * const CHARACTER_CUE_PATTERN      = @"(?<=\\n)([ \\t]*[^<>a-z\\s\\/\\n][^<>a-z:!\\?\\n]*[^<>a-z\\(!\\?:,\\n\\.][ \\t]?)\\n{1}(?!\\n)";
NSString * const DIALOGUE_PATTERN           = @"(<(Character|Parenthetical)>[^<>\\n]+<\\/(Character|Parenthetical)>)([^<>]*?)(?=\\n{2}|\\n{1}<Parenthetical>)";
NSString * const PARENTHETICAL_PATTERN      = @"(\\([^<>]*?\\)[\\s]?)\n";
NSString * const TRANSITION_PATTERN         = @"\\n([\\*_]*([^<>\\na-z]*TO:|FADE TO BLACK\\.|FADE OUT\\.|CUT TO BLACK\\.)[\\*_]*)\\n";
NSString * const FORCED_TRANSITION_PATTERN  = @"\\n((&gt;|>)\\s*[^<>\\n]+)\\n";     // need to look for &gt; pattern because we run this regex against marked up content
NSString * const FALSE_TRANSITION_PATTERN  = @"\\n((&gt;|>)\\s*[^<>\\n]+(&lt;\\s*))\\n";     // need to look for &gt; pattern because we run this regex against marked up content
NSString * const PAGE_BREAK_PATTERN         = @"(?<=\\n)(\\s*[\\=\\-\\_]{3,8}\\s*)\\n{1}";
NSString * const CLEANUP_PATTERN            = @"<Action>\\s*<\\/Action>";
NSString * const FIRST_LINE_ACTION_PATTERN  = @"^\\n\\n([^<>\\n#]*?)\\n";
NSString * const SCENE_NUMBER_PATTERN       = @"(\\#([0-9A-Za-z\\.\\)-]+)\\#)";
NSString * const SECTION_HEADER_PATTERN     = @"((#+)(\\s*[^\\n]*))\\n?";

#pragma mark - Templates

NSString * const SCENE_HEADER_TEMPLATE      = @"\n<Scene Heading>$1</Scene Heading>";
NSString * const ACTION_TEMPLATE            = @"<Action>$1</Action>$2";
NSString * const MULTI_LINE_ACTION_TEMPLATE = @"\n<Action>$2</Action>";
NSString * const CHARACTER_CUE_TEMPLATE     = @"<Character>$1</Character>";
NSString * const DIALOGUE_TEMPLATE          = @"$1<Dialogue>$4</Dialogue>";
NSString * const PARENTHETICAL_TEMPLATE     = @"<Parenthetical>$1</Parenthetical>";
NSString * const TRANSITION_TEMPLATE        = @"\n<Transition>$1</Transition>";
NSString * const FORCED_TRANSITION_TEMPLATE = @"\n<Transition>$1</Transition>";
NSString * const FALSE_TRANSITION_TEMPLATE  = @"\n<Action>$1</Action>";
NSString * const PAGE_BREAK_TEMPLATE        = @"\n<Page Break></Page Break>\n";
NSString * const CLEANUP_TEMPLATE           = @"";
NSString * const FIRST_LINE_ACTION_TEMPLATE = @"<Action>$1</Action>\n";
NSString * const SECTION_HEADER_TEMPLATE    = @"<Section Heading>$1</Section Heading>";

#pragma mark - Block Comments

NSString * const BLOCK_COMMENT_PATTERN      = @"\\n\\/\\*([^<>]+?)\\*\\/\\n";
NSString * const BRACKET_COMMENT_PATTERN    = @"\\n\\[{2}([^<>]+?)\\]{2}\\n";
NSString * const SYNOPSIS_PATTERN           = @"\\n={1}([^<>=][^<>]+?)\\n";     // we need to make sure we don't catch ==== as a synopsis

NSString * const BLOCK_COMMENT_TEMPLATE     = @"\n<Boneyard>$1</Boneyard>\n";
NSString * const BRACKET_COMMENT_TEMPLATE   = @"\n<Comment>$1</Comment>\n";
NSString * const SYNOPSIS_TEMPLATE          = @"\n<Synopsis>$1</Synopsis>\n";

NSString * const NEWLINE_REPLACEMENT        = @"@@@@@";
NSString * const NEWLINE_RESTORE            = @"\n";


#pragma mark - Title Page

NSString * const TITLE_PAGE_PATTERN             = @"^([^\\n]+:(([ \\t]*|\\n)[^\\n]+\\n)+)+\\n";
NSString * const INLINE_DIRECTIVE_PATTERN       = @"^([\\w\\s&]+):\\s*([^\\s][\\w&,\\.\\?!:\\(\\)\\/\\s-©\\*\\_]+)$";
NSString * const MULTI_LINE_DIRECTIVE_PATTERN   = @"^([\\w\\s&]+):\\s*$";
NSString * const MULTI_LINE_DATA_PATTERN        = @"^([ ]{2,8}|\\t)([^<>]+)$";


#pragma mark - Misc

NSString * const DUAL_DIALOGUE_PATTERN          = @"\\^\\s*$";
NSString * const CENTERED_TEXT_PATTERN          = @"^>[^<>\\n]+<";


//------------------------------------------------------------------------------
// The following regexes aren't used by the code here, but may be useful for you

#pragma mark - Styling for FDX

NSString * const BOLD_ITALIC_UNDERLINE_PATTERN  = @"(_\\*{3}|\\*{3}_)([^<>]+)(_\\*{3}|\\*{3}_)";
NSString * const BOLD_ITALIC_PATTERN            = @"(\\*{3})([^<>]+)(\\*{3})";
NSString * const BOLD_UNDERLINE_PATTERN         = @"(_\\*{2}|\\*{2}_)([^<>]+)(_\\*{2}|\\*{2}_)";
NSString * const ITALIC_UNDERLINE_PATTERN       = @"(_\\*{1}|\\*{1}_)([^<>]+)(_\\*{1}|\\*{1}_)";
NSString * const BOLD_PATTERN                   = @"(\\*{2})([^<>]+)(\\*{2})";
NSString * const ITALIC_PATTERN                 = @"(?<!\\\\)(\\*{1})([^<>]+)(\\*{1})";
NSString * const UNDERLINE_PATTERN              = @"(_)([^<>_]+)(_)";

#pragma mark - Styling templates

NSString * const BOLD_ITALIC_UNDERLINE_TEMPLATE = @"Bold+Italic+Underline";
NSString * const BOLD_ITALIC_TEMPLATE           = @"Bold+Italic";
NSString * const BOLD_UNDERLINE_TEMPLATE        = @"Bold+Underline";
NSString * const ITALIC_UNDERLINE_TEMPLATE      = @"Italic+Underline";
NSString * const BOLD_TEMPLATE                  = @"Bold";
NSString * const ITALIC_TEMPLATE                = @"Italic";
NSString * const UNDERLINE_TEMPLATE             = @"Underline";