//
//  constants.h
//  coman
//
//  Created by 苏智 on 14-9-3.
//  Copyright (c) 2014年 Suzic. All rights reserved.
//

#ifndef coman_constants_h
#define coman_constants_h

/**
 * @abstract Define the cell size types
 */
typedef enum _CellType
{
    // Signle row-height type
	CellType_Unit   = 0,    // 1 x 1
    CellType_Small  = 1,    // 2 x 1
    CellType_Wide   = 2,    // 3 x 1
    CellType_Banner = 3,    // 4 x 1
    
    // Double row-height type
    CellType_Book   = 4,    // 1 x 2
    CellType_Block  = 5,    // 2 x 2
    CellType_Large  = 6,    // 3 x 2
    CellType_Great  = 7     // 4 x 2
    
    // More ? Anyway, There are always 4 kinds of width for a row-height type
    // Use / to get row-height type and % to get width kind.
} CellType;

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
