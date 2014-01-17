//
//  RestaurantService.h
//  qrrestaurant
//
//  Created by Jokinryou Tsui on 12/19/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Restaurant.h"
#import "ASIHTTPRequest.h"

@interface RestaurantService : NSObject

- (void)insert:(Restaurant *)restaurant;
- (NSMutableArray *)findAll;
- (Restaurant *)getById:(int)rest_id;
- (void)deleteAll;

// 获取餐馆列表
- (NSMutableArray *)getRestaurantList:(ASIHTTPRequest *)request;

- (ASIHTTPRequest *)getRestRequest;

- (ASIHTTPRequest *)getDishesRequest:(NSInteger *)rest_id;

- (void)saveDishesAndCatList:(ASIHTTPRequest *)request;

// 获取推荐菜品
- (NSMutableArray *)getRecommendDishes;

// 获取点菜排行
- (NSMutableArray *)getDishesByCount;

// 获取全部菜品
- (NSMutableArray *)getAllDishes;

@end
