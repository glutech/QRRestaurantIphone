//
//  RegisterViewController.m
//  qrrestaurant
//
//  Created by Jokinryou Tsui on 12/18/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import "RegisterViewController.h"
#import "MyOrdersViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)register:(id)sender {
    MyOrdersViewController *myOrdersViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"myOrdersViewController"];
    
    [self presentViewController:myOrdersViewController animated:YES completion:nil];
}
@end
