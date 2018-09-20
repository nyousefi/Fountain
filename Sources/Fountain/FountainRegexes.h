//
//  FountainRegexes.h
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



extern NSString * const UNIVERSAL_LINE_BREAKS_PATTERN;
extern NSString * const UNIVERSAL_LINE_BREAKS_TEMPLATE;

// match patterns
extern NSString * const SCENE_HEADER_PATTERN;
extern NSString * const ACTION_PATTERN;
extern NSString * const MULTI_LINE_ACTION_PATTERN;
extern NSString * const CHARACTER_CUE_PATTERN;
extern NSString * const DIALOGUE_PATTERN;
extern NSString * const PARENTHETICAL_PATTERN;
extern NSString * const TRANSITION_PATTERN;
extern NSString * const FORCED_TRANSITION_PATTERN;
extern NSString * const FALSE_TRANSITION_PATTERN;
extern NSString * const PAGE_BREAK_PATTERN;
extern NSString * const CLEANUP_PATTERN;
extern NSString * const FIRST_LINE_ACTION_PATTERN;
extern NSString * const SCENE_NUMBER_PATTERN;
extern NSString * const SECTION_HEADER_PATTERN;

// templates
extern NSString * const SCENE_HEADER_TEMPLATE;
extern NSString * const ACTION_TEMPLATE;
extern NSString * const MULTI_LINE_ACTION_TEMPLATE;
extern NSString * const CHARACTER_CUE_TEMPLATE;
extern NSString * const DIALOGUE_TEMPLATE;
extern NSString * const PARENTHETICAL_TEMPLATE;
extern NSString * const TRANSITION_TEMPLATE;
extern NSString * const FORCED_TRANSITION_TEMPLATE;
extern NSString * const FALSE_TRANSITION_TEMPLATE;
extern NSString * const PAGE_BREAK_TEMPLATE;
extern NSString * const CLEANUP_TEMPLATE;
extern NSString * const FIRST_LINE_ACTION_TEMPLATE;
extern NSString * const SECTION_HEADER_TEMPLATE;

// comments
extern NSString * const BLOCK_COMMENT_PATTERN;
extern NSString * const BRACKET_COMMENT_PATTERN;
extern NSString * const SYNOPSIS_PATTERN;

extern NSString * const BLOCK_COMMENT_TEMPLATE;
extern NSString * const BRACKET_COMMENT_TEMPLATE;
extern NSString * const SYNOPSIS_TEMPLATE;

extern NSString * const NEWLINE_REPLACEMENT;
extern NSString * const NEWLINE_RESTORE;

// title page
extern NSString * const TITLE_PAGE_PATTERN;
extern NSString * const INLINE_DIRECTIVE_PATTERN;
extern NSString * const MULTI_LINE_DIRECTIVE_PATTERN;
extern NSString * const MULTI_LINE_DATA_PATTERN;

// misc
extern NSString * const DUAL_DIALOGUE_PATTERN;
extern NSString * const CENTERED_TEXT_PATTERN;

// Extra regexes -- not used by the code in this project
// styling for FDX
extern NSString * const BOLD_ITALIC_UNDERLINE_PATTERN;
extern NSString * const BOLD_ITALIC_PATTERN;
extern NSString * const BOLD_UNDERLINE_PATTERN;
extern NSString * const ITALIC_UNDERLINE_PATTERN;
extern NSString * const BOLD_PATTERN;
extern NSString * const ITALIC_PATTERN;
extern NSString * const UNDERLINE_PATTERN;

// styling templates
extern NSString * const BOLD_ITALIC_UNDERLINE_TEMPLATE;
extern NSString * const BOLD_ITALIC_TEMPLATE;
extern NSString * const BOLD_UNDERLINE_TEMPLATE;
extern NSString * const ITALIC_UNDERLINE_TEMPLATE;
extern NSString * const BOLD_TEMPLATE;
extern NSString * const ITALIC_TEMPLATE;
extern NSString * const UNDERLINE_TEMPLATE;
