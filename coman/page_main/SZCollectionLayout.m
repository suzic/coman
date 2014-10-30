//
//  SZCollectionLayout.m
//  coman
//
//  Created by 苏智 on 14-9-4.
//  Copyright (c) 2014年 Suzic. All rights reserved.
//

#import "SZCollectionLayout.h"
#import "SZCollectionDataSource.h"
#import "SZAppDelegate.h"

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
    SZAppDelegate* ad = (SZAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    // Don't scroll horizontally
    CGFloat contentWidth = self.collectionView.bounds.size.width;
    
    // Scroll vertically to display a full day
    CGFloat contentHeight = ad.HeightPerRow * ad.TotalUnitCountInHeight + ad.CellInsect;
    
    CGSize contentSize = CGSizeMake(contentWidth, contentHeight);
    return contentSize;
}

// 对可见的格子应用内部布局
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    self.currentRowNumber = 0;
    self.currentColumnNumber = 0;
    self.currentHeightStep = 1;
    [self.spareSpaces removeAllObjects];
    
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
    return YES;
}

#pragma mark - Helpers of get the visible cells

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
    SZAppDelegate* ad = (SZAppDelegate*)[[UIApplication sharedApplication] delegate];
    CGFloat contentWidth = [self collectionViewContentSize].width;
    CGFloat widthPerCol = contentWidth / ad.TotalUnitCountInWidth;
    NSInteger colIndex = MAX((NSInteger)0, (NSInteger)(xPosition / widthPerCol));
    return colIndex;
}

- (NSInteger)rowIndexFromYCoordinate:(CGFloat)yPosition
{
    SZAppDelegate* ad = (SZAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSInteger rowIndex = MAX((NSInteger)0, (NSInteger)(yPosition / ad.HeightPerRow));
    return rowIndex;
}

#pragma mark - Kernal Calculate layout functions

// 计算一个单元的尺寸和布局
- (CGRect)frameForUnit:(id<SZCellUnit>)unit
{
    SZAppDelegate* ad = (SZAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    // 根据实际设备尺寸获取宽度（高度则是固定的）
    CGFloat totalWidth = [self collectionViewContentSize].width;
    CGFloat unitWidth = (totalWidth - ad.CellInsect) / ad.TotalUnitCountInWidth;

    // 根据cell type计算出其尺寸
    NSInteger cellType = unit.cellSizeType;
    NSInteger hUnit = cellType / ad.TotalUnitCountInWidth + 1;
    NSInteger wUnit = cellType % ad.TotalUnitCountInWidth + 1;
    CGFloat cellWidth = unitWidth * wUnit;
    CGFloat cellHeight = ad.HeightPerRow * hUnit;
    
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
        
        frame.origin.x = unit.colIndex * unitWidth + ad.CellInsect / 2;
        frame.origin.y = unit.rowIndex * ad.HeightPerRow + ad.CellInsect / 2;
        frame = CGRectInset(frame, ad.CellInsect / 2, ad.CellInsect / 2);
        return frame;
    }
    
    // 流布局已经完成，停止剩下的单元格流布局
    if (self.currentRowNumber >= ad.TotalUnitCountInHeight)
    {
        NSLog(@"%@ 无处安置……", unit);
        
        unit.colIndex = ad.TotalUnitCountInWidth; // 该位置必定超出行宽，看不到
        unit.rowIndex = 0;
        frame.origin.x = unit.colIndex * unitWidth + ad.CellInsect / 2;
        frame.origin.y = unit.rowIndex * ad.HeightPerRow + ad.CellInsect / 2;
        frame = CGRectInset(frame, ad.CellInsect / 2, ad.CellInsect / 2);
        return frame;
    }
    
    // 流空间布局
    if ([self currentPositionIsAvaliableForUnitW:wUnit andUnitH:hUnit])
    {
        NSLog(@"%@ 使用流布局 - 行内", unit);
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
            newss->spareRowIndex = self.currentRowNumber + self.currentHeightStep;
            [self addNewSpareSpace:newss];
            self.currentHeightStep = hUnit;
        }
        else if (self.currentHeightStep > hUnit)
        {
            SpareSpace* newss = [[SpareSpace alloc] init];
            newss->spareWidth = wUnit;
            newss->spareHeight = self.currentHeightStep - hUnit;
            newss->spareColIndex = self.currentColumnNumber;
            newss->spareRowIndex = self.currentRowNumber + hUnit;
            [self addNewSpareSpace:newss];
        }        

        self.currentColumnNumber += wUnit;
        if (self.currentColumnNumber >= ad.TotalUnitCountInWidth)
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
        newss->spareWidth = ad.TotalUnitCountInWidth - self.currentColumnNumber;
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
            NSLog(@"%@ 使用流布局 - 新行", unit);
            unit.colIndex = self.currentColumnNumber;
            unit.rowIndex = self.currentRowNumber;
        }
        else
        {
            // 开了新行还放不下新的单元就得报错了（该Frame会放在一个不可见位置）
            unit.colIndex = ad.TotalUnitCountInWidth;  // x起点定义到屏幕宽度会正好使该框不可见
            unit.rowIndex = 0;
            // 即便放不下新的单元，还是把剩下的空间计算到空余空间中
            SpareSpace* newss = [[SpareSpace alloc] init];
            newss->spareWidth = ad.TotalUnitCountInWidth - self.currentColumnNumber;
            newss->spareHeight = ad.TotalUnitCountInHeight - self.currentRowNumber;
            newss->spareColIndex = self.currentColumnNumber;
            newss->spareRowIndex = self.currentRowNumber;
            [self addNewSpareSpace:newss];
            NSLog(@"%@ 流布局空间告罄!", unit);
            
            // 将最终的游标位置设到结尾，后面的单元不再参与流布局
            self.currentRowNumber = ad.TotalUnitCountInHeight;
            self.currentColumnNumber = ad.TotalUnitCountInWidth;
        }
        
        self.currentColumnNumber += wUnit;
        if (self.currentColumnNumber >= ad.TotalUnitCountInWidth)
        {
            self.currentRowNumber += self.currentHeightStep;
            self.currentColumnNumber = 0;
        }
    }
    frame.origin.x = unit.colIndex * unitWidth + ad.CellInsect / 2;
    frame.origin.y = unit.rowIndex * ad.HeightPerRow + ad.CellInsect / 2;
    frame = CGRectInset(frame, ad.CellInsect / 2, ad.CellInsect / 2);
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
    SZAppDelegate* ad = (SZAppDelegate*)[[UIApplication sharedApplication] delegate];
    if ((wUnit + self.currentColumnNumber) > ad.TotalUnitCountInWidth
        || (hUnit + self.currentRowNumber) > ad.TotalUnitCountInHeight)
        return NO;
    return YES;
}

@end
