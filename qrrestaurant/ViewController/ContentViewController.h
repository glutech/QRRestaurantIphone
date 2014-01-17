//
//  ContentViewController.h
//  qrrestaurant
//
//  Created by Jokinryou Tsui on 12/26/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DishDetailsViewController.h"
#import "Dish.h"
#import "DishItemCell.h"
#import "RestaurantService.h"

@class ContentViewController;

@protocol ContentViewControllerDelegate <NSObject>

- (void)contentViewControllerDelegateDidSelect:(Dish *)dish;

@end

@interface ContentViewController : UIViewController <UIGestureRecognizerDelegate, DishDetailsViewControllerDelegate, UIScrollViewDelegate>

@property (nonatomic, weak) id <ContentViewControllerDelegate> delegate;

@property (nonatomic, strong) RestaurantService *restService;

@property (weak, nonatomic) IBOutlet UITableView *mainTable;

@property NSString *type;
@property NSInteger *rest_id;
@property NSMutableArray *dishes;

//@property (weak, nonatomic) IBOutlet UITableView *table;

- (IBAction)viewDishDetails:(id)sender;

@end
