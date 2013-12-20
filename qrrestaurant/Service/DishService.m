//
//  DishService.m
//  qrrestaurant
//
//  Created by Jokinryou Tsui on 12/19/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import "DishService.h"
#import "DishDao.h"

@implementation DishService

- (void)insert:(Dish *)dish
{
    DishDao *dao =  [[DishDao alloc] init];
    [dao insert:dish];
}

- (NSMutableArray *)findAll
{
    DishDao *dao =  [[DishDao alloc] init];
    return [dao findAll];
}

- (Dish *)getById:(int)dishId
{
    DishDao *dao =  [[DishDao alloc] init];
    return [dao getById:dishId];
}

- (void)deleteAll
{
    DishDao *dao =  [[DishDao alloc] init];
    [dao deleteAll];
}

- (void)parseAndSaveDish:(DishVO *)dishVO
{
    DishDao *dao = [[DishDao alloc] init];
    
    Dish *dish;
    for (int i=0; i<[dishVO.dishList count]; i++) {
        dish = [[Dish alloc] init];
        
        dish.dishId = [[[dishVO.dishList objectAtIndex:i] objectForKey:@"dish_id"] intValue];
        dish.dishName = [[dishVO.dishList objectAtIndex:i] objectForKey:@"dish_name"];
        dish.dishDescription = [[dishVO.dishList objectAtIndex:i] objectForKey:@"dish_desc"];
        dish.dishImagePath = [[dishVO.dishList objectAtIndex:i] objectForKey:@"dish_pic"];
        dish.dishPrice = [[[dishVO.dishList objectAtIndex:i] objectForKey:@"dish_price"] doubleValue];
        dish.dishTag = [[dishVO.dishList objectAtIndex:i] objectForKey:@"dish_tag"];
        dish.dishStatus = [[[dishVO.dishList objectAtIndex:i] objectForKey:@"dish_status"] intValue];
        dish.dishRecommend = [[[dishVO.dishList objectAtIndex:i] objectForKey:@"dish_recommend"] intValue];
        dish.dishOrderedCount = [[[dishVO.dishList objectAtIndex:i] objectForKey:@"dish_ordered"] intValue];
        dish.dishCatId = [[[dishVO.dishList objectAtIndex:i] objectForKey:@"cat_id"] intValue];
        dish.dishRestId = [[[dishVO.dishList objectAtIndex:i] objectForKey:@"rest_id"] intValue];
        
        [dao insert:dish];
    }
}

@end
