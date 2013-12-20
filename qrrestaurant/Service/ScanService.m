//
//  ScanService.m
//  qrrestaurant
//
//  Created by Jokinryou Tsui on 12/19/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import "ScanService.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "ParseJson.h"
#import "Restaurant.h"
#import "Dish.h"
#import "DishCategory.h"
#import "DishService.h"
#import "RestaurantService.h"
#import "CategoryService.h"

@implementation ScanService

- (int)getScanResult:(int)t_id
{
    int result = -1;
    NSString *postURL = [NSString stringWithFormat:@"order/scan"];
    postURL = [HOST_NAME stringByAppendingString:postURL];
    
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:postURL]];
    
    [request addPostValue:[NSString stringWithFormat:@"%d", t_id] forKey:@"t_id"];
    
    [request startSynchronous];
    
    NSError *error = request.error;
    if (error == nil) {
        if ([NSJSONSerialization isValidJSONObject:[NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingAllowFragments error:&error]]) {
            
            // 解析返回的数据并写入数据库
            ParseJson *pj = [[ParseJson alloc] init];
            DishVO *dishVO = [[DishVO alloc] init];
            dishVO =  [pj parseScanResult:[request responseData]];
            
            // 定义几个service在这
            
            RestaurantService *restaurantService = [[RestaurantService alloc] init];
            DishService *dishService = [[DishService alloc] init];
            CategoryService *categoryService = [[CategoryService alloc] init];
            
            Restaurant *restaurant = [[Restaurant alloc] init];
            restaurant.rest_id = dishVO.rest_id;
            restaurant.rest_name = dishVO.rest_name;
            [restaurantService insert:restaurant];
            
            [dishService parseAndSaveDish:dishVO];
            
            [categoryService parseAndSaveDishCategory:dishVO];
            
            // 处理过程全部正确
            result = 1;
            
        } else {
            // 桌子不能用
            result = 2;
        }
    } else {
        // 网络错误
        result = 3;
    }
    
    return result;
}

@end
