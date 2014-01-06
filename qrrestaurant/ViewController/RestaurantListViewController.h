//
//  RestaurantListViewController.h
//  qrrestaurant
//
//  Created by Jokinryou Tsui on 12/12/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HostViewController.h"
#import "RestaurantService.h"
#import "TempOrderService.h"

@interface RestaurantListViewController : UITableViewController <HostViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *restList;
@property (nonatomic, strong) RestaurantService *restService;
@property (nonatomic, strong) TempOrderService *tempOrderService;

@end
