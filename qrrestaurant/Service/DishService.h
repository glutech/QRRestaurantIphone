//
//  DishService.h
//  qrrestaurant
//
//  Created by Jokinryou Tsui on 12/19/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Dish.h"
#import "DishVO.h"

@interface DishService : NSObject

- (void)insert:(Dish *)dish;
- (NSMutableArray *)findAll;
- (NSMutableArray *)getDishesByRecommemd;
- (NSMutableArray *)getDishesByOrderedCount;
- (Dish *)getById:(int)dishId;
- (void)deleteAll;

// 获取扫描完成之后得到的结果中的dishlist，并将dishlist解析为单个dish，写入数据库
- (void)parseAndSaveDish:(DishVO *)dishVO;

// 按照菜品类别获取菜品
- (NSDictionary *)getDishesByCat;

@end
