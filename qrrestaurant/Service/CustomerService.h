//
//  CustomerService.h
//  qrrestaurant
//
//  Created by Jokinryou Tsui on 12/19/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomerDao.h"
#import "Customer.h"

@interface CustomerService : NSObject

- (void)insert:(Customer *)customer;
- (Customer *)findAll;
- (void)deleteAll;
- (void)updateCustomerInfo:(Customer *)customer;

@end
