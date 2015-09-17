//
//  NSManagedObject+JTCoreData.h
//  aaaaaa
//
//  Created by tmy on 13-8-5.
//  Copyright (c) 2013年 kingnet. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (JTCoreData)

+ (NSString *)entityName;

+ (void)performInBackground:(void(^)(NSManagedObjectContext *context))backgroundBlock;

+ (id)insert;
+ (id)insertInContext:(NSManagedObjectContext *)context;

+ (NSArray *)all;
+ (NSArray *)allInContext:(NSManagedObjectContext *)context;

+ (NSFetchedResultsController *)allResultsWithSectionKey:(NSString *)sectionKey
                                                 sortKey:(NSString *)sortKey
                                                     asc:(BOOL)isAsc;

+ (NSArray *)allWithSortBy:(NSString *)sortBy
                       asc:(BOOL)isAsc;
+ (NSArray *)allWithSortBy:(NSString *)sortBy
                       asc:(BOOL)isAsc inContext:(NSManagedObjectContext *)context;

+ (NSArray *)allWithPageIndex:(int)page
                     pageSize:(int)pageSize
                       sortBy:(NSString *)sortBy
                          asc:(BOOL)isAsc;
+ (NSArray *)allWithPageIndex:(int)page
                     pageSize:(int)pageSize
                       sortBy:(NSString *)sortBy
                          asc:(BOOL)isAsc inContext:(NSManagedObjectContext *)context;

+ (NSArray *)whereKey:(NSString *)key equalTo:(id)object;
+ (NSArray *)whereKey:(NSString *)key equalTo:(id)object inContext:(NSManagedObjectContext *)context;
+ (NSFetchedResultsController *)whereKey:(NSString *)key
                                 equalTo:(id)object
                              sectionKey:(NSString *)sectionKey
                                 sortKey:(NSString *)sortKey
                                     asc:(BOOL)isAsc;

+ (NSArray *)whereKey:(NSString *)key notEqualTo:(id)object;
+ (NSArray *)whereKey:(NSString *)key notEqualTo:(id)object inContext:(NSManagedObjectContext *)context;
+ (NSFetchedResultsController *)whereKey:(NSString *)key
                                 notEqualTo:(id)object
                              sectionKey:(NSString *)sectionKey
                                 sortKey:(NSString *)sortKey
                                     asc:(BOOL)isAsc;

+ (NSArray *)whereKey:(NSString *)key lessThan:(id)object;
+ (NSArray *)whereKey:(NSString *)key lessThan:(id)object inContext:(NSManagedObjectContext *)context;
+ (NSFetchedResultsController *)whereKey:(NSString *)key
                                 lessThan:(id)object
                              sectionKey:(NSString *)sectionKey
                                 sortKey:(NSString *)sortKey
                                     asc:(BOOL)isAsc;

+ (NSArray *)whereKey:(NSString *)key lessThanOrEqualTo:(id)object;
+ (NSArray *)whereKey:(NSString *)key lessThanOrEqualTo:(id)object inContext:(NSManagedObjectContext *)context;
+ (NSFetchedResultsController *)whereKey:(NSString *)key
                                 lessThanOrEqualTo:(id)object
                              sectionKey:(NSString *)sectionKey
                                 sortKey:(NSString *)sortKey
                                     asc:(BOOL)isAsc;

+ (NSArray *)whereKey:(NSString *)key greaterThan:(id)object;
+ (NSArray *)whereKey:(NSString *)key greaterThan:(id)object inContext:(NSManagedObjectContext *)context;
+ (NSFetchedResultsController *)whereKey:(NSString *)key
                                 greaterThan:(id)object
                              sectionKey:(NSString *)sectionKey
                                 sortKey:(NSString *)sortKey
                                     asc:(BOOL)isAsc;

+ (NSArray *)whereKey:(NSString *)key greaterThanOrEqualTo:(id)object;
+ (NSArray *)whereKey:(NSString *)key greaterThanOrEqualTo:(id)object inContext:(NSManagedObjectContext *)context;
+ (NSFetchedResultsController *)whereKey:(NSString *)key
                                 greaterThanOrEqualTo:(id)object
                              sectionKey:(NSString *)sectionKey
                                 sortKey:(NSString *)sortKey
                                     asc:(BOOL)isAsc;

