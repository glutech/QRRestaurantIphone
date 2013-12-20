//
//  ContentViewController.h
//  qrrestaurant
//
//  Created by Jokinryou Tsui on 12/11/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DishDetailsViewController.h"
#import "Dish.h"

@class ContentViewController;

@protocol ContentViewControllerDelegate <NSObject>

- (void)contentViewControllerDelegateDidSelect:(Dish *)dish;

@end

@interface ContentViewController : UIViewController <UIGestureRecognizerDelegate, DishDetailsViewControllerDelegate>

@property (nonatomic, weak) id <ContentViewControllerDelegate> delegate;

@property NSString *type;

@property (weak, nonatomic) IBOutlet UITableView *table;

- (IBAction)viewDishDetails:(id)sender;

@end
