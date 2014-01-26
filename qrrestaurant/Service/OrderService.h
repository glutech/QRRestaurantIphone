//
// Created by Jokinryou Tsui on 1/22/14.
// Copyright (c) 2014 Boke Technology co., ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"



@interface OrderService : NSObject

- (NSMutableArray *)getHistoryOrders:(int)customerId;
- (NSMutableArray *)getBookOrders:(int)customerId;
- (ASIHTTPRequest *) getOrdersRequest;

@end