//
//  NSManagedObject+JTCoreData.m
//  aaaaaa
//
//  Created by tmy on 13-8-5.
//  Copyright (c) 2013年 kingnet. All rights reserved.
//

#import "NSManagedObject+JTCoreData.h"
#import "JTContextManager.h"

@implementation NSManagedObject (JTCoreData)

+ (NSString *)entityName
{
    return NSStringFromClass(self);
}

+ (void)performInBackground:(void (^)(NSManagedObjectContext *))backgroundBlock
{
    if(backgroundBlock)
    {
        __block NSManagedObjectContext *__context = [JTContextManager sharedManager].backgroundContext;
        [__context performBlock:^{
            backgroundBlock(__context);
        }];
    
    }
}

+ (id)insert
{
    return [self insertInContext:[[JTContextManager sharedManager] mainContext]];
}

+ (id)insertInContext:(NSManagedObjectContext *)context
{
    id newObject = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(self) inManagedObjectContext:context];
    return newObject;
}

+ (NSArray *)all
{
    NSManagedObjectContext *context = [[JTContextManager sharedManager] mainContext];
    return [self allInContext:context];
}

+ (NSArray *)allInContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass(self) inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
  
    return fetchedObjects;
}

+ (NSFetchedResultsController *)allResultsWithSectionKey:(NSString *)sectionKey
                                                 sortKey:(NSString *)sortKey
                                                     asc:(BOOL)isAsc
{
    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass(self) inManagedObjectContext:[[JTContextManager sharedManager] mainContext]];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:50];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:isAsc];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    fetchRequest.sortDescriptors = sortDescriptors;
    [sortDescriptor release];
    [sortDescriptors release];
    
    [NSFetchedResultsController deleteCacheWithName:[NSString stringWithFormat:@"%@_%@_%@_%d",NSStringFromClass(self),sectionKey?sectionKey:@"",sortKey,isAsc]];
    
    NSFetchedResultsController *fetchController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[[JTContextManager sharedManager] mainContext] sectionNameKeyPath:sectionKey cacheName:[NSString stringWithFormat:@"%@_%@_%@_%d",NSStringFromClass(self),sectionKey?sectionKey:@"",sortKey,isAsc]];
    
    return [fetchController autorelease];
}


+ (NSArray *)allWithSortBy:(NSString *)sortBy
                       asc:(BOOL)isAsc
{
    NSManagedObjectContext *context = [[JTContextManager sharedManager] mainContext];
    return [self allWithSortBy:sortBy asc:isAsc inContext:context];
}

+ (NSArray *)allWithSortBy:(NSString *)sortBy
                       asc:(BOOL)isAsc
                 inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass(self) inManagedObjectContext:context];
    [request setEntity:entity];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortBy ascending:isAsc];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    [sortDescriptors release];
    [sortDescriptor release];
    return  [context executeFetchRequest:request error:nil];
}

+ (NSArray *)allWithPageIndex:(int)page
                     pageSize:(int)pageSize
                       sortBy:(NSString *)sortBy
                          asc:(BOOL)isAsc
{
    return [self allWithPageIndex:page pageSize:pageSize sortBy:sortBy asc:isAsc inContext:[[JTContextManager sharedManager] mainContext]];
}

+ (NSArray *)allWithPageIndex:(int)page
                     pageSize:(int)pageSize
                       sortBy:(NSString *)sortBy
                          asc:(BOOL)isAsc inContext:(NSManagedObjectContext *)context
{
    if(page<0 || pageSize == 0)
    {
        return [NSArray array];
    }
    else
    {
        NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
        NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass(self) inManagedObjectContext:context];
        [request setEntity:entity];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortBy ascending:isAsc];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        [request setSortDescriptors:sortDescriptors];
        [request setFetchLimit:pageSize];
        [request setFetchOffset:page * pageSize];
        [sortDescriptors release];
        [sortDescriptor release];
        return  [context executeFetchRequest:request error:nil];
    }
}

+ (void)deleteAll
{
    [self deleteAllInContext:[[JTContextManager sharedManager] mainContext]];
}

