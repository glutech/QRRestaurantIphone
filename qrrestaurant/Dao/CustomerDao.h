//
//  CustomerDao.h
//  qrrestaurant
//
//  Created by Jokinryou Tsui on 12/19/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Customer.h"
#import "VariableDefinition.h"

@interface CustomerDao : NSObject
{
    sqlite3 *db;
}

- (NSString *)applicationDocumentsDirectoryFile;

// 用于创建数据库和customer表
- (void)createEditableCopyOfDatabaseIfNeeded;

// 插入数据
- (void)insert:(Customer *)customer;

// 查询
- (Customer *)findAll;

// 删除
- (void)deleteAll;

// 更新
- (void)updateCustomerInfo:(Customer *)customer;

@end
