//
//  SZCollectionDataSource.h
//  coman
//
//  Created by 苏智 on 14-9-4.
//  Copyright (c) 2014年 Suzic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SZCellUnit.h"
#import "SZCollectionViewCell.h"

typedef void (^ConfigureCellBlock)(SZCollectionViewCell *cell, NSIndexPath *indexPath, id<SZCellUnit> unit);

@interface SZCollectionDataSource : NSObject <UICollectionViewDataSource>

@property (copy, nonatomic) ConfigureCellBlock configureCellBlock;

- (id<SZCellUnit>)unitAtIndexPath:(NSIndexPath *)indexPath;

- (NSArray *)indexPathsOfUnitsBetweenMinColIndex:(NSInteger)minVisibleColIndex
                                     maxColIndex:(NSInteger)maxVisibleColIndex
                                     minRowIndex:(NSInteger)minVisibleRowIndex
                                     maxRowIndex:(NSInteger)maxVisibleRowIndex;

/**
 * @abstract Use for re-generate the sample data
 */
- (void)generateSampleData;

@end
