//
// Created by Jokinryou Tsui on 1/22/14.
// Copyright (c) 2014 Boke Technology co., ltd. All rights reserved.
//

#import "OrderService.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "VariableDefinition.h"


@implementation OrderService {

}
- (NSMutableArray *)getHistoryOrders:(int)customerId {
    return nil;
}

- (NSMutableArray *)getBookOrders:(int)customerId {
    return nil;
}

- (ASIHTTPRequest *)getOrdersRequest {

    // 这个地方还要取到c_id

    NSString *postURL = [NSString stringWithFormat:@"history/list_orders?c_id=23"];
    postURL = [HOST_NAME stringByAppendingString:postURL];

    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:postURL]];

    return request;
}

- (ASIHTTPRequest *)getOrderDishesRequest:(NSString *)orderIdStr {

    NSString *postURL = [NSString stringWithFormat:@"history/get_order?m_id="];
    postURL = [postURL stringByAppendingString:orderIdStr];

    NSLog(@"URL: %@", postURL);

    postURL = [HOST_NAME stringByAppendingString:postURL];

    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:postURL]];

    return request;
}


@end