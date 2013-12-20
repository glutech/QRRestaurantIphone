//
//  TempOrderService.h
//  qrrestaurant
//
//  Created by Jokinryou Tsui on 12/13/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TempOrderDao.h"
#import "Dish.h"

@interface TempOrderService : NSObject

- (int)insert:(Dish *)dish;
- (NSMutableArray *)findAll;
- (void)deleteAll;

@end
