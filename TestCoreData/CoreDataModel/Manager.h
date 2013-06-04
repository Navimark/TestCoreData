//
//  Manager.h
//  TestCoreData
//
//  Created by Mike Chen on 13-6-4.
//  Copyright (c) 2013年 BeyondSoft Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Employ;

@interface Manager : NSManagedObject

@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSSet *fKManagerToEmplyees;
@end

@interface Manager (CoreDataGeneratedAccessors)

- (void)addFKManagerToEmplyeesObject:(Employ *)value;
- (void)removeFKManagerToEmplyeesObject:(Employ *)value;
- (void)addFKManagerToEmplyees:(NSSet *)values;
- (void)removeFKManagerToEmplyees:(NSSet *)values;

@end
