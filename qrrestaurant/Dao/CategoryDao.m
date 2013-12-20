//
//  CategoryDao.m
//  qrrestaurant
//
//  Created by Jokinryou Tsui on 12/19/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import "CategoryDao.h"

@implementation CategoryDao

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
        
        NSString *createSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS category (cat_id INTEGER PRIMAR KEY, cat_name String, rest_id INTEGER  DEFAULT 0);"];
        
        if (sqlite3_exec(db, [createSQL UTF8String], NULL, NULL, &err) != SQLITE_OK) {
            sqlite3_close(db);
            NSAssert1(NO, @"create table failed", err);
        }
        
        sqlite3_close(db);
    }
}

- (void)insert:(DishCategory *)categoryItem
{
    if (![self checkIfExist:categoryItem]) {
        
        [self createEditableCopyOfDatabaseIfNeeded];
        
        NSString *path = [self applicationDocumentsDirectoryFile];
        
        if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
            sqlite3_close(db);
            NSAssert(NO, @"open db failed....");
        } else {
            NSString *sqlStr = @"INSERT OR REPLACE INTO category (cat_id, cat_name, rest_id) VALUES (?,?,?)";
            
            sqlite3_stmt *statement;
            
            if (sqlite3_prepare_v2(db, [sqlStr UTF8String], -1, &statement, nil) == SQLITE_OK) {
                sqlite3_bind_int(statement, 1, categoryItem.cat_id);
                sqlite3_bind_text(statement, 2, [categoryItem.cat_name UTF8String], -1, NULL);
                sqlite3_bind_int(statement, 3, categoryItem.rest_id);
                
                if (sqlite3_step(statement) != SQLITE_DONE) {
                    NSAssert(NO, @"insert failed...");
                }
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
        NSString *sql = @"SELECT cat_id, cat_name, rest_id FROM category";
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                int cat_id = (int)sqlite3_column_int(statement, 0);
                
                char *ccat_name = (char *)sqlite3_column_text(statement, 1);
                NSString *cat_name = [[NSString alloc] initWithUTF8String:ccat_name];
                
                int rest_id = (int)sqlite3_column_int(statement, 2);
                
                DishCategory *cat = [[DishCategory alloc] init];
                cat.cat_id = cat_id;
                cat.cat_name = cat_name;
                cat.rest_id = rest_id;
                
                [result addObject:cat];
                
            }
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    
    return result;
}

- (DishCategory *)getById:(int)catId
{
    
    DishCategory *result = [[DishCategory alloc] init];
    NSString *path = [self applicationDocumentsDirectoryFile];
    
    if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"open db failed....");
    } else {
        NSString *sql = @"SELECT cat_id, cat_name, rest_id FROM category WHERE cat_id = ?";
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            
            sqlite3_bind_int(statement, 1, catId);
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                int cat_id = (int)sqlite3_column_int(statement, 0);
                
                char *ccat_name = (char *)sqlite3_column_text(statement, 1);
                NSString *cat_name = [[NSString alloc] initWithUTF8String:ccat_name];
                
                int rest_id = (int)sqlite3_column_int(statement, 2);
                
                result.cat_id = cat_id;
                result.cat_name = cat_name;
                result.rest_id = rest_id;
                
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
        NSString *deleteAllStr = @"DELETE FROM category";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(db, [deleteAllStr UTF8String], -1, &statement, nil) == SQLITE_OK) {
            sqlite3_step(statement);
        }
        sqlite3_finalize(statement);
    }
    
    sqlite3_close(db);
}

// 检查记录是否存在
- (BOOL)checkIfExist:(DishCategory *)dishCategory
{
    BOOL flag = false;
    
    NSString *path = [self applicationDocumentsDirectoryFile];
    
    if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"open db failed....");
    } else {
        NSString *sql = @"SELECT cat_id FROM category where cat_id = ?";
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_bind_int(statement, 1, dishCategory.cat_id);
            
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
