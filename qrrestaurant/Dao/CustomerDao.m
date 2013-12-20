//
//  CustomerDao.m
//  qrrestaurant
//
//  Created by Jokinryou Tsui on 12/19/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import "CustomerDao.h"

@implementation CustomerDao
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
        
        NSString *createSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS customer (customer_id INTEGER PRIMAR KEY, customer_name String, deviceId String);"];
        
        if (sqlite3_exec(db, [createSQL UTF8String], NULL, NULL, &err) != SQLITE_OK) {
            sqlite3_close(db);
            NSAssert1(NO, @"create table failed", err);
        }
        
        sqlite3_close(db);
    }
}

- (void)insert:(Customer *)customer
{
    [self createEditableCopyOfDatabaseIfNeeded];
    
    NSString *path = [self applicationDocumentsDirectoryFile];
    
    if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"open db failed....");
    } else {
        NSString *sqlStr = @"INSERT OR REPLACE INTO customer (customer_id, customer_name, deviceId) VALUES (?,?,?)";
        
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(db, [sqlStr UTF8String], -1, &statement, nil) == SQLITE_OK) {
            sqlite3_bind_int(statement, 1, customer.customer_id);
            sqlite3_bind_text(statement, 2, [customer.customer_name UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 3, [customer.deviceId UTF8String], -1, NULL);
            
            if (sqlite3_step(statement) != SQLITE_DONE) {
                NSAssert(NO, @"insert failed...");
            }
        }
        
        sqlite3_finalize(statement);
    }
    
    sqlite3_close(db);
}

- (Customer *)findAll
{
    NSString *path = [self applicationDocumentsDirectoryFile];
    Customer *c = [[Customer alloc] init];
    
    if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"open db failed....");
    } else {
        NSString *sql = @"SELECT customer_id, customer_name, deviceId FROM customer";
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                int customer_id = (int)sqlite3_column_int(statement, 0);
//                NSString *dishIdStr = [NSString stringWithFormat:@"%d", dishId];
                
                char *ccustomer_name = (char *)sqlite3_column_text(statement, 1);
                NSString *customer_name = [[NSString alloc] initWithUTF8String:ccustomer_name];
                
                char *cdeviceId = (char *)sqlite3_column_text(statement, 2);
                NSString *device_id = [[NSString alloc] initWithUTF8String:cdeviceId];
                
                c.customer_id = customer_id;
                c.customer_name = customer_name;
                c.deviceId = device_id;
            }
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    return c;
}

- (void)deleteAll
{
    [self createEditableCopyOfDatabaseIfNeeded];
    
    NSString *path = [self applicationDocumentsDirectoryFile];
    
    if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"open db failed....");
    } else {
        NSString *deleteAllStr = @"DELETE FROM customer";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(db, [deleteAllStr UTF8String], -1, &statement, nil) == SQLITE_OK) {
            sqlite3_step(statement);
        }
        sqlite3_finalize(statement);
    }
    
    sqlite3_close(db);
}

@end
