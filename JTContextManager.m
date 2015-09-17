//
//  JTContextManager.m
//  aaaaaa
//
//  Created by tmy on 13-8-5.
//  Copyright (c) 2013年 kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTContextManager.h"

static JTContextManager * SharedManager = nil;
static NSString *StoreName = nil;

#define kPropertyName @"PropertyName"
#define kPropertyType @"PropertyType"

@implementation JTContextManager
@synthesize backgroundContext = _backgroundContext;
@synthesize mainContext = _mainContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


+ (JTContextManager *)sharedManager
{
    @synchronized(self)
    {
        if(!SharedManager)
        {
            SharedManager = [[super allocWithZone:nil] init];
        }
    }
    
    return SharedManager;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[JTContextManager sharedManager] retain];
}

- (NSUInteger)retainCount
{
    return UINT_MAX;
}

- (id)retain
{
    return self;
}

- (oneway void)release
{
    
}

- (id)init
{
    if(self = [super init])
    {
        if(!StoreName)
        {
            StoreName = [NSBundle mainBundle].infoDictionary[@"CFBundleName"];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(save) name:UIApplicationWillResignActiveNotification object:nil];
    }
    
    return self;
}


- (void)dealloc
{
    [_backgroundContext release];
    [_managedObjectModel release];
    [_persistentStoreCoordinator release];
    [super dealloc];
}

+ (void)setupStoreName:(NSString *)name
{
    StoreName = [name copy];
}

#pragma mark - Core Data stack
- (void)save
{
    NSError *error = nil;

    if(self.mainContext && [self.mainContext hasChanges]){
        [self.mainContext save:&error];
    }
    
    if(error){
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
   
    if(self.backgroundContext && [self.backgroundContext hasChanges]){
        [self.backgroundContext save:&error];
    }

     
    if(error){
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
}

- (NSManagedObjectContext *)backgroundContext
{
    if (_backgroundContext != nil) {
        return _backgroundContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _backgroundContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_backgroundContext setPersistentStoreCoordinator:coordinator];
        NSUndoManager *undoManager = [[NSUndoManager alloc] init];
        [_backgroundContext setUndoManager:undoManager];
        [undoManager release];
    }
    return _backgroundContext;
}

- (NSManagedObjectContext *)mainContext
{
    if(!_mainContext){
        _mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_mainContext setPersistentStoreCoordinator:[self persistentStoreCoordinator]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onManagedObjectContextChanged:) name:NSManagedObjectContextDidSaveNotification object:nil];
        
        NSUndoManager *undoManager = [[NSUndoManager alloc] init];
        [_mainContext setUndoManager:undoManager];
    }
    
    return _mainContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:StoreName withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",StoreName]];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:@{NSMigratePersistentStoresAutomaticallyOption: @(YES),NSInferMappingModelAutomaticallyOption:@(YES)} error:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)onManagedObjectContextChanged:(NSNotification *)notification
{
   dispatch_async(dispatch_get_main_queue(), ^{
       [self.mainContext mergeChangesFromContextDidSaveNotification:notification];
   });
}


@end
