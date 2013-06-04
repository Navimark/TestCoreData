//
//  AppDelegate.h
//  TestCoreData
//
//  Created by Mike Chen on 13-6-3.
//  Copyright (c) 2013年 BeyondSoft Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PersonListViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic , retain) PersonListViewController *personListViewController;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
