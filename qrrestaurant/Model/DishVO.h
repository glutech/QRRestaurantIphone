//
//  DishVO.h
//  qrrestaurant
//
//  Created by Jokinryou Tsui on 12/19/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DishVO : NSObject

@property (nonatomic) int rest_id;
@property (nonatomic, retain) NSString *rest_name;
@property (nonatomic, retain) NSMutableArray *dishList;
@property (nonatomic, retain) NSMutableArray *catList;

@end
