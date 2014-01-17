//
//  DishDao.h
//  qrrestaurant
//
//  Created by Jokinryou Tsui on 12/19/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Dish.h"
#import "VariableDefinition.h"

@interface DishDao : NSObject
{
    sqlite3 *db;
}

- (NSString *)applicationDocumentsDirectoryFile;

// 用于创建数据库和customer表
- (void)createEditableCopyOfDatabaseIfNeeded;

// 插入数据
- (void)insert:(Dish *)dish;

// 查询所有菜品
- (NSMutableArray *)findAll;

// 根据推荐指数查询
- (NSMutableArray *)getByRecommend;

// 根据被点数量查询
- (NSMutableArray *)getByCount;

// 查询某一个
- (Dish *)getById:(int)dishId;

// 删除
- (void)deleteAll;

// 根据分类获得全部菜品
- (NSDictionary *)getAllByCat;

@end
