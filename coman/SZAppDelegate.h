//
//  SZAppDelegate.h
//  coman
//
//  Created by 苏智 on 14-9-3.
//  Copyright (c) 2014年 Suzic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SZAppDelegate : UIResponder <UIApplicationDelegate>

@property (assign, nonatomic) NSUInteger MaxCellWidthUnit;
@property (assign, nonatomic) NSUInteger MaxCellHeightUnit;
@property (assign, nonatomic) NSUInteger TotalUnitCountInWidth;
@property (assign, nonatomic) NSUInteger TotalUnitCountInHeight;

@property (assign, nonatomic) CGFloat CellInsect;
@property (assign, nonatomic) CGFloat HeightPerRow;

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)initLayoutParametersW:(NSInteger)mw H:(NSInteger)mh;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
