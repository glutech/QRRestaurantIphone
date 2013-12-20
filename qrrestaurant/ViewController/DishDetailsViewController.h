//
//  DishDetailsViewController.h
//  qrrestaurant
//
//  Created by Jokinryou Tsui on 12/11/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DishDetailsViewController;

@protocol DishDetailsViewControllerDelegate <NSObject>

-(void)dismiss:(DishDetailsViewController *)controller;

@end

@interface DishDetailsViewController : UIViewController

@property (nonatomic, weak) id <DishDetailsViewControllerDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIScrollView *dishDetailsScrollView;

- (IBAction)go:(id)sender;

@end
