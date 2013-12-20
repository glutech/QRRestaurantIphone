//
//  OrderedDishesViewController.h
//  qrrestaurant
//
//  Created by Jokinryou Tsui on 12/13/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TempOrderService.h"

@class OrderedDishesViewController;

@protocol OrderedDishesViewControllerDelegate <NSObject>

- (void)orderedDishesViewControllerDidBack:(OrderedDishesViewController *)controller;
- (void)orderedDishesViewControllerDidSubmit:(OrderedDishesViewController *)controller;

@end

@interface OrderedDishesViewController : UIViewController

@property (nonatomic, weak) id <OrderedDishesViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITableView *orderedDishesLilst;

- (IBAction)goBack:(id)sender;

- (IBAction)submit:(id)sender;

@end
