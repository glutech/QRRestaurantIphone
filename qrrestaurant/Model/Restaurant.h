//
//  Restaurant.h
//  qrrestaurant
//
//  Created by Jokinryou Tsui on 12/19/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Restaurant : NSObject

@property (nonatomic) int rest_id;
@property (nonatomic, retain) NSString *rest_name;
@property (nonatomic, retain) NSString *rest_desc;
@property (nonatomic, retain) NSString *rest_type;
@property (nonatomic, retain) NSString *rest_addr;
@property (nonatomic, retain) NSString *rest_tel;
@property (nonatomic) int rest_upid;

@end
