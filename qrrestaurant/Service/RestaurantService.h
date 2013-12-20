//
//  RestaurantService.h
//  qrrestaurant
//
//  Created by Jokinryou Tsui on 12/19/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Restaurant.h"

@interface RestaurantService : NSObject

- (void)insert:(Restaurant *)restaurant;
- (NSMutableArray *)findAll;
- (Restaurant *)getById:(int)rest_id;
- (void)deleteAll;

// 获取餐馆列表
- (NSMutableArray *)getRestaurantList;

@end
