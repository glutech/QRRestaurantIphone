//
//  CategoryService.h
//  qrrestaurant
//
//  Created by Jokinryou Tsui on 12/19/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DishCategory.h"
#include "DishVO.h"

@interface CategoryService : NSObject

- (void)insert:(DishCategory *)categoryItem;
- (NSMutableArray *)findAll;
- (DishCategory *)getById:(int)catId;
- (void)deleteAll;

// 获取扫描完成之后得到的结果中的catlist，并将catlist解析为单个的dishcategory，写入数据库
- (void)parseAndSaveDishCategory:(DishVO *)dishVO;

@end
