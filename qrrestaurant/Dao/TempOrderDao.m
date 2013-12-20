//
//  TempOrderDao.m
//  qrrestaurant
//
//  Created by Jokinryou Tsui on 12/13/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import "TempOrderDao.h"

@implementation TempOrderDao

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
        
        NSString *createSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS tempOrder (dishId INTEGER, dishName String, dishPrice String, count INTEGER);"];
        
        if (sqlite3_exec(db, [createSQL UTF8String], NULL, NULL, &err) != SQLITE_OK) {
            sqlite3_close(db);
            NSAssert1(NO, @"create table failed", err);
        }
        
        sqlite3_close(db);
    }
}

- (int)insert:(Dish *)dish
{
    BOOL flag = [self checkIfExist:dish];
    if (flag) {
        int count = [self getDishCount:dish];
        [self updateDishCount:dish count:count];
    } else {
        
        // 如果需要的表不存在，则创建
        [self createEditableCopyOfDatabaseIfNeeded];
        
        NSString *path = [self applicationDocumentsDirectoryFile];
        
        if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
            sqlite3_close(db);
            NSAssert(NO, @"open db failed....");
        } else {
            NSString *sqlStr = @"INSERT OR REPLACE INTO tempOrder (dishId, dishName, dishPrice, count) VALUES (?,?,?,?)";
            
            sqlite3_stmt *statement;
            
            if (sqlite3_prepare_v2(db, [sqlStr UTF8String], -1, &statement, nil) == SQLITE_OK) {
                sqlite3_bind_int(statement, 1, dish.dishId);
                sqlite3_bind_text(statement, 2, [dish.dishName UTF8String], -1, NULL);
//                sqlite3_bind_text(statement, 3, [dish.dishPrice UTF8String], -1, NULL);
                sqlite3_bind_double(statement, 3, dish.dishPrice);
                sqlite3_bind_int(statement, 4, 1);
                
                if (sqlite3_step(statement) != SQLITE_DONE) {
                    NSAssert(NO, @"insert failed....");
                }
            }
            
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(db);
    }
    
    
    return 0;
}

- (void)updateDishCount:(Dish *)dish count:(int)count
{
    // 如果需要的表不存在，则创建
    [self createEditableCopyOfDatabaseIfNeeded];
    
    NSString *path = [self applicationDocumentsDirectoryFile];
    
    if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"open db failed....");
    } else {
        NSString *updateCount = @"UPDATE tempOrder SET count = ? where dishId = ?";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(db, [updateCount UTF8String], -1, &statement, nil) == SQLITE_OK) {
            count++;
            sqlite3_bind_int(statement, 1, count);
            sqlite3_bind_int(statement, 2, dish.dishId);
            
            sqlite3_step(statement);
        }
        sqlite3_finalize(statement);
    }
    
    sqlite3_close(db);
}

- (int)getDishCount:(Dish *)dish
{
    int count = 0;
    // 如果需要的表不存在，则创建
    [self createEditableCopyOfDatabaseIfNeeded];
    
    NSString *path = [self applicationDocumentsDirectoryFile];
    
    if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"open db failed....");
    } else {
        NSString *sqlGetCount = @"SELECT count FROM tempOrder where dishId = ?";
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(db, [sqlGetCount UTF8String], -1, &statement, nil) == SQLITE_OK) {
            sqlite3_bind_int(statement, 1, dish.dishId);
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                count = (int)sqlite3_column_int(statement, 0);
            }
        }
        
        sqlite3_finalize(statement);
    }
    
    sqlite3_close(db);
    
    return count;
}

// 检查要点的菜是否已经存在，若存在，返回TRUE
- (BOOL)checkIfExist:(Dish *)dish
{
    BOOL flag = false;
    NSString *path = [self applicationDocumentsDirectoryFile];
    
    if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"open db failed....");
    } else {
        NSString *sql = @"SELECT dishId FROM tempOrder where dishId = ?";
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

- (NSMutableArray *)findAll
{
    NSString *path = [self applicationDocumentsDirectoryFile];
    NSMutableArray *data = [[NSMutableArray alloc] init];
    
    if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"open db failed....");
    } else {
        NSString *sql = @"SELECT dishId, dishName, dishPrice, count FROM tempOrder ORDER BY dishId DESC";
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                int dishId = (int)sqlite3_column_int(statement, 0);
//                NSString *dishIdStr = [NSString stringWithFormat:@"%d", dishId];
                
                char *cdishName = (char *)sqlite3_column_text(statement, 1);
                NSString *dishName = [[NSString alloc] initWithUTF8String:cdishName];
                
//                char *cdishPrice = (char *)sqlite3_column_text(statement, 2);
//                NSString *dishPrice = [[NSString alloc] initWithUTF8String:cdishPrice];
                double dishPrice = (double)sqlite3_column_double(statement, 2);
                
                int dishCount = (int)sqlite3_column_int(statement, 3);
                
                Dish *d = [[Dish alloc] init];
                d.dishId = dishId;
                d.dishName = dishName;
                d.dishPrice = dishPrice;
                d.dishCount = dishCount;
                
                [data addObject:d];
            }
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    return data;
}

- (void)deleteAll
{
    // 如果需要的表不存在，则创建
    [self createEditableCopyOfDatabaseIfNeeded];
    
    NSString *path = [self applicationDocumentsDirectoryFile];
    
    if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"open db failed....");
    } else {
        NSString *deleteAllStr = @"DELETE FROM tempOrder";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(db, [deleteAllStr UTF8String], -1, &statement, nil) == SQLITE_OK) {
            sqlite3_step(statement);
        }
        sqlite3_finalize(statement);
    }
    
    sqlite3_close(db);
}

@end
