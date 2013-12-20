//
//  RestaurantDao.h
//  qrrestaurant
//
//  Created by Jokinryou Tsui on 12/19/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Restaurant.h"
#import "VariableDefinition.h"

@interface RestaurantDao : NSObject
{
    sqlite3 *db;
}

- (NSString *)applicationDocumentsDirectoryFile;

// 用于创建数据库和customer表
- (void)createEditableCopyOfDatabaseIfNeeded;

// 插入数据
- (void)insert:(Restaurant *)restaurant;

// 查询
- (NSMutableArray *)findAll;

// 查询某一个
- (Restaurant *)getById:(int)rest_id;

// 删除
- (void)deleteAll;

@end
