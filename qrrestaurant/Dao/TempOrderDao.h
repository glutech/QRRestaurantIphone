//
//  TempOrderDao.h
//  qrrestaurant
//
//  Created by Jokinryou Tsui on 12/13/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Dish.h"
#import "VariableDefinition.h"

@interface TempOrderDao : NSObject
{
    sqlite3 *db;
}

- (NSString *)applicationDocumentsDirectoryFile;

// 用于创建数据库和tempOrder表
- (void)createEditableCopyOfDatabaseIfNeeded;

// 插入数据
- (int)insert:(Dish *)dish;

// 查询
- (NSMutableArray *)findAll;

// 删除所有已点菜
- (void)deleteAll;

@end
