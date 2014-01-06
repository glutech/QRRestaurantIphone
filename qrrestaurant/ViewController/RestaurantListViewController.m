//
//  RestaurantListViewController.m
//  qrrestaurant
//
//  Created by Jokinryou Tsui on 12/12/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import "RestaurantListViewController.h"
#import "RestaurantListCell.h"
#import "ASIHTTPRequest.h"
#import "Restaurant.h"
#import "HostViewController.h"

@interface RestaurantListViewController ()

@end

@implementation RestaurantListViewController

@synthesize restList, restService, tempOrderService;

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
    
    restService = [[RestaurantService alloc] init];
    tempOrderService = [[TempOrderService alloc] init];
    ASIHTTPRequest *request = [restService getRestRequest];
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [restList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RestaurantListCell *cell = (RestaurantListCell *)[tableView dequeueReusableCellWithIdentifier:@"RestaurantListCell"];
    
//    cell.restaurantLabel.text = @"测试餐馆";
    Restaurant *rest = [restList objectAtIndex:indexPath.row];
    cell.restaurantLabel.text = rest.rest_name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HostViewController *hostViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"hostViewController"];
    
    hostViewController.hostViewdelegate = self;
    
    [self presentViewController:hostViewController animated:YES completion:nil];
}

- (void)didBack:(HostViewController *)controller
{
    NSInteger count = [tempOrderService getItemCount];
    if (count > 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"不点了？" message:@"不点了意味着您放弃之前在本餐馆点的所有菜品并返回餐馆列表" delegate:self cancelButtonTitle:@"再看看" otherButtonTitles:@"嗯，不点了", nil];
        alert.tag = 1;
        [alert show];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
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

#pragma mark - ASIHTTPRequest
- (void)requestFinished:(ASIHTTPRequest *)request
{
    restList = [restService getRestaurantList:request];
    [self.tableView reloadData];
}

@end
