//
//  HostViewController.m
//  qrrestaurant
//
//  Created by Jokinryou Tsui on 12/11/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import "HostViewController.h"
#import "ContentViewController.h"
#import "SRWebSocket.h"
#import "RestaurantService.h"

@interface TCMessage : NSObject

- (id)initWithMessage:(NSString *)message fromMe:(BOOL)fromMe;

@property (nonatomic, retain, readonly) NSString *message;
@property (nonatomic, readonly) BOOL fromMe;

@end

@interface HostViewController () <ViewPagerDataSource, ViewPagerDelegate, SRWebSocketDelegate>

@end

@implementation HostViewController
{
    NSMutableArray *tabItems;
    SRWebSocket *_webSocket;
    NSMutableArray *_messages;
}

@synthesize orderedDishesViewController, tempDishes, rest_id, isFromScanView, rest_name;

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
    
    [navigationItem setTitle:rest_name];
    
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
    
    _messages = [[NSMutableArray alloc] init];
    
    // 若是通过扫描二维码进入，则是现场点餐，可能存在协同点餐，需要socket，否则不需要
    if (isFromScanView) {
        [self _reconnect];
    }
    
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
    cvc.type = [NSString stringWithFormat:@"%i", index];
    cvc.rest_id = rest_id;
    
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

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    _webSocket.delegate = nil;
    [_webSocket close];
    _webSocket = nil;
}

- (IBAction)goBack:(id)sender {
    
    [_webSocket close];
    _webSocket = nil;
    
    [self.hostViewdelegate didBack:self];
}

// 查看已点的菜
- (IBAction)selected:(id)sender {
    
    //要先通过socket获取已点的菜，以网络上的为准
    // 取取取...
    // 到orderedDishesViewController之后用delegate实现
    
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

#pragma mark - SRWebSocket

- (void)_reconnect
{
    _webSocket.delegate = nil;
    [_webSocket close];
    
    
    NSString *wsURLString = [WSHOST_NAME stringByAppendingString:@"wsservlet/WSOrderWSServlet?tid=2&uid=1"];
    
    NSLog(@"address: %@", wsURLString);
    
    _webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:wsURLString]]];
    _webSocket.delegate = self;
    
    [_webSocket open];
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
    NSLog(@"Websocket Connected!");
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    NSLog(@":( Websocket Failed With Error %@", error);
    _webSocket = nil;
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    NSLog(@"Received: \"%@\"", message);
    
    // 用" "（空格）将收到的消息字符串分割
    NSArray *msgArray = [message componentsSeparatedByString:@" "];
    NSString *operationKey = [msgArray objectAtIndex:0];
    NSLog(@"operation: %@", operationKey);
    
//    [_messages addObject:[[TCMessage alloc] initWithMessage:message fromMe:NO]];
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    NSLog(@"WebSocket closed!");
    _webSocket = nil;
}

@end

@implementation TCMessage

@synthesize message = _message;
@synthesize fromMe = _fromMe;

- (id)initWithMessage:(NSString *)message fromMe:(BOOL)fromMe
{
    self = [super init];
    if (self) {
        _fromMe = fromMe;
        _message = message;
    }
    
    return self;
}

@end
