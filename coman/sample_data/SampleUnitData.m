//
//  SampleUnitData.m
//  coman
//
//  Created by 苏智 on 14-9-4.
//  Copyright (c) 2014年 Suzic. All rights reserved.
//

#import "SampleUnitData.h"

@implementation SampleUnitData

@synthesize title = _title;
@synthesize day = _day;
@synthesize startHour = _startHour;
@synthesize durationInHours = _durationInHours;

+ (instancetype)randomUnit
{
    uint32_t randomID = arc4random_uniform(10000);
    NSString *title = [NSString stringWithFormat:@"Unit #%u", randomID];
    
    uint32_t randomDay = arc4random_uniform(7);
    uint32_t randomStartHour = arc4random_uniform(20);
    uint32_t randomDuration = arc4random_uniform(5) + 1;
    
    return [self unitWithTitle:title day:randomDay startHour:randomStartHour durationInHours:randomDuration];
}

+ (instancetype)unitWithTitle:(NSString *)title day:(NSUInteger)day startHour:(NSUInteger)startHour durationInHours:(NSUInteger)durationInHours
{
    return [[self alloc] initWithTitle:title day:day startHour:startHour durationInHours:durationInHours];
}

- (instancetype)initWithTitle:(NSString *)title day:(NSUInteger)day startHour:(NSUInteger)startHour durationInHours:(NSUInteger)durationInHours
{
    self = [super init];
    if (self != nil)
    {
        _title = [title copy];
        _day = day;
        _startHour = startHour;
        _durationInHours = durationInHours;
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@: Day %d - Hour %d - Duration %d", self.title, self.day, self.startHour, self.durationInHours];
}

@end