+ (void)deleteAllInContext:(NSManagedObjectContext *)context
{
    NSArray *objects = [self allInContext:context];
    [objects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj delete];
    }];
    
    [context save:nil];
}

+ (NSArray *)internelWherePredicate:(NSPredicate *)predicate
                    inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass(self) inManagedObjectContext:context];
    [request setEntity:entity];
    [request setPredicate:predicate];
    return  [context executeFetchRequest:request error:nil];
}

+ (NSFetchedResultsController *)internelWherePredicate:(NSPredicate *)predicate
                                             sectionKey:(NSString *)sectionKey
                                                sortKey:(NSString *)sortKey
                                                    asc:(BOOL)isAsc
{
    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass(self) inManagedObjectContext:[[JTContextManager sharedManager] mainContext]];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:50];
    [fetchRequest setPredicate:predicate];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:isAsc];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    fetchRequest.sortDescriptors = sortDescriptors;
    [sortDescriptor release];
    [sortDescriptors release];
    
    NSString *cacheName = [NSString stringWithFormat:@"%@_%@_%@_%@_%d",NSStringFromClass(self),[predicate predicateFormat],(sectionKey?sectionKey:@""),sortKey,isAsc];
    
    [NSFetchedResultsController deleteCacheWithName:cacheName];
    NSFetchedResultsController *fetchController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[[JTContextManager sharedManager] mainContext] sectionNameKeyPath:sectionKey cacheName:cacheName];
    
    return [fetchController autorelease];

}

+ (NSArray *)whereKey:(NSString *)key equalTo:(id)object
{
    return [self internelWherePredicate:[NSPredicate predicateWithFormat:@"%K == %@",key,object] inContext:[[JTContextManager sharedManager] mainContext]];
}

+ (NSArray *)whereKey:(NSString *)key equalTo:(id)object inContext:(NSManagedObjectContext *)context
{
    return [self internelWherePredicate:[NSPredicate predicateWithFormat:@"%K == %@",key,object] inContext:context];
}

+ (NSFetchedResultsController *)whereKey:(NSString *)key equalTo:(id)object sectionKey:(NSString *)sectionKey sortKey:(NSString *)sortKey asc:(BOOL)isAsc
{
    return [self internelWherePredicate:[NSPredicate predicateWithFormat:@"%K == %@",key,object] sectionKey:sectionKey sortKey:sortKey asc:isAsc];
}

+ (NSArray *)whereKey:(NSString *)key notEqualTo:(id)object
{
    return [self internelWherePredicate:[NSPredicate predicateWithFormat:@"%K != %@",key,object] inContext:[[JTContextManager sharedManager] mainContext]];
}

+ (NSArray *)whereKey:(NSString *)key notEqualTo:(id)object inContext:(NSManagedObjectContext *)context
{
    return [self internelWherePredicate:[NSPredicate predicateWithFormat:@"%K != %@",key,object] inContext:context];
}

+ (NSFetchedResultsController *)whereKey:(NSString *)key notEqualTo:(id)object sectionKey:(NSString *)sectionKey sortKey:(NSString *)sortKey asc:(BOOL)isAsc
{
    return [self internelWherePredicate:[NSPredicate predicateWithFormat:@"%K != %@",key,object] sectionKey:sectionKey sortKey:sortKey asc:isAsc];
}

+ (NSArray *)whereKey:(NSString *)key lessThan:(id)object
{
    return [self internelWherePredicate:[NSPredicate predicateWithFormat:@"%K < %@",key,object] inContext:[[JTContextManager sharedManager] mainContext]];
}

+ (NSArray *)whereKey:(NSString *)key lessThan:(id)object inContext:(NSManagedObjectContext *)context
{
    return [self internelWherePredicate:[NSPredicate predicateWithFormat:@"%K < %@",key,object] inContext:context];
}

+ (NSFetchedResultsController *)whereKey:(NSString *)key lessThan:(id)object sectionKey:(NSString *)sectionKey sortKey:(NSString *)sortKey asc:(BOOL)isAsc
{
    return [self internelWherePredicate:[NSPredicate predicateWithFormat:@"%K < %@",key,object] sectionKey:sectionKey sortKey:sortKey asc:isAsc];
}

