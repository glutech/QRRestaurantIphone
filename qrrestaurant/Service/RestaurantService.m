//
//  RestaurantService.m
//  qrrestaurant
//
//  Created by Jokinryou Tsui on 12/19/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import "RestaurantService.h"
#import "RestaurantDao.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "ParseJson.h"
#import "DishService.h"
#import "CategoryService.h"

@implementation RestaurantService

- (void)insert:(Restaurant *)restaurant
{
    RestaurantDao *dao = [[RestaurantDao alloc] init];
    [dao insert:restaurant];
}

- (NSMutableArray *)findAll
{
    RestaurantDao *dao = [[RestaurantDao alloc] init];
    return [dao findAll];
}

- (Restaurant *)getById:(int)rest_id
{
    RestaurantDao *dao = [[RestaurantDao alloc] init];
    return [dao getById:rest_id];
}

- (void)deleteAll
{
    RestaurantDao *dao = [[RestaurantDao alloc] init];
    [dao deleteAll];
}

- (NSMutableArray *)getRestaurantList:(ASIHTTPRequest *)request
{
    ParseJson *pj = [[ParseJson alloc] init];
    NSMutableArray *result = [pj parseRestaurantList:[request responseData]];
    
    return result;
}

- (ASIHTTPRequest *)getRestRequest
{
    NSString *postURL = [NSString stringWithFormat:@"book/get_rest_list"];
    postURL = [HOST_NAME stringByAppendingString:postURL];
    
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:postURL]];
    
    return request;
}

- (ASIHTTPRequest *)getDishesRequest:(NSInteger *)rest_id
{
    NSString *postURL = [NSString stringWithFormat:@"book/get_dishes"];
    postURL = [HOST_NAME stringByAppendingString:postURL];
    
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:postURL]];
    
    [request addPostValue:[NSString stringWithFormat:@"%i", (int) rest_id] forKey:@"r_id"];
    
    return request;
}

- (void)saveDishesAndCatList:(ASIHTTPRequest *)request
{
    ParseJson *pj = [[ParseJson alloc] init];
    DishService *dService = [[DishService alloc] init];
    CategoryService *cService = [[CategoryService alloc] init];
    [dService parseAndSaveDish:[pj parseScanResult:[request responseData]]];
    [cService parseAndSaveDishCategory:[pj parseScanResult:[request responseData]]];
}

- (NSMutableArray *)getRecommendDishes
{
    NSMutableArray *result;
    DishService *dService = [[DishService alloc] init];
    result = [dService getDishesByRecommemd];
    return result;
}

- (NSMutableArray *)getDishesByCount
{
    NSMutableArray *result;
    DishService *dService = [[DishService alloc] init];
    result = [dService getDishesByOrderedCount];
    return result;
}

- (NSMutableArray *)getAllDishes
{
    NSMutableArray *result;
    DishService *dService = [[DishService alloc] init];
    result = [dService findAll];
    return result;
}

@end
