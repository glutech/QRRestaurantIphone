//
//  OrderDishesListViewController.m
//  qrrestaurant
//
//  Created by Jokinryou Tsui on 1/26/14.
//  Copyright (c) 2014 Boke Technology co., ltd. All rights reserved.
//

#import "OrderDishesListViewController.h"
#import "OrderService.h"
#import "ASIHTTPRequest.h"
#import "ParseJson.h"
#import "DishItemCell.h"

@interface OrderDishesListViewController ()

@property (nonatomic, weak) NSString *menuId;

@end

@implementation OrderDishesListViewController
{
    NSMutableArray *_tableItems;
}

@synthesize menuId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{

    OrderService *orderService = [[OrderService alloc] init];
    ASIHTTPRequest *request = [orderService getOrderDishesRequest:menuId];
    [request setDelegate:self];
    [request startAsynchronous];

    [_mainTable setDelegate:self];
    [_mainTable setDataSource:self];

    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_tableItems count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"orderDishesListItemCell";
    DishItemCell *dishItemCell = (DishItemCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    NSDictionary *tempDic = [_tableItems objectAtIndex:indexPath.row];

    dishItemCell.dishNameLabel.text = [tempDic objectForKey:@"dish_name"];
    dishItemCell.dishPriceLabel.text = [NSString stringWithFormat:@"%@", [tempDic objectForKey:@"dish_price"]];

    return dishItemCell;
}


- (IBAction)back:(id)sender {
    [self.delegate orderDishesListViewControllerDidBack:sender];
}

#pragma mark - ASIHTTPRequest
- (void)requestFinished:(ASIHTTPRequest *)request
{
    ParseJson *parseJson = [[ParseJson alloc] init];
    _tableItems = [parseJson parseOrderDishesList:[request responseData]];

    [_mainTable reloadData];
}

@end
