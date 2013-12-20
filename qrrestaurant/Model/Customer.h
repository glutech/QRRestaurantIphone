//
//  Customer.h
//  qrrestaurant
//
//  Created by Jokinryou Tsui on 12/19/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Customer : NSObject

@property (nonatomic) int customer_id;
@property (nonatomic, retain) NSString  *customer_name;
@property (nonatomic, retain) NSString *deviceId;

@end
