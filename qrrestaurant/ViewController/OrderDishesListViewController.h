//
//  OrderDishesListViewController.h
//  qrrestaurant
//
//  Created by Jokinryou Tsui on 1/26/14.
//  Copyright (c) 2014 Boke Technology co., ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrderDishesListViewController;

@protocol OrderDishesListViewControllerDelegate <NSObject>

- (void) orderDishesListViewControllerDidBack : (OrderDishesListViewController *)controller;

@end

@interface OrderDishesListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id <OrderDishesListViewControllerDelegate> delegate;

- (IBAction)back:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *mainTable;

@end
