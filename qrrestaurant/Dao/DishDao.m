//
//  DishDao.m
//  qrrestaurant
//
//  Created by Jokinryou Tsui on 12/19/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import "DishDao.h"

@implementation DishDao

- (NSString *)applicationDocumentsDirectoryFile
{
    NSArray *myPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *myDocPath = [myPaths lastObject];
    
    NSString *filename = [myDocPath stringByAppendingPathComponent:DBFILE_NAME];
    
    return filename;
}

- (void)createEditableCopyOfDatabaseIfNeeded
{
    NSString *writableDBPath = [self applicationDocumentsDirectoryFile];
    
    if (sqlite3_open([writableDBPath UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"open db failed......");
    } else {
        char *err;
        
        NSString *createSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS dish (dishId INTEGER PRIMAR KEY, dishName String, dishPrice String DEFAULT NULL, dishImagePath String  DEFAULT NULL, dishDescription String  DEFAULT NULL, dishTag String  DEFAULT NULL, dishStatus INTEGER  DEFAULT 0, dishRecommend INTEGER DEFAULT 0, dishOrderedCount INTEGER DEFAULT 0, dishCatId INTEGER, dishRestId INTEGER);"];
        
        if (sqlite3_exec(db, [createSQL UTF8String], NULL, NULL, &err) != SQLITE_OK) {
            sqlite3_close(db);
            NSAssert1(NO, @"create table failed", err);
        }
        
        sqlite3_close(db);
    }
}

- (void)insert:(Dish *)dish
{
    if (![self checkIfExist:dish]) {
        
        [self createEditableCopyOfDatabaseIfNeeded];
        
        NSString *path = [self applicationDocumentsDirectoryFile];
        
        if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
            sqlite3_close(db);
            NSAssert(NO, @"open db failed....");
        } else {
            NSString *sqlStr = @"INSERT OR REPLACE INTO dish (dishId, dishName, dishPrice, dishImagePath, dishDescription, dishTag, dishStatus, dishRecommend, dishOrderedCount, dishCatId, dishRestId) VALUES (?,?,?,?,?,?,?,?,?,?,?)";
            
            sqlite3_stmt *statement;
            
            if (sqlite3_prepare_v2(db, [sqlStr UTF8String], -1, &statement, nil) == SQLITE_OK) {
                sqlite3_bind_int(statement, 1, dish.dishId);
                sqlite3_bind_text(statement, 2, [dish.dishName UTF8String], -1, NULL);
                sqlite3_bind_double(statement, 3, dish.dishPrice);
                sqlite3_bind_text(statement, 4, [dish.dishImagePath UTF8String], -1, NULL);
                sqlite3_bind_text(statement, 5, [dish.dishDescription UTF8String], -1, NULL);
                sqlite3_bind_text(statement, 6, [dish.dishTag UTF8String], -1, NULL);
                sqlite3_bind_int(statement, 7, dish.dishStatus);
                sqlite3_bind_int(statement, 8, dish.dishRecommend);
                sqlite3_bind_int(statement, 9, dish.dishOrderedCount);
                sqlite3_bind_int(statement, 10, dish.dishCatId);
                sqlite3_bind_int(statement, 11, dish.dishRestId);
                
                if (sqlite3_step(statement) != SQLITE_DONE) {
                    NSAssert(NO, @"insert failed...");
                }
            } else {
                NSAssert1(0, @"Error: %s", sqlite3_errmsg(db));
            }
            
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(db);
        
    }
 
}

- (NSMutableArray *)findAll
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    NSString *path = [self applicationDocumentsDirectoryFile];
    
    if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"open db failed....");
    } else {
        NSString *sql = @"SELECT dishId, dishName, dishPrice, dishImagePath, dishDescription, dishTag, dishStatus, dishRecommend, dishOrderedCount, dishCatId, dishRestId FROM dish";
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                int dishId = (int)sqlite3_column_int(statement, 0);
                
                char *cdishName = (char *)sqlite3_column_text(statement, 1);
                NSString *dishName = [[NSString alloc] initWithUTF8String:cdishName];
                
//                char *cdishPrice = (char *)sqlite3_column_text(statement, 2);
//                NSString *dishPrice = [[NSString alloc] initWithUTF8String:cdishPrice];
                double dishPrice = (double)sqlite3_column_double(statement, 2);
                
                char *cdishImagePath = (char *)sqlite3_column_text(statement, 3);
                NSString *dishImagePath = [[NSString alloc] initWithUTF8String:cdishImagePath];
                
                char *cdishDescription = (char *)sqlite3_column_text(statement, 4);
                NSString *dishDescription = [[NSString alloc] initWithUTF8String:cdishDescription];
                
                char *cdishTag = (char *)sqlite3_column_text(statement, 5);
                NSString *dishTag = [[NSString alloc] initWithUTF8String:cdishTag];
                
                int dishStatus = (int)sqlite3_column_int(statement, 6);
                
                int dishRecommend = (int)sqlite3_column_int(statement, 7);
                
                int dishOrderedCount = (int)sqlite3_column_int(statement, 8);
                
                int dishCatId = (int)sqlite3_column_int(statement, 9);
                
                int dishRestId = (int)sqlite3_column_int(statement, 10);
                
                Dish *d = [[Dish alloc] init];
                d.dishId = dishId;
                d.dishName = dishName;
                d.dishPrice = dishPrice;
                d.dishImagePath = dishImagePath;
                d.dishDescription = dishDescription;
                d.dishTag = dishTag;
                d.dishStatus = dishStatus;
                d.dishRecommend = dishRecommend;
                d.dishOrderedCount = dishOrderedCount;
                d.dishCatId = dishCatId;
                d.dishRestId = dishRestId;
                
                [result addObject:d];
                
            }
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    
    return result;
}

