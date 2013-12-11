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

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if ([segue.identifier isEqualToString:@"toMyOrders"]) {
//        UINavigationController *navigationController = segue.destinationViewController;
//        MyOrdersViewController *myOrderViewController = [[navigationController viewControllers] objectAtIndex:0];
//        myOrderViewController.delegate = self;
//    }
//}

//#pragma mark - MyOrdersViewControllerDelegate
//
//- (void)myOrdersViewControllerDidBack:(MyOrdersViewController *)controller
//{
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

- (IBAction)scan:(id)sender {
//    ZXingWidgetController *widController = [[ZXingWidgetController alloc] initWithDelegate:self showCancel:YES OneDMode:NO];
//    
//    UIImage *qrOverlyImage = [UIImage imageNamed:@"320x480_bgImg.png"];
//    UIImageView *qrOverlayImageView = [[UIImageView alloc] initWithImage:qrOverlyImage];
//    qrOverlayImageView.contentMode = UIViewContentModeScaleAspectFill;
//    qrOverlayImageView.backgroundColor = [UIColor clearColor];
//    
//    NSMutableSet *readers = [[NSMutableSet alloc] init];
//    QRCodeReader *qrcodeReader = [[QRCodeReader alloc] init];
//    [readers addObject:qrcodeReader];
//    [widController.overlayView addSubview:qrOverlayImageView];
//    widController.readers = readers;
//    [self presentViewController:widController animated:YES completion:^{}];
    
    NSLog(@"scan completed! 我跳~~~");
    MenuListViewController *menuListViewController = [[MenuListViewController alloc] init];
//    UITableViewController *aaa = [[UITableViewController alloc] init];
//    [self.navigationController pushViewController:menuListViewController animated:YES];
//    [self presentViewController:menuListViewController animated:YES completion:^{}];
}

#pragma mark - ZXingDelegate

-(void)zxingControllerDidCancel:(ZXingWidgetController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)zxingController:(ZXingWidgetController *)controller didScanResult:(NSString *)result
{
    NSLog(@"scan completed! 我跳~~~");
    MenuListViewController *menuListViewController = [[MenuListViewController alloc] init];
    [self addChildViewController:menuListViewController];
//    [self.navigationController pushViewController:menuListViewController animated:YES];
//    [self presentViewController:menuListViewController animated:YES completion:^{}];
    [self transitionFromViewController:self toViewController:[self.childViewControllers objectAtIndex:0] duration:4 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{} completion:^(BOOL finished){}];
}

@end
