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
@end
