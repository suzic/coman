//
//  SZCellUnit.h
//  coman
//
//  Created by 苏智 on 14-9-4.
//  Copyright (c) 2014年 Suzic. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SZCellUnit <NSObject>

@property (assign, nonatomic) NSInteger index;
@property (assign, nonatomic) NSInteger rowIndex;
@property (assign, nonatomic) NSInteger colIndex;

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) UIColor* cellColor;

@property (assign, nonatomic) NSInteger cellSizeType;

@end
