//
//  Person.h
//  TestCoreData
//
//  Created by Mike Chen on 13-6-3.
//  Copyright (c) 2013年 BeyondSoft Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Person : NSManagedObject

@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;

@end
