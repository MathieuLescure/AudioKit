//
//  AKStruckMetalBarTests.m
//  iOSObjectiveCAudioKit
//
//  Created by Aurelius Prochazka on 5/22/15.
//  Copyright (c) 2015 Aurelius Prochazka. All rights reserved.
//

#import "AKTestCase.h"

#define testDuration 10.0

@interface TestStruckMetalBarInstrument : AKInstrument
@end

@interface TestStruckMetalBarNote : AKNote
@property AKNoteProperty *strikePosition;
@property AKNoteProperty *strikeWidth;
- (instancetype)initWithStrikePosition:(float)strikePosition
                           strikeWidth:(float)strikeWidth;
@end

@implementation TestStruckMetalBarInstrument

- (instancetype)init
{
    self = [super init];
    if (self) {
        TestStruckMetalBarNote *note = [[TestStruckMetalBarNote alloc] init];
        AKStruckMetalBar *struckMetalBar = [AKStruckMetalBar strike];
        struckMetalBar.strikePosition = note.strikePosition;
        struckMetalBar.strikeWidth = note.strikeWidth;
        [self setAudioOutput:struckMetalBar];
    }
    return self;
}

@end

@implementation TestStruckMetalBarNote

- (instancetype)init
{
    self = [super init];
    if (self) {
        _strikePosition = [self createPropertyWithValue:0 minimum:0 maximum:1];
        _strikeWidth    = [self createPropertyWithValue:0 minimum:0 maximum:1];
    }
    return self;
}

- (instancetype)initWithStrikePosition:(float)strikePosition
                           strikeWidth:(float)strikeWidth
{
    self = [self init];
    if (self) {
        _strikePosition.value = strikePosition;
        _strikeWidth.value = strikeWidth;
    }
    return self;
}
@end


@interface AKStruckMetalBarTests : AKTestCase
@end

@implementation AKStruckMetalBarTests

- (void)testStruckMetalBar
{
    // Set up performance
    TestStruckMetalBarInstrument *testInstrument = [[TestStruckMetalBarInstrument alloc] init];
    [AKOrchestra addInstrument:testInstrument];
    
    AKPhrase *phrase = [AKPhrase phrase];
    
    for (int i = 0; i < 10; i++) {
        TestStruckMetalBarNote *note = [[TestStruckMetalBarNote alloc] initWithStrikePosition:(float)i/20
                                                                                  strikeWidth:0.5+(float)i/20];
        note.duration.value = 1.0;
        [phrase addNote:note atTime:(float)i];
    }
    
    [testInstrument playPhrase:phrase];
    
    // Render audio output
    NSString *outputFile = [self outputFileWithName:@"StruckMetalBar"];
    [[AKManager sharedManager] renderToFile:outputFile forDuration:testDuration];
    
    // Check output
    NSData *nsData = [NSData dataWithContentsOfFile:outputFile];
    XCTAssertEqualObjects([nsData MD5], @"e643af93bab5e7d066d00cfa92a54ec2");
}

@end
