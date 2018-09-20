//
//  SectionAndSynopsisTests.m
//  Fountain
//
//  Created by Nima Yousefi on 7/11/13.
//  Copyright (c) 2013 Nima Yousefi. All rights reserved.
//

#import "SectionAndSynopsisTests.h"
#import "FNScript.h"
#import "FNElement.h"

@interface SectionAndSynopsisTests ()

@property (strong, nonatomic) FNScript *script;

@end

@implementation SectionAndSynopsisTests

- (void)setUp
{
    [super setUp];
    
    NSString *filename = @"Sections-Complex";
    NSString *path = [self pathForFile:filename];
    self.script = [[FNScript alloc] initWithFile:path];
}

- (void)tearDown
{
    [super tearDown];
}

- (NSString *)pathForFile:(NSString *)filename
{
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	NSString *filetype = @"fountain";
	NSString *path = [bundle pathForResource:filename ofType:filetype];
	
	return path;
}

- (NSString *)errorForElementAtIndex:(NSUInteger)index
{
    FNElement *element = (self.script.elements)[index];
    return [element description];
}

- (NSString *)elementTypeAtIndex:(NSUInteger)index
{
    FNElement *element = (self.script.elements)[index];
    return element.elementType;
}

- (NSUInteger)sectionDepthOfElementAtIndex:(NSUInteger)index
{
    FNElement *element = (self.script.elements)[index];
    
    if (![element.elementType isEqualToString:@"Section Heading"])
        STFail(@"Element at index %u is not a section header", index);
        
    return element.sectionDepth;
}

#pragma mark - Test

- (void)testSectionHeader
{
    NSUInteger index = 3;
    STAssertEqualObjects([self elementTypeAtIndex:index], @"Section Heading", [self errorForElementAtIndex:index]);
    STAssertEquals((int)[self sectionDepthOfElementAtIndex:index], 1, [self errorForElementAtIndex:index]);
}

- (void)testSectionHeaderWithoutPrecedingNewline
{
    NSUInteger index = 4;
    STAssertEqualObjects([self elementTypeAtIndex:index], @"Section Heading", [self errorForElementAtIndex:index]);
    STAssertEquals((int)[self sectionDepthOfElementAtIndex:index], 2, [self errorForElementAtIndex:index]);
}

- (void)testSynopsisWithoutPrecedingNewline
{
    NSUInteger index = 1;
    STAssertEqualObjects([self elementTypeAtIndex:index], @"Synopsis", [self errorForElementAtIndex:index]);
}

@end
