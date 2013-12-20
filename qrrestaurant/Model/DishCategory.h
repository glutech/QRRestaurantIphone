//
//  DishCategory.h
//  qrrestaurant
//
//  Created by Jokinryou Tsui on 12/19/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DishCategory : NSObject

@property (nonatomic) int cat_id;
@property (nonatomic, retain) NSString *cat_name;
@property (nonatomic) int rest_id;

@end