+ (NSArray *)whereKey:(NSString *)key lessThanOrEqualTo:(id)object
{
   return [self internelWherePredicate:[NSPredicate predicateWithFormat:@"%K <= %@",key,object] inContext:[[JTContextManager sharedManager] mainContext]];
}

+ (NSArray *)whereKey:(NSString *)key lessThanOrEqualTo:(id)object inContext:(NSManagedObjectContext *)context
{
    return [self internelWherePredicate:[NSPredicate predicateWithFormat:@"%K <= %@",key,object] inContext:context];
}

+ (NSFetchedResultsController *)whereKey:(NSString *)key lessThanOrEqualTo:(id)object sectionKey:(NSString *)sectionKey sortKey:(NSString *)sortKey asc:(BOOL)isAsc
{
    return [self internelWherePredicate:[NSPredicate predicateWithFormat:@"%K <= %@",key,object] sectionKey:sectionKey sortKey:sortKey asc:isAsc];
}

+ (NSArray *)whereKey:(NSString *)key greaterThan:(id)object
{
    return [self internelWherePredicate:[NSPredicate predicateWithFormat:@"%K > %@",key,object] inContext:[[JTContextManager sharedManager] mainContext]];
}

+ (NSArray *)whereKey:(NSString *)key greaterThan:(id)object inContext:(NSManagedObjectContext *)context
{
    return [self internelWherePredicate:[NSPredicate predicateWithFormat:@"%K > %@",key,object] inContext:context];
}

+ (NSFetchedResultsController *)whereKey:(NSString *)key greaterThan:(id)object sectionKey:(NSString *)sectionKey sortKey:(NSString *)sortKey asc:(BOOL)isAsc
{
    return [self internelWherePredicate:[NSPredicate predicateWithFormat:@"%K > %@",key,object] sectionKey:sectionKey sortKey:sortKey asc:isAsc];
}

+ (NSArray *)whereKey:(NSString *)key greaterThanOrEqualTo:(id)object
{
    return [self internelWherePredicate:[NSPredicate predicateWithFormat:@"%K >= %@",key,object] inContext:[[JTContextManager sharedManager] mainContext]];
}

+ (NSArray *)whereKey:(NSString *)key greaterThanOrEqualTo:(id)object inContext:(NSManagedObjectContext *)context
{
    return [self internelWherePredicate:[NSPredicate predicateWithFormat:@"%K >= %@",key,object] inContext:context];
}

+ (NSFetchedResultsController *)whereKey:(NSString *)key greaterThanOrEqualTo:(id)object sectionKey:(NSString *)sectionKey sortKey:(NSString *)sortKey asc:(BOOL)isAsc
{
    return [self internelWherePredicate:[NSPredicate predicateWithFormat:@"%K >= %@",key,object] sectionKey:sectionKey sortKey:sortKey asc:isAsc];
}

+ (NSArray *)whereKey:(NSString *)key hasPrefix:(id)object
{
    return [self whereKey:key hasPrefix:object inContext:[[JTContextManager sharedManager] mainContext]];
}

+ (NSArray *)whereKey:(NSString *)key hasPrefix:(id)object inContext:(NSManagedObjectContext *)context
{
    return [self wherePredicate:[NSPredicate predicateWithFormat:@"%K BEGINSWITH %@",key,object] inContext:context];
}

+ (NSFetchedResultsController *)whereKey:(NSString *)key hasPrefix:(id)object sectionKey:(NSString *)sectionKey sortKey:(NSString *)sortKey asc:(BOOL)isAsc
{
    return [self wherePredicate:[NSPredicate predicateWithFormat:@"%K BEGINSWITH %@",key,object] sectionKey:sectionKey sortKey:sortKey asc:isAsc];
}

+ (NSArray *)whereKey:(NSString *)key hasSuffix:(id)object
{
    return [self whereKey:key hasSuffix:object inContext:[[JTContextManager sharedManager] mainContext]];
}

+ (NSArray *)whereKey:(NSString *)key hasSuffix:(id)object inContext:(NSManagedObjectContext *)context
{
    return [self wherePredicate:[NSPredicate predicateWithFormat:@"%K ENDSWITH %@",key,object] inContext:context];
}

