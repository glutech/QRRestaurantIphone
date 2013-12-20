//
//  InitailViewController.h
//  qrrestaurant
//
//  Created by Jokinryou Tsui on 11/23/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HostViewController.h"
#import "MyOrdersViewController.h"

@interface InitailViewController : UITableViewController <HostViewControllerDelegate, MyOrdersViewControllerDelegate>

- (IBAction)viewMyOrders:(id)sender;
- (IBAction)viewHistoryOrders:(id)sender;

- (IBAction)scan:(id)sender;

@end
