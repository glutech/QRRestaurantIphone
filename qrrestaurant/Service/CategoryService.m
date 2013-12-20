//
//  CategoryService.m
//  qrrestaurant
//
//  Created by Jokinryou Tsui on 12/19/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import "CategoryService.h"
#import "CategoryDao.h"
#import "DishCategory.h"

@implementation CategoryService

- (void)insert:(DishCategory *)categoryItem
{
    CategoryDao *dao = [[CategoryDao alloc] init];
    [dao insert:categoryItem];
}

- (NSMutableArray *)findAll
{
    CategoryDao *dao = [[CategoryDao alloc] init];
    return [dao findAll];
}

- (DishCategory *)getById:(int)catId
{
    CategoryDao *dao = [[CategoryDao alloc] init];
    return [dao getById:catId];
}

- (void)deleteAll
{
    CategoryDao *dao = [[CategoryDao alloc] init];
    [dao deleteAll];
}

- (void)parseAndSaveDishCategory:(DishVO *)dishVO
{
    CategoryDao *dao = [[CategoryDao alloc] init];
    
    DishCategory *category;
    for (int i = 0; i < [dishVO.catList count]; i++) {
        category = [[DishCategory alloc] init];
        
        category.cat_id = [[[dishVO.catList objectAtIndex:i] objectForKey:@"cat_id"] intValue];
        category.cat_name = [[dishVO.catList objectAtIndex:i] objectForKey:@"cat_name"];
        category.rest_id = [[[dishVO.catList objectAtIndex:i] objectForKey:@"rest_id"] intValue];
        
        [dao insert:category];
    }
    
}

@end
