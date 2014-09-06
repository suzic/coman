//
//  SZCollectionLayout.m
//  coman
//
//  Created by 苏智 on 14-9-4.
//  Copyright (c) 2014年 Suzic. All rights reserved.
//

#import "SZCollectionLayout.h"
#import "SZCollectionDataSource.h"

static const NSUInteger TotalUnitCountInWidth = 4;
static const NSUInteger TotalUnitCountInHeight = 8;
static const CGFloat HeightPerRow = 80;

/**
 * @abstract 定义一个剩余可用布局空间对象
 */
@interface SpareSpace : NSObject
{
@public
    NSInteger spareWidth;
    NSInteger spareHeight;
    NSInteger spareRowIndex;
    NSInteger spareColIndex;
}
@end

@implementation SpareSpace

- (id)init
{
    self = [super init];
    if (self)
    {
        spareWidth = 1;
        spareHeight = 1;
        spareRowIndex = 0;
        spareColIndex = 0;
    }
    return self;
}

@end

@interface SZCollectionLayout ()

@property (nonatomic, assign) NSInteger currentRowNumber;
@property (nonatomic, assign) NSInteger currentColumnNumber;
@property (nonatomic, assign) NSInteger currentHeightStep;

@property (nonatomic, strong) NSMutableArray* spareSpaces;

@end

@implementation SZCollectionLayout

#pragma mark - UICollectionViewLayout Implementation

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.currentRowNumber = 0;
        self.currentColumnNumber = 0;
        self.currentHeightStep = 1;
        
        self.spareSpaces = [NSMutableArray arrayWithCapacity:10];
    }
    return self;
}

// 设置整体视图的尺寸，横向不能滚动，纵向为 12 个单元行高
- (CGSize)collectionViewContentSize
{
    // Don't scroll horizontally
    CGFloat contentWidth = self.collectionView.bounds.size.width;
    
    // Scroll vertically to display a full day
    CGFloat contentHeight = HeightPerRow * TotalUnitCountInHeight;
    
    CGSize contentSize = CGSizeMake(contentWidth, contentHeight);
    return contentSize;
}

// 对可见的格子应用内部布局
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *layoutAttributes = [NSMutableArray array];
    
    // Cells
    NSArray *visibleIndexPaths = [self indexPathsOfItemsInRect:rect];
    for (NSIndexPath *indexPath in visibleIndexPaths)
    {
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        [layoutAttributes addObject:attributes];
    }
    
    return layoutAttributes;
}

// 获取指定格子的布局 **核心布局方法**
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SZCollectionDataSource *dataSource = self.collectionView.dataSource;
    id<SZCellUnit> unit = [dataSource unitAtIndexPath:indexPath];
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.frame = [self frameForUnit:unit];
    return attributes;
}

// 要求边界变化时更新布局，比如横竖屏旋转时
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    self.currentRowNumber = 0;
    self.currentColumnNumber = 0;
    self.currentHeightStep = 1;
    [self.spareSpaces removeAllObjects];
    return YES;
}

#pragma mark - Helpers

- (NSArray *)indexPathsOfItemsInRect:(CGRect)rect
{
    NSInteger minVisibleColIndex = [self colIndexFromXCoordinate:CGRectGetMinX(rect)];
    NSInteger maxVisibleColIndex = [self colIndexFromXCoordinate:CGRectGetMaxX(rect)];
    NSInteger minVisibleRowIndex = [self rowIndexFromYCoordinate:CGRectGetMinY(rect)];
    NSInteger maxVisibleRowIndex = [self rowIndexFromYCoordinate:CGRectGetMaxY(rect)];
    
    SZCollectionDataSource *dataSource = self.collectionView.dataSource;
    NSArray *indexPaths = [dataSource indexPathsOfUnitsBetweenMinColIndex:minVisibleColIndex
                                                              maxColIndex:maxVisibleColIndex
                                                              minRowIndex:minVisibleRowIndex
                                                              maxRowIndex:maxVisibleRowIndex];
    return indexPaths;
}

- (NSInteger)colIndexFromXCoordinate:(CGFloat)xPosition
{
    CGFloat contentWidth = [self collectionViewContentSize].width;
    CGFloat widthPerCol = contentWidth / TotalUnitCountInWidth;
    NSInteger colIndex = MAX((NSInteger)0, (NSInteger)(xPosition / widthPerCol));
    return colIndex;
}

