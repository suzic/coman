//
//  SZAppDelegate.h
//  coman
//
//  Created by 苏智 on 14-9-3.
//  Copyright (c) 2014年 Suzic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SZAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
