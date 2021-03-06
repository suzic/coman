//
//  SZCollectionDataSource.m
//  coman
//
//  Created by 苏智 on 14-9-4.
//  Copyright (c) 2014年 Suzic. All rights reserved.
//

#import "SZCollectionDataSource.h"
#import "SampleUnitData.h"
#import "SZAppDelegate.h"

@interface SZCollectionDataSource ()

@property (strong, nonatomic) NSMutableArray *units;

@end

@implementation SZCollectionDataSource

- (void)awakeFromNib
{
    _units = [[NSMutableArray alloc] init];
}

- (void)generateSampleData
{
    // Prepare some example events
    // In a real app, these should be retrieved from the calendar data store (EventKit.framework)
    // We use a very simple data format for our events. In a real calendar app, event times should be
    // represented with NSDate objects and correct calendrical date calculcations should be used.

    [_units removeAllObjects];
    
    SZAppDelegate* ad = (SZAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    // 在测试数据中，随机生成40个单元用来做填充（不一定都放得下）
    for (NSUInteger idx = 0; idx < 40; idx++)
    {
        SampleUnitData *unit = [SampleUnitData randomUnitWidth:ad.MaxCellWidthUnit andHeight:ad.MaxCellHeightUnit];
        unit.index = idx;
        [self.units addObject:unit];
    }
}

#pragma mark - CalendarDataSource

// The layout object calls these methods to identify the events that correspond to
// a given index path or that are visible in a certain rectangle
- (id<SZCellUnit>)unitAtIndexPath:(NSIndexPath *)indexPath
{
    return self.units[indexPath.item];
}

- (NSArray *)indexPathsOfUnitsBetweenMinColIndex:(NSInteger)minVisibleColIndex
                                     maxColIndex:(NSInteger)maxVisibleColIndex
                                     minRowIndex:(NSInteger)minVisibleRowIndex
                                     maxRowIndex:(NSInteger)maxVisibleRowIndex
{
    NSMutableArray *indexPaths = [NSMutableArray array];
    [self.units enumerateObjectsUsingBlock:^(id unit, NSUInteger idx, BOOL *stop) {
        if ([unit colIndex] >= minVisibleColIndex && [unit colIndex] <= maxVisibleColIndex
            && [unit rowIndex] >= minVisibleRowIndex && [unit rowIndex] <= maxVisibleRowIndex)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:0];
            [indexPaths addObject:indexPath];
        }
    }];
    return indexPaths;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.units count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id<SZCellUnit> unit = self.units[indexPath.item];
    SZCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"normal_rect" forIndexPath:indexPath];
    
    if (self.configureCellBlock) {
        self.configureCellBlock(cell, indexPath, unit);
    }
    return cell;
}

@end
