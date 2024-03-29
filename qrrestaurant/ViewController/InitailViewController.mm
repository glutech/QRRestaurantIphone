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
#import "Restaurant.h"

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

// 使用ZXing扫描二维码
- (IBAction)scan:(id)sender {
    
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

// 扫描完成后，获得对应的餐厅id和餐桌id，跳转至餐厅菜品列表进行点菜
-(void)zxingController:(ZXingWidgetController *)controller didScanResult:(NSString *)result
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    HostViewController *hostViewController = [storyboard instantiateViewControllerWithIdentifier:@"hostViewController"];
    
    NSArray *resultArray = [result componentsSeparatedByString:@"/"];
    NSString *tableIdStr = [resultArray lastObject];
    NSLog(@"got tableId: %@", tableIdStr);

    // 要根据扫描的实际结果来设置不同的值
    hostViewController.rest_id = 1;
    hostViewController.rest_name = @"测试餐厅1";
    hostViewController.hostViewdelegate = self;
    hostViewController.isFromScanView = TRUE;
    
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

@end
