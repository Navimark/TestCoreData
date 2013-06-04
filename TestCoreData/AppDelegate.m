//
//  AppDelegate.m
//  TestCoreData
//
//  Created by Mike Chen on 13-6-3.
//  Copyright (c) 2013年 BeyondSoft Co.,Ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "Person.h"
#import "PersonListViewController.h"

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [_managedObjectContext release];
    [_managedObjectModel release];
    [_persistentStoreCoordinator release];
    [_personListViewController release];
    [super dealloc];
}

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize personListViewController = _personListViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.

//    [self createNewPersonWithFirstName:@"chen" lastName:@"zheng" age:100];
//    [self createNewPersonWithFirstName:@"陈" lastName:@"政" age:101];
//    [self createNewPersonWithFirstName:@"google" lastName:@"facebook" age:10];
//
//    [self readPersonsInCoreData];
////    [self deleteObect];
//    [self sortData];
//     [self readPersonsInCoreData];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    PersonListViewController *personListViewController = [[[PersonListViewController alloc] init] autorelease];
    UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:personListViewController] autorelease];
    navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.window.rootViewController = navigationController;
    
    return YES;
}

- (void)sortData
{
    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:self.managedObjectContext];
    NSSortDescriptor *ageSort = [[[NSSortDescriptor alloc] initWithKey:@"age" ascending:YES] autorelease];
    NSSortDescriptor *firstNameSort = [[[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES] autorelease];
    NSArray *sortDescriptors = @[ageSort,firstNameSort];
    fetchRequest.sortDescriptors = sortDescriptors;
    [fetchRequest setEntity:entity];
    //注意：这里的排序是针对取出来的数据，对coredata存储的数组不排序
    NSError *requestError = nil;
    NSArray *persons = [self.managedObjectContext executeFetchRequest:fetchRequest error:&requestError];
    for (Person *thisPerson in persons) {
        NSLog(@"人是:%@ %@,年龄:%@",thisPerson.firstName,thisPerson.lastName,thisPerson.age);
    }
}

- (void)deleteObect
{
    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *requestError = nil;
    NSArray *persons = [self.managedObjectContext executeFetchRequest:fetchRequest error:&requestError];
    if ([persons count] > 0 ) {
        Person *lastPerson = [persons lastObject];
        [self deleteObjectByContext:lastPerson];
    } else {
        NSLog(@"Could not find any Person entities in the context.");
    }
}

//删除
- (BOOL)deleteObjectByContext:(NSManagedObject *)paramObject
{
    [self.managedObjectContext deleteObject:paramObject];
    if ([paramObject isDeleted]) {
        NSLog(@"Successfully deleted the Person:%@",[(Person *)paramObject firstName]);
        NSError *savingError = nil;
        if ([self.managedObjectContext save:&savingError]) {
            NSLog(@"Successfully saved the context.");
            return YES;
        } else{
            NSLog(@"Failed to save the context.");
            return NO;
        }
    } else{
        NSLog(@"Failed to delete the last person.");
        return NO;
    }
}
//使用CoreData读取实体内容
- (void)readPersonsInCoreData
{
    //Create the fetch request first
    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:self.managedObjectContext];
    //Tell the request that we want to read the contents of the Person entity
    [fetchRequest setEntity:entity];
    NSError *requestError = nil;
    NSArray *persons = [self.managedObjectContext executeFetchRequest:fetchRequest error:&requestError];
    if ([persons count] > 0) {
        //遍历数组
        NSUInteger counter = 1;
        for (Person *thisPerson in persons) {
            NSLog(@"第%d个人是:%@ %@,年龄:%@",counter,thisPerson.firstName,thisPerson.lastName,thisPerson.age);
            ++counter;
        }
    } else{
        NSLog(@"Could not find any Person entities in the context.");
    }
    NSLog(@"\n\n\n");
}

//创建对象，并保存
- (Person *)createNewPersonWithFirstName:(NSString *)paramFirstName lastName:(NSString *)paramLastName age:(NSUInteger)paramAge
{
//    BOOL result = NO;
    if ([paramFirstName length] == 0 || [paramLastName length] == 0) {
        NSLog(@"First and Last names are mandatory.");
        return nil;
    }
    //下面在已知的管理对象上下文里查找已知的实体，假设这个实体被找出来了，那个这个方法将返回这个实体的一个新实例。
    Person *newPerson = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:self.managedObjectContext];
    if (!newPerson) {
        NSLog(@"Failed to create the new person.");
        return newPerson;
    }
    newPerson.firstName = paramFirstName;
    newPerson.lastName = paramLastName;
    newPerson.age = [NSNumber numberWithUnsignedInteger:paramAge];
    NSError *savingError = nil;
    if ([self.managedObjectContext save:&savingError]) {
        return YES;
    } else{
        NSLog(@"Failed to save the new person.Error = %@",savingError);
    }
    return newPerson;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"TestCoreData" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"TestCoreData.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
