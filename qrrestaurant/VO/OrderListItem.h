//
// Created by Jokinryou Tsui on 1/26/14.
// Copyright (c) 2014 Boke Technology co., ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface OrderListItem : NSObject

@property (nonatomic) int menuId;
@property (nonatomic, retain) NSString *restName;
@property (nonatomic, retain) NSString *menuTime;
@property (nonatomic, retain) NSString *menuPrice;

@end