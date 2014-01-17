//
//  HostViewController.h
//  qrrestaurant
//
//  Created by Jokinryou Tsui on 12/11/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ViewPagerController.h"
#import "OrderedDishesViewController.h"
#import "ContentViewController.h"
#import "TempOrderService.h"

@class HostViewController;

@protocol HostViewControllerDelegate <NSObject>

-(void)didBack:(HostViewController *)controller;
-(void)viewSelected:(HostViewController *)controller;

@end

@interface HostViewController : ViewPagerController <OrderedDishesViewControllerDelegate, ContentViewControllerDelegate>

@property (nonatomic, retain) OrderedDishesViewController *orderedDishesViewController;
@property (nonatomic, weak) id <HostViewControllerDelegate> hostViewdelegate;
@property (nonatomic, retain) NSMutableArray *tempDishes;
@property (nonatomic) int rest_id;
@property (nonatomic, retain) NSString *rest_name;
@property (nonatomic) BOOL isFromScanView;
- (IBAction)goBack:(id)sender;
- (IBAction)selected:(id)sender;

@end
