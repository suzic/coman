//
//  SZCellUnit.h
//  coman
//
//  Created by 苏智 on 14-9-4.
//  Copyright (c) 2014年 Suzic. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SZCellUnit <NSObject>

@property (copy, nonatomic) NSString *title;
@property (assign, nonatomic) NSInteger day;
@property (assign, nonatomic) NSInteger startHour;
@property (assign, nonatomic) NSInteger durationInHours;

@end
