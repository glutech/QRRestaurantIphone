//
//  OrderedDishesViewController.m
//  qrrestaurant
//
//  Created by Jokinryou Tsui on 12/13/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import "OrderedDishesViewController.h"
#import "OrderedDishCell.h"
#import "Dish.h"

@interface OrderedDishesViewController ()

@end

@implementation OrderedDishesViewController
{
    NSMutableArray *_orderedDishes;
}

@synthesize orderedDishesLilst, delegate;

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
    _orderedDishes = [NSMutableArray array];
    TempOrderDao *tempOrderDao = [[TempOrderDao alloc] init];
    _orderedDishes = [tempOrderDao findAll];
    [super viewDidLoad];
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
    return [_orderedDishes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderedDishCell *cell = (OrderedDishCell *)[tableView dequeueReusableCellWithIdentifier:@"OrderedDishCell"];
    
    Dish *dish = [_orderedDishes objectAtIndex:indexPath.row];
    
    cell.dishName.text = dish.dishName;
    NSNumber *number = [NSNumber numberWithDouble:dish.dishPrice];
    cell.dishPrice.text = [number stringValue];
    cell.dishCount.text = [NSString stringWithFormat:@"%d", dish.dishCount];
    
    return cell;
}

- (IBAction)goBack:(id)sender {
    [self.delegate orderedDishesViewControllerDidBack:self];
}

- (IBAction)submit:(id)sender {
//    [self.delegate orderedDishesViewControllerDidSubmit:self];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"确认提交菜单？" delegate:self cancelButtonTitle:@"再点两个菜" otherButtonTitles:@"是的" , nil];
    [alert setTag:1];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *str = [NSString stringWithFormat:@"%@", [alertView buttonTitleAtIndex:buttonIndex]];
    if ([str isEqualToString:@"是的"]) {
        if (alertView.tag == 1) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"预订单已提交，请到达餐馆后扫描桌面上的二维码进行关联" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil];
            [alert setTag:2];
            [alert show];
        }
    } else if ([str isEqualToString:@"好的"]) {
        if (alertView.tag == 2) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

@end
