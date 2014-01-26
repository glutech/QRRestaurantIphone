//
//  MyOrdersViewController.m
//  qrrestaurant
//
//  Created by Jokinryou Tsui on 11/23/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import "MyOrdersViewController.h"
#import "ASIHTTPRequest.h"
#import "OrderService.h"
#import "ParseJson.h"
#import "OrderListCell.h"
#import "OrderListItem.h"

@interface MyOrdersViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation MyOrdersViewController
{
    NSMutableArray *_tableItems;
    int _selectedOrderId;
}

@synthesize delegate, listTable;

- (void)viewDidLoad
{
    [super viewDidLoad];

    OrderService *orderService = [[OrderService alloc] init];
    ASIHTTPRequest *request = [orderService getOrdersRequest];
    [request setDelegate:self];
    [request startAsynchronous];

    [listTable setDelegate:self];
    [listTable setDataSource:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_tableItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"orderListCell";
    OrderListCell *cell = (OrderListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    OrderListItem *orderListItem = [_tableItems objectAtIndex:indexPath.row];

    cell.restName.text = orderListItem.restName;
    cell.menuPrice.text = orderListItem.menuPrice;
    cell.menuTime.text = orderListItem.menuTime;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    OrderListItem *orderListItem = [_tableItems objectAtIndex:indexPath.row];

    // 这个地方order和menu其实是一个概念，好乱...
    _selectedOrderId = orderListItem.menuId;

    OrderDishesListViewController *orderDishesListViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"orderDishesListViewController"];

    orderDishesListViewController.delegate = self;

    NSLog(@"selectedId: %d", _selectedOrderId);

    [orderDishesListViewController setValue:[NSString stringWithFormat:@"%d", _selectedOrderId] forKey:@"menuId"];

    [self presentViewController:orderDishesListViewController animated:YES completion:nil];
}


#pragma mark - ASIHTTPRequest
- (void)requestFinished:(ASIHTTPRequest *)request
{
    ParseJson *parseJson = [[ParseJson alloc] init];
    _tableItems = [parseJson parseOrderList:[request responseData]];

    [listTable reloadData];
}

- (IBAction)back:(id)sender {
    [self.delegate myOrdersViewControllerDidBack:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toOrderDishesList"]) {

    }
}

#pragma mark - OrderDishesListViewControllerDelegate

- (void)orderDishesListViewControllerDidBack:(OrderDishesListViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];

    [listTable reloadData];
}

@end
