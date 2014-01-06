//
//  HostViewController.m
//  qrrestaurant
//
//  Created by Jokinryou Tsui on 12/11/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import "HostViewController.h"
#import "ContentViewController.h"

@interface HostViewController () <ViewPagerDataSource, ViewPagerDelegate>

@end

@implementation HostViewController
{
    NSMutableArray *tabItems;
}

@synthesize orderedDishesViewController, tempDishes;

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
    
    self.dataSource = self;
    self.delegate = self;
    
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:nil];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack:)];
    UIBarButtonItem *selectedButton = [[UIBarButtonItem alloc] initWithTitle:@"已点" style:UIBarButtonItemStyleDone target:self action:@selector(selected:)];
    
    [navigationItem setTitle:@"测试餐馆"];
    
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    
    [navigationItem setLeftBarButtonItem:backButton];
    [navigationItem setRightBarButtonItem:selectedButton];
    
    [self.view addSubview:navigationBar];
    
    //Keeps tab bar below navigation bar on iOS 7.0+
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    tabItems = [NSMutableArray arrayWithObjects:@"推荐菜品",@"点菜排行",@"全部菜品", nil];
    
    tempDishes = [[NSMutableArray alloc] init];
    
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    orderedDishesViewController = [storyboard instantiateViewControllerWithIdentifier:@"orderedDishesViewController"];
    orderedDishesViewController.delegate = self;
}

#pragma mark - ViewPageDataSource
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return 3;
}
- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
    
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:13.0];
    //    label.text = [NSString stringWithFormat:@"Content View #%i", index];
    label.text = [NSString stringWithFormat:@"%@", [tabItems objectAtIndex:index]];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    [label sizeToFit];
    
    return label;
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    
    ContentViewController *cvc = [[ContentViewController alloc] initWithNibName:@"ContentViewController" bundle:nil];
    
    cvc.delegate = self;
    
    return cvc;
}

#pragma mark - ViewPagerDelegate
- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value {
    
    switch (option) {
        case ViewPagerOptionStartFromSecondTab:
            return 0.0;
            break;
        case ViewPagerOptionCenterCurrentTab:
            return 0.0;
            break;
        case ViewPagerOptionTabLocation:
            return 1.0;
            break;
        default:
            break;
    }
    
    return value;
}

- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color {
    
    switch (component) {
        case ViewPagerIndicator:
            return [[UIColor redColor] colorWithAlphaComponent:0.64];
            break;
        default:
            break;
    }
    
    return color;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBack:(id)sender {
    [self.hostViewdelegate didBack:self];
}

- (IBAction)selected:(id)sender {
    [self presentViewController:orderedDishesViewController animated:YES completion:nil];
}

- (void)contentViewControllerDelegateDidSelect:(Dish *)dish
{
    TempOrderService *tempOrderService = [[TempOrderService alloc] init];
    [tempOrderService insert:dish];
}

- (void)orderedDishesViewControllerDidBack:(OrderedDishesViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)orderedDishesViewControllerDidSubmit:(OrderedDishesViewController *)controller
{
    NSLog(@"submit~~~~~");
}

@end
