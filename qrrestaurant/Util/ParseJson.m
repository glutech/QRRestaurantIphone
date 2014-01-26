//
//  ParseJson.m
//  qrrestaurant
//
//  Created by Jokinryou Tsui on 12/19/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import "ParseJson.h"
#import "Restaurant.h"
#import "OrderListItem.h"

@implementation ParseJson

- (DishVO *)parseScanResult:(NSData *)scanResult
{
    NSError *error;
    
    NSDictionary *dishVODic = [NSJSONSerialization JSONObjectWithData:scanResult options:NSJSONReadingAllowFragments error:&error];
    
    DishVO *dishVO = [[DishVO alloc] init];
    
    dishVO.rest_id = [[dishVODic objectForKey:@"rest_id"] intValue];
    dishVO.rest_name = [dishVODic objectForKey:@"rest_name"];
    dishVO.dishList = [dishVODic objectForKey:@"dishlist"];
    dishVO.catList = [dishVODic objectForKey:@"catlist"];
    
    return dishVO;
}

- (NSMutableArray *)parseRestaurantList:(NSData *)restaurantList
{
    NSError *error;
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    NSDictionary *restDic = [NSJSONSerialization JSONObjectWithData:restaurantList options:NSJSONReadingMutableContainers error:&error];
    
    // 将Dictionary转为array返回
    
    Restaurant *rest;
    for (NSDictionary *dic in restDic) {
        rest = [[Restaurant alloc] init];
        rest.rest_id = [[dic objectForKey:@"rest_id"] intValue];
        rest.rest_name = [dic objectForKey:@"rest_name"];
        rest.rest_desc = [dic objectForKey:@"rest_desc"];
        rest.rest_type = [dic objectForKey:@"rest_type"];
        rest.rest_addr = [dic objectForKey:@"rest_addr"];
        rest.rest_tel = [dic objectForKey:@"rest_del"];
        rest.rest_upid = [[dic objectForKey:@"rest_upid"] intValue];
        
        [result addObject:rest];
    }
    
    return result;
}

- (NSMutableArray *)parseOrderList:(NSData *)orderList {

    NSError *error;

    NSMutableArray *result = [[NSMutableArray alloc] init];

    NSDictionary *menuDic = [NSJSONSerialization JSONObjectWithData:orderList options:NSJSONReadingMutableContainers error:&error];

    // 将Dictionary转为array返回

    OrderListItem *tempOrderListItemObject;
    for (NSDictionary *dic in menuDic) {
        tempOrderListItemObject = [[OrderListItem alloc] init];
        tempOrderListItemObject.restName = [dic objectForKey:@"rest_name"];

        NSDictionary *tempMenuItem = [dic objectForKey:@"me"];

        tempOrderListItemObject.menuId = [[tempMenuItem objectForKey:@"menu_id"] integerValue];
        tempOrderListItemObject.menuPrice = [[tempMenuItem objectForKey:@"menu_price"] stringValue];
        tempOrderListItemObject.menuTime = [tempMenuItem objectForKey:@"menu_time"];

        [result addObject:tempOrderListItemObject];
    }

    return result;
}

- (NSMutableArray *)parseOrderDishesList:(NSData *)orderDishesList {
    NSError *error;

    NSDictionary *orderInfoDic = [NSJSONSerialization JSONObjectWithData:orderDishesList options:NSJSONReadingAllowFragments error:&error];

    NSMutableArray *result = [orderInfoDic objectForKey:@"dishes"];

    return result;
}


@end