+ (NSFetchedResultsController *)whereKey:(NSString *)key hasSuffix:(id)object sectionKey:(NSString *)sectionKey sortKey:(NSString *)sortKey asc:(BOOL)isAsc
{
    return [self wherePredicate:[NSPredicate predicateWithFormat:@"%K ENDSWITH %@",key,object] sectionKey:sectionKey sortKey:sortKey asc:isAsc];
}

+ (NSArray *)whereKey:(NSString *)key contains:(id)object
{
    return [self whereKey:key contains:object inContext:[[JTContextManager sharedManager] mainContext]];
}

+ (NSArray *)whereKey:(NSString *)key contains:(id)object inContext:(NSManagedObjectContext *)context
{
    return [self wherePredicate:[NSPredicate predicateWithFormat:@"%K CONTAINS %@",key,object] inContext:context];
}

+ (NSFetchedResultsController *)whereKey:(NSString *)key contains:(id)object sectionKey:(NSString *)sectionKey sortKey:(NSString *)sortKey asc:(BOOL)isAsc
{
    return [self wherePredicate:[NSPredicate predicateWithFormat:@"%K CONTAINS %@",key,object] sectionKey:sectionKey sortKey:sortKey asc:isAsc];
}

+ (NSArray *)whereKey:(NSString *)key containedIn:(NSArray *)objects
{
    return [self whereKey:key containedIn:objects inContext:[[JTContextManager sharedManager] mainContext]];
}

+ (NSArray *)whereKey:(NSString *)key containedIn:(NSArray *)objects inContext:(NSManagedObjectContext *)context
{
    NSString *objectsStr = [objects componentsJoinedByString:@","];
    return [self wherePredicate:[NSPredicate predicateWithFormat:@"%k IN {%@}",key,objectsStr] inContext:context];
}

+ (NSFetchedResultsController *)whereKey:(NSString *)key containedIn:(id)objects sectionKey:(NSString *)sectionKey sortKey:(NSString *)sortKey asc:(BOOL)isAsc
{
    NSString *objectsStr = [objects componentsJoinedByString:@","];
    return [self wherePredicate:[NSPredicate predicateWithFormat:@"%k IN {%@}",key,objectsStr] sectionKey:sectionKey sortKey:sortKey asc:isAsc];
}

+ (NSArray *)whereKey:(NSString *)key notContainedIn:(NSArray *)objects
{
    return [self whereKey:key notContainedIn:objects inContext:[[JTContextManager sharedManager] mainContext]];
}

+ (NSArray *)whereKey:(NSString *)key notContainedIn:(NSArray *)objects inContext:(NSManagedObjectContext *)context
{
    NSString *objectsStr = [objects componentsJoinedByString:@","];
    return [self wherePredicate:[NSPredicate predicateWithFormat:@"NOT (%K IN {%@})",key,objectsStr] inContext:context];
}

+ (NSFetchedResultsController *)whereKey:(NSString *)key notContainedIn:(id)objects sectionKey:(NSString *)sectionKey sortKey:(NSString *)sortKey asc:(BOOL)isAsc
{
    NSString *objectsStr = [objects componentsJoinedByString:@","];
    return [self wherePredicate:[NSPredicate predicateWithFormat:@"NOT (%K IN {%@})",key,objectsStr] sectionKey:sectionKey sortKey:sortKey asc:isAsc];
}

+ (NSArray *)wherePredicate:(NSPredicate *)predicate
{
    return [self wherePredicate:predicate inContext:[[JTContextManager sharedManager] mainContext]];
}

+ (NSArray *)wherePredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context
{ 
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass(self) inManagedObjectContext:context];
    [request setEntity:entity];
    [request setPredicate:predicate];
    return  [context executeFetchRequest:request error:nil];
}

