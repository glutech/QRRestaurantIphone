//
//  CustomerService.m
//  qrrestaurant
//
//  Created by Jokinryou Tsui on 12/19/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import "CustomerService.h"

@implementation CustomerService

- (void)insert:(Customer *)customer
{
    CustomerDao *dao = [[CustomerDao alloc] init];
    [dao insert:customer];
}

- (Customer *)findAll
{
    CustomerDao *dao = [[CustomerDao alloc] init];
    return [dao findAll];
}

- (void)deleteAll
{
    CustomerDao *dao = [[CustomerDao alloc] init];
    [dao deleteAll];
}

- (void)updateCustomerInfo:(Customer *)customer
{
    CustomerDao *dao = [[CustomerDao alloc] init];
    [dao updateCustomerInfo:customer];
}

@end
