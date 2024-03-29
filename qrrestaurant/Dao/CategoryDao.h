//
//  CategoryDao.h
//  qrrestaurant
//
//  Created by Jokinryou Tsui on 12/19/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "DishCategory.h"
#import "VariableDefinition.h"

@interface CategoryDao : NSObject
{
    sqlite3 *db;
}

- (NSString *)applicationDocumentsDirectoryFile;

// 用于创建数据库和customer表
- (void)createEditableCopyOfDatabaseIfNeeded;

// 插入数据
- (void)insert:(DishCategory *)categoryItem;

// 查询
- (NSMutableArray *)findAll;

// 查询某一个
- (DishCategory *)getById:(int)catId;

// 删除
- (void)deleteAll;

@end
