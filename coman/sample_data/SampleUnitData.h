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

+ (instancetype)unitWithTitle:(NSString *)title size:(CellType)cellType color:(UIColor *)cellColor;
- (instancetype)initWithTitle:(NSString *)title size:(CellType)cellType color:(UIColor *)cellColor;

@end
