//
//  InitailViewController.m
//  qrrestaurant
//
//  Created by Jokinryou Tsui on 11/23/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import "InitailViewController.h"
#import "MenuListViewController.h"
#import <ZXingWidgetController.h>
#import <QRCodeReader.h>
#import "HostViewController.h"
#import "MyOrdersViewController.h"
#import "ScanService.h"
#import "RestaurantService.h"

@interface InitailViewController () <ZXingDelegate>

@end

@implementation InitailViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)viewMyOrders:(id)sender {
    
    MyOrdersViewController *myOrdersViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"myOrdersViewController"];
    
    myOrdersViewController.delegate = self;
    
    [self presentViewController:myOrdersViewController animated:YES completion:nil];
}

- (IBAction)viewHistoryOrders:(id)sender {
    MyOrdersViewController *myOrdersViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"myOrdersViewController"];
    
    myOrdersViewController.delegate = self;
    
    [self presentViewController:myOrdersViewController animated:YES completion:nil];
}

- (IBAction)scan:(id)sender {
//    ScanService *service = [[ScanService alloc] init];
//    [service getScanResult:2];
    ZXingWidgetController *widController = [[ZXingWidgetController alloc] initWithDelegate:self showCancel:YES OneDMode:NO];
    
    UIImage *qrOverlyImage = [UIImage imageNamed:@"320x480_bgImg.png"];
    UIImageView *qrOverlayImageView = [[UIImageView alloc] initWithImage:qrOverlyImage];
    qrOverlayImageView.contentMode = UIViewContentModeScaleAspectFill;
    qrOverlayImageView.backgroundColor = [UIColor clearColor];
    
    NSMutableSet *readers = [[NSMutableSet alloc] init];
    QRCodeReader *qrcodeReader = [[QRCodeReader alloc] init];
    [readers addObject:qrcodeReader];
    [widController.overlayView addSubview:qrOverlayImageView];
    widController.readers = readers;
    [self presentViewController:widController animated:YES completion:^{}];
    
}

#pragma mark - ZXingDelegate

-(void)zxingControllerDidCancel:(ZXingWidgetController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)zxingController:(ZXingWidgetController *)controller didScanResult:(NSString *)result
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    HostViewController *hostViewController = [storyboard instantiateViewControllerWithIdentifier:@"hostViewController"];
    
    hostViewController.hostViewdelegate = self;
    
    [controller presentViewController:hostViewController animated:YES completion:nil];
}

- (void)didBack:(HostViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewSelected:(HostViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - MyOrdersViewControllerDelegate
- (void)myOrdersViewControllerDidBack:(MyOrdersViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if ([segue.identifier isEqualToString:@"getRestList"]) {
//        RestaurantService *restaurantService = [[RestaurantService alloc] init];
//        [restaurantService getRestaurantList];
//    }
//}

@end
