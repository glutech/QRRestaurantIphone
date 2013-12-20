//
//  RestaurantDao.m
//  qrrestaurant
//
//  Created by Jokinryou Tsui on 12/19/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import "RestaurantDao.h"

@implementation RestaurantDao

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
        
        NSString *createSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS restaurant (rest_id INTEGER PRIMAR KEY, rest_name String, rest_desc String DEFAULT NULL, rest_type String  DEFAULT NULL, rest_addr String  DEFAULT NULL, rest_tel String  DEFAULT NULL, rest_upid INTEGER  DEFAULT 0);"];
        
        if (sqlite3_exec(db, [createSQL UTF8String], NULL, NULL, &err) != SQLITE_OK) {
            sqlite3_close(db);
            NSAssert1(NO, @"create table failed", err);
        }
        
        sqlite3_close(db);
    }
}

- (void)insert:(Restaurant *)restaurant
{
    if (![self checkIfExist:restaurant]) {
        
        [self createEditableCopyOfDatabaseIfNeeded];
        
        NSString *path = [self applicationDocumentsDirectoryFile];
        
        if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
            sqlite3_close(db);
            NSAssert(NO, @"open db failed....");
        } else {
            NSString *sqlStr = @"INSERT OR REPLACE INTO restaurant (rest_id, rest_name, rest_desc, rest_type, rest_addr, rest_tel, rest_upid) VALUES (?,?,?,?,?,?,?)";
            
            sqlite3_stmt *statement;
            
            if (sqlite3_prepare_v2(db, [sqlStr UTF8String], -1, &statement, nil) == SQLITE_OK) {
                sqlite3_bind_int(statement, 1, restaurant.rest_id);
                sqlite3_bind_text(statement, 2, [restaurant.rest_name UTF8String], -1, NULL);
                sqlite3_bind_text(statement, 3, [restaurant.rest_desc UTF8String], -1, NULL);
                sqlite3_bind_text(statement, 4, [restaurant.rest_type UTF8String], -1, NULL);
                sqlite3_bind_text(statement, 5, [restaurant.rest_addr UTF8String], -1, NULL);
                sqlite3_bind_text(statement, 6, [restaurant.rest_tel UTF8String], -1, NULL);
                sqlite3_bind_int(statement, 7, restaurant.rest_upid);
                
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
        NSString *sql = @"SELECT rest_id, rest_name, rest_desc, rest_type, rest_addr, rest_tel, rest_upid FROM restaurant";
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                int rest_id = (int)sqlite3_column_int(statement, 0);
                
                char *crest_name = (char *)sqlite3_column_text(statement, 1);
                NSString *rest_name = [[NSString alloc] initWithUTF8String:crest_name];
                
                char *crest_desc = (char *)sqlite3_column_text(statement, 2);
                NSString *rest_desc = [[NSString alloc] initWithUTF8String:crest_desc];
                
                char *crest_type = (char *)sqlite3_column_text(statement, 3);
                NSString *rest_type = [[NSString alloc] initWithUTF8String:crest_type];
                
                char *crest_addr = (char *)sqlite3_column_text(statement, 4);
                NSString *rest_addr = [[NSString alloc] initWithUTF8String:crest_addr];
                
                char *crest_tel = (char *)sqlite3_column_text(statement, 5);
                NSString *rest_tel = [[NSString alloc] initWithUTF8String:crest_tel];
                
                int rest_upid = (int)sqlite3_column_int(statement, 6);
                
                Restaurant *r = [[Restaurant alloc] init];
                r.rest_id = rest_id;
                r.rest_name = rest_name;
                r.rest_desc = rest_desc;
                r.rest_type = rest_type;
                r.rest_addr = rest_addr;
                r.rest_tel = rest_tel;
                r.rest_upid = rest_upid;
                
                [result addObject:r];
                
            }
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    
    return result;
}

- (Restaurant *)getById:(int)rest_id
{
    Restaurant *result = [[Restaurant alloc] init];
    
    NSString *path = [self applicationDocumentsDirectoryFile];
    
    if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"open db failed....");
    } else {
        NSString *sql = @"SELECT rest_id, rest_name, rest_desc, rest_type, rest_addr, rest_tel, rest_upid FROM restaurant WHERE rest_id = ?";
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            
            sqlite3_bind_int(statement, 1, rest_id);
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                int rest_id = (int)sqlite3_column_int(statement, 0);
                
                char *crest_name = (char *)sqlite3_column_text(statement, 1);
                NSString *rest_name = [[NSString alloc] initWithUTF8String:crest_name];
                
                char *crest_desc = (char *)sqlite3_column_text(statement, 2);
                NSString *rest_desc = [[NSString alloc] initWithUTF8String:crest_desc];
                
                char *crest_type = (char *)sqlite3_column_text(statement, 3);
                NSString *rest_type = [[NSString alloc] initWithUTF8String:crest_type];
                
                char *crest_addr = (char *)sqlite3_column_text(statement, 4);
                NSString *rest_addr = [[NSString alloc] initWithUTF8String:crest_addr];
                
                char *crest_tel = (char *)sqlite3_column_text(statement, 5);
                NSString *rest_tel = [[NSString alloc] initWithUTF8String:crest_tel];
                
                int rest_upid = (int)sqlite3_column_int(statement, 6);
                
                result.rest_id = rest_id;
                result.rest_name = rest_name;
                result.rest_desc = rest_desc;
                result.rest_type = rest_type;
                result.rest_addr = rest_addr;
                result.rest_tel = rest_tel;
                result.rest_upid = rest_upid;
                
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
        NSString *deleteAllStr = @"DELETE FROM restaurant";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(db, [deleteAllStr UTF8String], -1, &statement, nil) == SQLITE_OK) {
            sqlite3_step(statement);
        }
        sqlite3_finalize(statement);
    }
    
    sqlite3_close(db);
}

// 检查记录是否存在
- (BOOL)checkIfExist:(Restaurant *)restaurant
{
    BOOL flag = false;
    
    NSString *path = [self applicationDocumentsDirectoryFile];
    
    if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"open db failed....");
    } else {
        NSString *sql = @"SELECT rest_id FROM restaurant where rest_id = ?";
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_bind_int(statement, 1, restaurant.rest_id);
            
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
