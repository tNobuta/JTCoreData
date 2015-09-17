//
//  JTContextManager.h
//  aaaaaa
//
//  Created by tmy on 13-8-5.
//  Copyright (c) 2013年 kingnet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface JTContextManager : NSObject

@property (readonly, nonatomic) NSManagedObjectContext *backgroundContext;
@property (readonly, nonatomic) NSManagedObjectContext *mainContext;
@property (readonly, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (JTContextManager *)sharedManager;
+ (void)setupStoreName:(NSString *)name;

- (void)save;
- (NSURL *)applicationDocumentsDirectory;

@end
