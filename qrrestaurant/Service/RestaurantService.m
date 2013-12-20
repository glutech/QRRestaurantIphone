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

- (NSMutableArray *)getRestaurantList
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    NSString *postURL = [NSString stringWithFormat:@"book/get_rest_list"];
    postURL = [HOST_NAME stringByAppendingString:postURL];
    
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:postURL]];
    
    [request startSynchronous];
    
    NSError *error = request.error;
    if (error == nil) {
        ParseJson *pj = [[ParseJson alloc] init];
        [pj parseRestaurantList:[request responseData]];
    }
    
    return result;
}

@end