- (NSDictionary *)getAllByCat
{
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    
    NSString *path = [self applicationDocumentsDirectoryFile];
    
    NSMutableArray *catIdList = [self getCatIdList];
    
    if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"open db failed....");
    } else {
        NSString *sql = @"SELECT dishId, dishName, dishPrice, dishImagePath, dishDescription, dishTag, dishStatus, dishRecommend, dishOrderedCount, dishCatId, dishRestId FROM dish WHERE dishCatId = ?";
        sqlite3_stmt *statement;
        
        for (int i = 0; i<catIdList.count; i++) {
            int dishCatId = [[catIdList objectAtIndex:i] intValue];
            
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
            
            if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                sqlite3_bind_int(statement, 1, dishCatId);
                
                while (sqlite3_step(statement) == SQLITE_ROW) {
                    
                    
                    int dishId = (int)sqlite3_column_int(statement, 0);
                    
                    char *cdishName = (char *)sqlite3_column_text(statement, 1);
                    NSString *dishName = [[NSString alloc] initWithUTF8String:cdishName];
                    
                    double dishPrice = (double)sqlite3_column_double(statement, 2);
                    
                    char *cdishImagePath = (char *)sqlite3_column_text(statement, 3);
                    NSString *dishImagePath = [[NSString alloc] initWithUTF8String:cdishImagePath];
                    
                    char *cdishDescription = (char *)sqlite3_column_text(statement, 4);
                    NSString *dishDescription = [[NSString alloc] initWithUTF8String:cdishDescription];
                    
                    char *cdishTag = (char *)sqlite3_column_text(statement, 5);
                    NSString *dishTag = [[NSString alloc] initWithUTF8String:cdishTag];
                    
                    int dishStatus = (int)sqlite3_column_int(statement, 6);
                    
                    int dishRecommend = (int)sqlite3_column_int(statement, 7);
                    
                    int dishOrderedCount = (int)sqlite3_column_int(statement, 8);
                    
                    int dishCatId = (int)sqlite3_column_int(statement, 9);
                    
                    int dishRestId = (int)sqlite3_column_int(statement, 10);
                    
                    Dish *d = [[Dish alloc] init];
                    d.dishId = dishId;
                    d.dishName = dishName;
                    d.dishPrice = dishPrice;
                    d.dishImagePath = dishImagePath;
                    d.dishDescription = dishDescription;
                    d.dishTag = dishTag;
                    d.dishStatus = dishStatus;
                    d.dishRecommend = dishRecommend;
                    d.dishOrderedCount = dishOrderedCount;
                    d.dishCatId = dishCatId;
                    d.dishRestId = dishRestId;
                    
                    [tempArray addObject:d];
                }
            } else {
                NSLog(@"Error: %s", sqlite3_errmsg(db));
            }
            [result setObject:tempArray forKey:[NSString stringWithFormat:@"%i", dishCatId]];
        }
        
        
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    
    return result;
}

