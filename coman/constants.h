//
//  constants.h
//  coman
//
//  Created by 苏智 on 14-9-3.
//  Copyright (c) 2014年 Suzic. All rights reserved.
//

#ifndef coman_constants_h
#define coman_constants_h

static const NSUInteger TotalUnitCountInWidth = 5;
static const NSUInteger TotalUnitCountInHeight = 8;
static const NSUInteger MaxCellHeightUnit = 3;
static const CGFloat CellInsect = 1;
static const CGFloat HeightPerRow = 320 / TotalUnitCountInWidth;

/**
 * @abstract Show left category screen
 */
#define ShowLeftCategories   @"ShowLeftCategories"

/**
 * @abstract Show right toolkits screen
 */
#define ShowRightToolkis   @"ShowRightToolkis"

/**
 * @abstract Back to center screen
 */
#define BackToCenterScreen @"BackToCenterScreen"

/**
 * @abstract Reload main screen data source
 */
#define ReloadMainPageDataSource @"ReloadMainPageDataSource"

#endif
