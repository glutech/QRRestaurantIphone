//
//  Dish.h
//  qrrestaurant
//
//  Created by Jokinryou Tsui on 12/13/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Dish : NSObject

@property (nonatomic) int dishId;
@property (nonatomic, retain) NSString *dishName;
@property (nonatomic) double dishPrice;
@property (nonatomic, retain) NSString *dishImagePath;
@property (nonatomic) int dishCount;

@property (nonatomic, retain) NSString *dishDescription;
@property (nonatomic, retain) NSString *dishTag;
@property (nonatomic) int dishStatus;
@property (nonatomic) int dishRecommend;
@property (nonatomic) int dishOrderedCount;
@property (nonatomic) int dishCatId;
@property (nonatomic) int dishRestId;

@end