- (NSMutableArray *)getCatIdList
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    NSString *path = [self applicationDocumentsDirectoryFile];
    
    if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"open db failed....");
    } else {
        NSString *sql = @"SELECT DISTINCT(dishCatId) FROM dish";
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                int dishCatId = (int)sqlite3_column_int(statement, 0);
                [result addObject:[NSNumber numberWithInt:dishCatId]];
                
            }
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    return result;
}

- (NSMutableArray *)getByRecommend
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    NSString *path = [self applicationDocumentsDirectoryFile];
    
    if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"open db failed....");
    } else {
        NSString *sql = @"SELECT dishId, dishName, dishPrice, dishImagePath, dishDescription, dishTag, dishStatus, dishRecommend, dishOrderedCount, dishCatId, dishRestId FROM dish ORDER BY dishRecommend DESC";
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                int dishId = (int)sqlite3_column_int(statement, 0);
                
                char *cdishName = (char *)sqlite3_column_text(statement, 1);
                NSString *dishName = [[NSString alloc] initWithUTF8String:cdishName];
                
//                char *cdishPrice = (char *)sqlite3_column_text(statement, 2);
//                NSString *dishPrice = [[NSString alloc] initWithUTF8String:cdishPrice];
                double dishPrice = (double)sqlite3_column_double(statement, 2);
                
                char *cdishImagePath = (char *)sqlite3_column_text(statement, 3);
                NSString *dishImagePath = [[NSString alloc] initWithUTF8String:cdishImagePath];
                
                char *cdishDescription = (char *)sqlite3_column_text(statement, 4);
                NSString *dishDescription = [[NSString alloc] initWithUTF8String:cdishDescription];
                
                char *cdishTag = (char *)sqlite3_column_text(statement, 5);
                NSString *dishTag = [[NSString alloc] initWithUTF8String:cdishTag];
                
                int dishStatus = (int)sqlite3_column_int(statement, 6);
                
                int dishRecommend = (int)sqlite3_column_int(statement, 7);
                
                int dishOrderedCount = (int)sqlite3_column_int(statement, 8);
                
                int dishCatId = (int)sqlite3_column_int(statement, 9);
                
                int dishRestId = (int)sqlite3_column_int(statement, 10);
                
                Dish *d = [[Dish alloc] init];
                d.dishId = dishId;
                d.dishName = dishName;
                d.dishPrice = dishPrice;
                d.dishImagePath = dishImagePath;
                d.dishDescription = dishDescription;
                d.dishTag = dishTag;
                d.dishStatus = dishStatus;
                d.dishRecommend = dishRecommend;
                d.dishOrderedCount = dishOrderedCount;
                d.dishCatId = dishCatId;
                d.dishRestId = dishRestId;
                
                [result addObject:d];
                
            }
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    
    return result;
}

- (NSMutableArray *)getByCount
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    NSString *path = [self applicationDocumentsDirectoryFile];
    
    if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"open db failed....");
    } else {
        NSString *sql = @"SELECT dishId, dishName, dishPrice, dishImagePath, dishDescription, dishTag, dishStatus, dishRecommend, dishOrderedCount, dishCatId, dishRestId FROM dish ORDER BY dishOrderedCount DESC";
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                int dishId = (int)sqlite3_column_int(statement, 0);
                
                char *cdishName = (char *)sqlite3_column_text(statement, 1);
                NSString *dishName = [[NSString alloc] initWithUTF8String:cdishName];
                
//                char *cdishPrice = (char *)sqlite3_column_text(statement, 2);
//                NSString *dishPrice = [[NSString alloc] initWithUTF8String:cdishPrice];
                double dishPrice = (double)sqlite3_column_double(statement, 2);
                
                char *cdishImagePath = (char *)sqlite3_column_text(statement, 3);
                NSString *dishImagePath = [[NSString alloc] initWithUTF8String:cdishImagePath];
                
                char *cdishDescription = (char *)sqlite3_column_text(statement, 4);
                NSString *dishDescription = [[NSString alloc] initWithUTF8String:cdishDescription];
                
                char *cdishTag = (char *)sqlite3_column_text(statement, 5);
                NSString *dishTag = [[NSString alloc] initWithUTF8String:cdishTag];
                
                int dishStatus = (int)sqlite3_column_int(statement, 6);
                
                int dishRecommend = (int)sqlite3_column_int(statement, 7);
                
                int dishOrderedCount = (int)sqlite3_column_int(statement, 8);
                
                int dishCatId = (int)sqlite3_column_int(statement, 9);
                
                int dishRestId = (int)sqlite3_column_int(statement, 10);
                
                Dish *d = [[Dish alloc] init];
                d.dishId = dishId;
                d.dishName = dishName;
                d.dishPrice = dishPrice;
                d.dishImagePath = dishImagePath;
                d.dishDescription = dishDescription;
                d.dishTag = dishTag;
                d.dishStatus = dishStatus;
                d.dishRecommend = dishRecommend;
                d.dishOrderedCount = dishOrderedCount;
                d.dishCatId = dishCatId;
                d.dishRestId = dishRestId;
                
                [result addObject:d];
                
            }
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    
    return result;
}