+ (NSFetchedResultsController *)wherePredicate:(NSPredicate *)predicate
                                    sectionKey:(NSString *)sectionKey
                                       sortKey:(NSString *)sortKey
                                           asc:(BOOL)isAsc
{
    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass(self) inManagedObjectContext:[[JTContextManager sharedManager] mainContext]];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:50];
    [fetchRequest setPredicate:predicate];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:isAsc];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    fetchRequest.sortDescriptors = sortDescriptors;
    [sortDescriptor release];
    [sortDescriptors release];
    
    [NSFetchedResultsController deleteCacheWithName:[NSString stringWithFormat:@"%@_%@_%@_%@_%d",NSStringFromClass(self),[predicate predicateFormat],sectionKey?sectionKey:@"",sortKey,isAsc]];
    NSFetchedResultsController *fetchController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[[JTContextManager sharedManager] mainContext] sectionNameKeyPath:sectionKey cacheName:[NSString stringWithFormat:@"%@_%@_%@_%@_%d",NSStringFromClass(self),[predicate predicateFormat],sectionKey?sectionKey:@"",sortKey,isAsc]];
 
    return [fetchController autorelease];

}


+ (NSArray *)wherePredicate:(NSPredicate *)predicate
                  pageIndex:(int)page
                   pageSize:(int)pageSize
                     sortBy:(NSString *)sortBy
                        asc:(BOOL)isAsc
{
    return [self wherePredicate:predicate pageIndex:page pageSize:pageSize sortBy:sortBy asc:isAsc inContext:[[JTContextManager sharedManager] mainContext]];
}

+ (NSArray *)wherePredicate:(NSPredicate *)predicate
                  pageIndex:(int)page
                   pageSize:(int)pageSize
                     sortBy:(NSString *)sortBy
                        asc:(BOOL)isAsc inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass(self) inManagedObjectContext:context];
    [request setEntity:entity];
    [request setFetchLimit:pageSize];
    [request setFetchOffset:page * pageSize];
    [request setPredicate:predicate];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortBy ascending:isAsc];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    request.sortDescriptors = sortDescriptors;
    [sortDescriptor release];
    [sortDescriptors release];
    
    return  [context executeFetchRequest:request error:nil];
    
}

+ (NSArray *)wherePredicate:(NSPredicate *)predicate
                     sortBy:(NSString *)sortBy
                        asc:(BOOL)isAsc
{
    return [self wherePredicate:predicate sortBy:sortBy asc:isAsc inContext:[[JTContextManager sharedManager] mainContext]];
}

+ (NSArray *)wherePredicate:(NSPredicate *)predicate
                     sortBy:(NSString *)sortBy
                        asc:(BOOL)isAsc inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass(self) inManagedObjectContext:context];
    [request setEntity:entity];
    [request setPredicate:predicate];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortBy ascending:isAsc];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    request.sortDescriptors = sortDescriptors;
    [sortDescriptor release];
    [sortDescriptors release];
    
    return  [context executeFetchRequest:request error:nil];
    
}

+ (NSInteger)count
{
   return [self countInContext:[[JTContextManager sharedManager] mainContext]];
}

+ (NSInteger)countInContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setResultType:NSCountResultType];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass(self) inManagedObjectContext:context];
    [request setEntity:entity];
    
    return [context countForFetchRequest:request error:nil];
}

+ (NSInteger)countWherePredicate:(NSPredicate *)predicate
{
   return [self countWherePredicate:predicate inContext:[[JTContextManager sharedManager] mainContext]];
}

+ (NSInteger)countWherePredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setResultType:NSCountResultType];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass(self) inManagedObjectContext:context];
    [request setEntity:entity];
    [request setPredicate:predicate];
    return [context countForFetchRequest:request error:nil];
}

- (void)delete
{
    [self deleteInContext:[[JTContextManager sharedManager] mainContext]];
}

- (void)deleteInContext:(NSManagedObjectContext *)context
{
    [context deleteObject:self];
}

- (void)save
{
    [self saveInContext:[[JTContextManager sharedManager] mainContext]];
}

- (void)saveInContext:(NSManagedObjectContext *)context
{
    [context save:nil];
}

- (void)undo
{
    [self undoInContext:[[JTContextManager sharedManager] mainContext]];
}

- (void)undoInContext:(NSManagedObjectContext *)context
{
    [context undo];
}

- (void)rollback
{
    [self rollbackInContext:[[JTContextManager sharedManager] mainContext]];
}

- (void)rollbackInContext:(NSManagedObjectContext *)context
{
    [context rollback];
}
 
@end
