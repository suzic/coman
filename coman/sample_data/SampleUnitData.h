//
//  SampleUnitData.h
//  coman
//
//  Created by 苏智 on 14-9-4.
//  Copyright (c) 2014年 Suzic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SZCellUnit.h"

@interface SampleUnitData : NSObject <SZCellUnit>

+ (instancetype)randomUnit;
+ (instancetype)unitWithTitle:(NSString *)title day:(NSUInteger)day startHour:(NSUInteger)startHour durationInHours:(NSUInteger)durationInHours;
- (instancetype)initWithTitle:(NSString *)title day:(NSUInteger)day startHour:(NSUInteger)startHour durationInHours:(NSUInteger)durationInHours;

@end