- (Dish *)getById:(int)dishId
{
    Dish *result = [[Dish alloc] init];
    NSString *path = [self applicationDocumentsDirectoryFile];
    
    if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"open db failed....");
    } else {
        NSString *sql = @"SELECT dishId, dishName, dishPrice, dishImagePath, dishDescription, dishTag, dishStatus, dishRecommend, dishOrderedCount, dishCatId, dishRestId FROM dish where dishId = ?";
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            
            sqlite3_bind_int(statement, 1, dishId);
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                int dishId = (int)sqlite3_column_int(statement, 0);
                
                char *cdishName = (char *)sqlite3_column_text(statement, 1);
                NSString *dishName = [[NSString alloc] initWithUTF8String:cdishName];
                
//                char *cdishPrice = (char *)sqlite3_column_text(statement, 2);
//                NSString *dishPrice = [[NSString alloc] initWithUTF8String:cdishPrice];
                double dishPrice = (double)sqlite3_column_double(statement, 2);
                
                char *cdishImagePath = (char *)sqlite3_column_text(statement, 3);
                NSString *dishImagePath = [[NSString alloc] initWithUTF8String:cdishImagePath];
                
                char *cdishDescription = (char *)sqlite3_column_text(statement, 4);
                NSString *dishDescription = [[NSString alloc] initWithUTF8String:cdishDescription];
                
                char *cdishTag = (char *)sqlite3_column_text(statement, 5);
                NSString *dishTag = [[NSString alloc] initWithUTF8String:cdishTag];
                
                int dishStatus = (int)sqlite3_column_int(statement, 6);
                
                int dishRecommend = (int)sqlite3_column_int(statement, 7);
                
                int dishOrderedCount = (int)sqlite3_column_int(statement, 8);
                
                int dishCatId = (int)sqlite3_column_int(statement, 9);
                
                int dishRestId = (int)sqlite3_column_int(statement, 10);
                
                result.dishId = dishId;
                result.dishName = dishName;
                result.dishPrice = dishPrice;
                result.dishImagePath = dishImagePath;
                result.dishDescription = dishDescription;
                result.dishTag = dishTag;
                result.dishStatus = dishStatus;
                result.dishRecommend = dishRecommend;
                result.dishOrderedCount = dishOrderedCount;
                result.dishCatId = dishCatId;
                result.dishRestId = dishRestId;
                
            }
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    
    return result;
}

- (void)deleteAll
{
    [self createEditableCopyOfDatabaseIfNeeded];
    
    NSString *path = [self applicationDocumentsDirectoryFile];
    
    if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"open db failed....");
    } else {
        NSString *deleteAllStr = @"DELETE FROM dish";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(db, [deleteAllStr UTF8String], -1, &statement, nil) == SQLITE_OK) {
            sqlite3_step(statement);
        }
        sqlite3_finalize(statement);
    }
    
    sqlite3_close(db);
}

// 检查记录是否存在
- (BOOL)checkIfExist:(Dish *)dish
{
    BOOL flag = false;
    
    NSString *path = [self applicationDocumentsDirectoryFile];
    
    if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"open db failed....");
    } else {
        NSString *sql = @"SELECT dishId FROM dish where dishId = ?";
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_bind_int(statement, 1, dish.dishId);
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                flag = true;
            }
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    
    return flag;
}

@end
