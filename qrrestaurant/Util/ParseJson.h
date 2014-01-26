//
//  ParseJson.h
//  qrrestaurant
//
//  Created by Jokinryou Tsui on 12/19/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DishVO.h"

@interface ParseJson : NSObject

- (DishVO *)parseScanResult:(NSData *)scanResult;

- (NSMutableArray *)parseRestaurantList:(NSData *)restaurantList;

- (NSMutableArray *)parseOrderList:(NSData *)orderList;

@end
