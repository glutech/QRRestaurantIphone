//
//  RestaurantListViewController.m
//  qrrestaurant
//
//  Created by Jokinryou Tsui on 12/12/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import "RestaurantListViewController.h"
#import "RestaurantListCell.h"

@interface RestaurantListViewController ()

@end

@implementation RestaurantListViewController

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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RestaurantListCell *cell = (RestaurantListCell *)[tableView dequeueReusableCellWithIdentifier:@"RestaurantListCell"];
    
    cell.restaurantLabel.text = @"测试餐馆";
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toDishList"]) {
        
        HostViewController *hostViewController = segue.destinationViewController;
        
        hostViewController.hostViewdelegate = self;
    }
}

- (void)didBack:(HostViewController *)controller
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"不点了？" message:@"不点了意味着您放弃之前在本餐馆点的所有菜品并返回餐馆列表" delegate:self cancelButtonTitle:@"再看看" otherButtonTitles:@"嗯，不点了", nil];
    alert.tag = 1;
    [alert show];
//    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *str = [NSString stringWithFormat:@"%@", [alertView buttonTitleAtIndex:buttonIndex]];
    if ([str isEqualToString:@"嗯，不点了"]) {
        if (alertView.tag == 1) {
            TempOrderDao *tempOrderDao = [[TempOrderDao alloc] init];
            [tempOrderDao deleteAll];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)viewSelected:(HostViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
