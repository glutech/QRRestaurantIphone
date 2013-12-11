//
//  MenuListViewController.m
//  qrrestaurant
//
//  Created by Jokinryou Tsui on 11/26/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import "MenuListViewController.h"
#import "TopScrollView.h"
#import "RootScrollView.h"

@interface MenuListViewController ()

@end

@implementation MenuListViewController

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
    [super viewDidLoad];
    
    NSLog(@"我要出来~~~");
    
    UIImageView *topShadowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44, 320, 5)];
    [topShadowImageView setImage:[UIImage imageNamed:@"top_background_shadow.png"]];
    [self.menuSubView addSubview:topShadowImageView];
    
    [self.menuSubView addSubview:[TopScrollView shareInstance]];
    [self.menuSubView addSubview:[RootScrollView shareInstance]];
    
    [self.view addSubview:self.menuSubView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