+ (NSArray *)whereKey:(NSString *)key hasPrefix:(id)object;
+ (NSArray *)whereKey:(NSString *)key hasPrefix:(id)object inContext:(NSManagedObjectContext *)context;
+ (NSFetchedResultsController *)whereKey:(NSString *)key
                                 hasPrefix:(id)object
                              sectionKey:(NSString *)sectionKey
                                 sortKey:(NSString *)sortKey
                                     asc:(BOOL)isAsc;

+ (NSArray *)whereKey:(NSString *)key hasSuffix:(id)object;
+ (NSArray *)whereKey:(NSString *)key hasSuffix:(id)object inContext:(NSManagedObjectContext *)context;
+ (NSFetchedResultsController *)whereKey:(NSString *)key
                                 hasSuffix:(id)object
                              sectionKey:(NSString *)sectionKey
                                 sortKey:(NSString *)sortKey
                                     asc:(BOOL)isAsc;

+ (NSArray *)whereKey:(NSString *)key contains:(id)object;
+ (NSArray *)whereKey:(NSString *)key contains:(id)object inContext:(NSManagedObjectContext *)context;
+ (NSFetchedResultsController *)whereKey:(NSString *)key
                                 contains:(id)object
                              sectionKey:(NSString *)sectionKey
                                 sortKey:(NSString *)sortKey
                                     asc:(BOOL)isAsc;

+ (NSArray *)whereKey:(NSString *)key containedIn:(NSArray *)objects;
+ (NSArray *)whereKey:(NSString *)key containedIn:(NSArray *)objects inContext:(NSManagedObjectContext *)context;
+ (NSFetchedResultsController *)whereKey:(NSString *)key
                                 containedIn:(id)objects
                              sectionKey:(NSString *)sectionKey
                                 sortKey:(NSString *)sortKey
                                     asc:(BOOL)isAsc;


+ (NSArray *)whereKey:(NSString *)key notContainedIn:(NSArray *)objects;
+ (NSArray *)whereKey:(NSString *)key notContainedIn:(NSArray *)objects inContext:(NSManagedObjectContext *)context;
+ (NSFetchedResultsController *)whereKey:(NSString *)key
                                 notContainedIn:(id)objects
                              sectionKey:(NSString *)sectionKey
                                 sortKey:(NSString *)sortKey
                                     asc:(BOOL)isAsc;

+ (NSArray *)wherePredicate:(NSPredicate *)predicate;
+ (NSArray *)wherePredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context;
+ (NSFetchedResultsController *)wherePredicate:(NSPredicate *)predicate
                                    sectionKey:(NSString *)sectionKey
                                       sortKey:(NSString *)sortKey
                                           asc:(BOOL)isAsc;

+ (NSArray *)wherePredicate:(NSPredicate *)predicate
                  pageIndex:(int)page
                   pageSize:(int)pageSize
                     sortBy:(NSString *)sortBy
                        asc:(BOOL)isAsc;
+ (NSArray *)wherePredicate:(NSPredicate *)predicate
                  pageIndex:(int)page
                   pageSize:(int)pageSize
                     sortBy:(NSString *)sortBy
                        asc:(BOOL)isAsc inContext:(NSManagedObjectContext *)context;

+ (NSArray *)wherePredicate:(NSPredicate *)predicate
                     sortBy:(NSString *)sortBy
                        asc:(BOOL)isAsc;
+ (NSArray *)wherePredicate:(NSPredicate *)predicate
                     sortBy:(NSString *)sortBy
                        asc:(BOOL)isAsc inContext:(NSManagedObjectContext *)context;

+ (NSInteger)count;
+ (NSInteger)countInContext:(NSManagedObjectContext *)context;
+ (NSInteger)countWherePredicate:(NSString *)predicateStr;
+ (NSInteger)countWherePredicate:(NSString *)predicateStr inContext:(NSManagedObjectContext *)context;

+ (void)deleteAll;
+ (void)deleteAllInContext:(NSManagedObjectContext *)context;
- (void)delete;
- (void)deleteInContext:(NSManagedObjectContext *)context;
- (void)save;
- (void)saveInContext:(NSManagedObjectContext *)context;
- (void)undo;
- (void)undoInContext:(NSManagedObjectContext *)context;
- (void)rollback;
- (void)rollbackInContext:(NSManagedObjectContext *)context;

@end