- (NSInteger)rowIndexFromYCoordinate:(CGFloat)yPosition
{
    NSInteger rowIndex = MAX((NSInteger)0, (NSInteger)(yPosition / HeightPerRow));
    return rowIndex;
}

#pragma mark - Kernal Calculate layout functions

// 计算一个单元的尺寸和布局
- (CGRect)frameForUnit:(id<SZCellUnit>)unit
{
    // 根据实际设备尺寸获取宽度（高度则是固定的）
    CGFloat totalWidth = [self collectionViewContentSize].width;
    CGFloat unitWidth = totalWidth / 4;

    // 根据cell type计算出其尺寸
    CellType cellType = unit.cellSizeType;
    NSInteger hUnit = cellType / 4 + 1;
    NSInteger wUnit = cellType % 4 + 1;
    CGFloat cellWidth = unitWidth * wUnit;
    CGFloat cellHeight = HeightPerRow * hUnit;
    
    // 布局中的宽度和高度是必须满足的
    CGRect frame = CGRectZero;
    frame.size.width = cellWidth;
    frame.size.height = cellHeight;

    // 空余空间布局
    SpareSpace* ss = [self sparePositionIsAvaliableForUnitW:wUnit andUnitH:hUnit];
    if (ss != nil)
    {
        NSLog(@"%@ 使用空余布局空间", unit);
        unit.colIndex = ss->spareColIndex;
        unit.rowIndex = ss->spareRowIndex;

        if (ss->spareWidth == wUnit)
        {
            if (ss->spareHeight == hUnit)
            {
                // 空间用尽，删除
                [self.spareSpaces removeObject:ss];
            }
            else
            {
                // 使用了整行数据，留下半空间
                ss->spareHeight -= hUnit;
                ss->spareRowIndex += hUnit;
            }
        }
        else
        {
            if (ss->spareHeight == hUnit)
            {
                // 使用了整列数据，留后侧空间
                ss->spareWidth -= wUnit;
                ss->spareColIndex += wUnit;
            }
            else
            {
                // 本空间切分为两个独立空间
                SpareSpace* newss = [[SpareSpace alloc] init];
                newss->spareWidth = ss->spareWidth;
                newss->spareHeight = ss->spareHeight - hUnit;
                newss->spareColIndex = ss->spareColIndex;
                newss->spareRowIndex = ss->spareRowIndex + hUnit;
                [self addNewSpareSpace:newss];
                
                ss->spareWidth -= wUnit;
                ss->spareHeight = hUnit;
                ss->spareColIndex += wUnit;
            }
        }
        
        frame.origin.x = unit.colIndex * unitWidth;
        frame.origin.y = unit.rowIndex * HeightPerRow;
        //NSLog(@"Frame == %d %d %d %d", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
        frame = CGRectInset(frame, 1, 1);
        return frame;
    }
    
    if (self.currentRowNumber >= TotalUnitCountInHeight)
    {
        // 流布局已经完成，停止剩下的单元格流布局
        unit.colIndex = 4;
        unit.rowIndex = 0;
        frame.origin.x = unit.colIndex * unitWidth;
        frame.origin.y = unit.rowIndex * HeightPerRow;
        frame = CGRectInset(frame, 1, 1);
        return frame;
    }
    
    // 流空间布局
    if ([self currentPositionIsAvaliableForUnitW:wUnit andUnitH:hUnit])
    {
        NSLog(@"%@ 使用流布局剩余空间", unit);
        // 使用当前位置布局
        unit.colIndex = self.currentColumnNumber;
        unit.rowIndex = self.currentRowNumber;

        // 当前布局如果造成了行高变化，要记录一个SpareSpace
        if (self.currentHeightStep < hUnit)
        {
            SpareSpace* newss = [[SpareSpace alloc] init];
            newss->spareWidth = self.currentColumnNumber;
            newss->spareHeight = hUnit - self.currentHeightStep;
            newss->spareColIndex = 0;
            newss->spareRowIndex = self.currentRowNumber + 1;
            [self addNewSpareSpace:newss];
            self.currentHeightStep = hUnit;
        }
        else if (self.currentHeightStep > hUnit)
        {
            SpareSpace* newss = [[SpareSpace alloc] init];
            newss->spareWidth = wUnit;
            newss->spareHeight = self.currentHeightStep - hUnit;
            newss->spareColIndex = self.currentColumnNumber;
            newss->spareRowIndex = self.currentRowNumber + 1;
            [self addNewSpareSpace:newss];
        }        

        self.currentColumnNumber += wUnit;
        if (self.currentColumnNumber >= 4)
        {
            // 流布局切换到新行时，重设行高默认为1
            self.currentRowNumber += self.currentHeightStep;
            self.currentHeightStep = 1;
            self.currentColumnNumber = 0;
        }
    }
    else
    {
        // 定义当前流剩余位置为空余位置的空间，不能布局下一个单元时即需要保存它。
        SpareSpace* newss = [[SpareSpace alloc] init];
        newss->spareWidth = TotalUnitCountInWidth - self.currentColumnNumber;
        newss->spareHeight = self.currentHeightStep;
        newss->spareColIndex = self.currentColumnNumber;
        newss->spareRowIndex = self.currentRowNumber;
        [self addNewSpareSpace:newss];

        // 开新行位置进行布局
        self.currentRowNumber += self.currentHeightStep;
        self.currentHeightStep = hUnit;
        self.currentColumnNumber = 0;
        
        if ([self currentPositionIsAvaliableForUnitW:wUnit andUnitH:hUnit])
        {
            NSLog(@"%@ 使用新行空间", unit);
            unit.colIndex = self.currentColumnNumber;
            unit.rowIndex = self.currentRowNumber;
        }
        else
        {
            // 开了新行还放不下新的单元就得报错了（该Frame会放在一个不可见位置）
            unit.colIndex = 4;  // x起点定义到屏幕宽度会正好使该框不可见
            unit.rowIndex = 0;
            // 即便放不下新的单元，还是把剩下的空间计算到空余空间中
            SpareSpace* newss = [[SpareSpace alloc] init];
            newss->spareWidth = TotalUnitCountInWidth - self.currentColumnNumber;
            newss->spareHeight = TotalUnitCountInHeight - self.currentRowNumber;
            newss->spareColIndex = self.currentColumnNumber;
            newss->spareRowIndex = self.currentRowNumber;
            [self addNewSpareSpace:newss];
            NSLog(@"%@ 没位置了!", unit);
            
            // 将最终的游标位置设到结尾，后面的单元不再参与流布局
            self.currentRowNumber = TotalUnitCountInHeight;
            self.currentColumnNumber = TotalUnitCountInWidth;
        }
        
        self.currentColumnNumber += wUnit;
        if (self.currentColumnNumber >= 4)
        {
            self.currentRowNumber += self.currentHeightStep;
            self.currentColumnNumber = 0;
        }
    }
    frame.origin.x = unit.colIndex * unitWidth;
    frame.origin.y = unit.rowIndex * HeightPerRow;
    frame = CGRectInset(frame, 1, 1);
    return frame;
}

