//
//  TempOrderService.m
//  qrrestaurant
//
//  Created by Jokinryou Tsui on 12/13/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import "TempOrderService.h"

@implementation TempOrderService

- (int)insert:(Dish *)dish
{
    TempOrderDao *dao = [[TempOrderDao alloc] init];
    return [dao insert:dish];
}

- (NSMutableArray *)findAll
{
    TempOrderDao *dao = [[TempOrderDao alloc] init];
    return [dao findAll];
}

- (void)deleteAll
{
    TempOrderDao *dao = [[TempOrderDao alloc] init];
    [dao deleteAll];
}

- (NSInteger)getItemCount
{
    TempOrderDao *dao = [[TempOrderDao alloc] init];
    return [dao getItemCount];
}

@end
