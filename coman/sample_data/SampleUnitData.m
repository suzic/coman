//
//  SampleUnitData.m
//  coman
//
//  Created by 苏智 on 14-9-4.
//  Copyright (c) 2014年 Suzic. All rights reserved.
//

#import "SampleUnitData.h"

@implementation SampleUnitData

@synthesize index = _index;
@synthesize rowIndex = _rowIndex;
@synthesize colIndex = _colIndex;

@synthesize title = _title;
@synthesize cellSizeType = _cellSizeType;
@synthesize cellColor = _cellColor;

+ (instancetype)randomUnit
{
    uint32_t randomColor = arc4random_uniform(8);
    UIColor* color = [UIColor whiteColor];
    switch (randomColor)
    {
        case 0:
            color = [UIColor blueColor];
            break;
        case 1:
            color = [UIColor redColor];
            break;
        case 2:
            color = [UIColor yellowColor];
            break;
        case 3:
            color = [UIColor greenColor];
            break;
        case 4:
            color = [UIColor grayColor];
            break;
        case 5:
            color = [UIColor purpleColor];
            break;
        case 6:
            color = [UIColor darkGrayColor];
            break;
        case 7:
        default:
            color = [UIColor lightGrayColor];
            break;
    }
    
    uint32_t randomType = arc4random_uniform(8);
    
    // uint32_t randomID = arc4random_uniform(10000);
    // NSString *title = [NSString stringWithFormat:@"Unit #%u", randomID];
    NSString *title = nil;
    switch (randomType)
    {
        default:
        case 0:
            title = [NSString stringWithFormat:@"1 x 1"];
            break;
        case 1:
            title = [NSString stringWithFormat:@"2 x 1"];
            break;
        case 2:
            title = [NSString stringWithFormat:@"3 x 1"];
            break;
        case 3:
            title = [NSString stringWithFormat:@"4 x 1"];
            break;
        case 4:
            title = [NSString stringWithFormat:@"1 x 2"];
            break;
        case 5:
            title = [NSString stringWithFormat:@"2 x 2"];
            break;
        case 6:
            title = [NSString stringWithFormat:@"3 x 2"];
            break;
        case 7:
            title = [NSString stringWithFormat:@"4 x 2"];
            break;
    }
    return [self unitWithTitle:title size:randomType color:color];
}

+ (instancetype)unitWithTitle:(NSString *)title size:(NSInteger)cellType color:(UIColor *)cellColor
{
    return [[self alloc] initWithTitle:title size:cellType color:cellColor];
}

- (instancetype)initWithTitle:(NSString *)title size:(NSInteger)cellType color:(UIColor *)cellColor
{
    self = [super init];
    if (self != nil)
    {
        _title = [title copy];
        _cellSizeType = cellType;
        _cellColor = cellColor;
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"The unit size is : No.%ld %@", (long)self.index, self.title];
}

@end