- (void)addNewSpareSpace:(SpareSpace*)newss
{
    if (newss->spareWidth <= 0 || newss->spareHeight <= 0)
        return;
    
    // 新加一个SpareSpace之前要先判断一下是否可以和现有的SpareSpace进行合并
    for (int i = 0; i < self.spareSpaces.count; i++)
    {
        SpareSpace* ss = (SpareSpace*)[self.spareSpaces objectAtIndex:i];
        if (ss->spareRowIndex == newss->spareRowIndex && ss->spareHeight == newss->spareHeight
            && (ss->spareColIndex + ss->spareWidth) == newss->spareColIndex)
        {
            ss->spareWidth = ss->spareWidth + newss->spareWidth;
            return;
        }
        if (ss->spareColIndex == newss->spareColIndex && ss->spareWidth == newss->spareWidth
            && (ss->spareRowIndex + ss->spareHeight) == newss->spareRowIndex)
        {
            ss->spareHeight = ss->spareHeight + newss->spareHeight;
            return;
        }
    }
    [self.spareSpaces addObject:newss];
}

- (SpareSpace *)sparePositionIsAvaliableForUnitW:(NSInteger)wUnit andUnitH:(NSInteger)hUnit
{
    for (int i = 0; i < self.spareSpaces.count; i++)
    {
        SpareSpace* ss = (SpareSpace*)[self.spareSpaces objectAtIndex:i];
        if (ss->spareWidth >= wUnit && ss->spareHeight >= hUnit)
            return ss;
    }
    return nil;
}

- (bool)currentPositionIsAvaliableForUnitW:(NSInteger)wUnit andUnitH:(NSInteger)hUnit
{
    if ((wUnit + self.currentColumnNumber) > TotalUnitCountInWidth
        || (hUnit + self.currentRowNumber) > TotalUnitCountInHeight)
        return NO;
    return YES;
}

@end
