//
//  MyOrdersViewController.h
//  qrrestaurant
//
//  Created by Jokinryou Tsui on 11/23/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyOrdersViewController;

@protocol MyOrdersViewControllerDelegate <NSObject>

- (void) myOrdersViewControllerDidBack: (MyOrdersViewController *)controller;

@end

@interface MyOrdersViewController : UIViewController

@property (nonatomic, weak) id <MyOrdersViewControllerDelegate> delegate;
- (IBAction)back:(id)sender;

@end
