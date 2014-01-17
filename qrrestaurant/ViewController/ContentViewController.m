//
//  ContentViewController.m
//  qrrestaurant
//
//  Created by Jokinryou Tsui on 12/26/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import "ContentViewController.h"
#import "DishDetailsViewController.h"
#import "UIViewController+CWPopup.h"
#import "UIGlossyButton.h"
#import "UIView+LayerEffects.h"
#import <QuartzCore/QuartzCore.h>
#import "ASIHTTPRequest.h"
#import "DishService.h"
#import "ParseJson.h"
#import "CategoryService.h"
#import "DishCategory.h"
#import "MyTapGesture.h"
#import "UIImageView+OnlineImage.h"

@interface ContentViewController () <UITableViewDataSource, UITableViewDelegate> {
    int addPrice;
    int allPrice;
    NSArray *_categoryList;
    NSMutableArray *_catTitleList;
    NSDictionary *_cat_dishes;
}

@end

@implementation ContentViewController

@synthesize mainTable, dishes, type, rest_id, restService;

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
    // Do any additional setup after loading the view from its nib.
    
    // 发出http请求，根据rest_id获得菜品
    restService = [[RestaurantService alloc] init];
    ASIHTTPRequest *request = [restService getDishesRequest:rest_id];
    [request setDelegate:self];
    [request startAsynchronous];
    
    self.useBlurForPopup = YES;
    
    [mainTable setDelegate:self];
    [mainTable setDataSource:self];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    int i = 0;
    if ([type isEqualToString:@"2"]) {
        i = _categoryList.count;
    } else {
        i = 1;
    }
    return i;
//    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int i = 0;
    if ([type isEqualToString:@"2"]) {
        DishCategory *dCat = [_categoryList objectAtIndex:section];
        NSString *key = [NSString stringWithFormat:@"%i", dCat.cat_id];
        i = [[_cat_dishes objectForKey:key] count];
    } else {
        i = [dishes count];
    }
    return i;
//    return [dishes count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 84;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    static NSString *GroupedTableIdentifier = @"DishItemCell";
    DishItemCell *cell = (DishItemCell *)[tableView dequeueReusableCellWithIdentifier:
                          GroupedTableIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DishItemCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    if ([type isEqualToString:@"2"]) {
        
        DishCategory *dCat = [_categoryList objectAtIndex:section];
        NSString *key = [NSString stringWithFormat:@"%i", dCat.cat_id];
        dishes = [_cat_dishes objectForKey:key];
    }
    
    Dish *d = [dishes objectAtIndex:row];
    cell.dishNameLabel.text = d.dishName;
    NSNumber *number = [NSNumber numberWithDouble:d.dishPrice];
    cell.dishPriceLabel.text = [number stringValue];
//    [cell.dishImage setImage:[UIImage imageNamed:d.dishImagePath] forState:UIControlStateNormal];
    
    MyTapGesture *singleTap = [[MyTapGesture alloc] initWithTarget:self action:@selector(viewDishDetails:)];
    singleTap.objTag = row;
    singleTap.objSection = section;
    [singleTap setNumberOfTapsRequired:1];
    cell.dishImage.userInteractionEnabled = YES;
    [cell.dishImage addGestureRecognizer:singleTap];
    
    [cell.dishImage setOnlineImage:d.dishImagePath];
    
    [cell.dishImage setTag:row];
    
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *result = @"";
    if ([type isEqualToString:@"2"]) {
        DishCategory *dCat = [_categoryList objectAtIndex:section];
        result = dCat.cat_name;
    }
    return result;
//    return @"";
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSArray *result = [[NSArray alloc] init];
    if ([type isEqualToString:@"2"]) {
        result = _catTitleList;
    }
    return result;
//    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int sec = indexPath.section;
    
    if ([type isEqualToString:@"2"]) {
        DishCategory *dCat = [_categoryList objectAtIndex:sec];
        NSString *key = [NSString stringWithFormat:@"%i", dCat.cat_id];
        dishes = [_cat_dishes objectForKey:key];
    }
    
    Dish *dish = [[Dish alloc] init];
    dish = [dishes objectAtIndex:indexPath.row];
    [self.delegate contentViewControllerDelegateDidSelect:dish];
    
    
    DishItemCell *cell = (DishItemCell *)[tableView cellForRowAtIndexPath:indexPath];
    [self addToShopCar:cell];
}

#pragma mark - Popup Functions, DishDetailsViewControllerDelegate
-(void)dismiss:(DishDetailsViewController *)controller
{
    if (self.popupViewController != nil) {
        [self dismissPopupViewControllerAnimated:YES completion:^{}];
    }
    
    [mainTable reloadData];
}

#pragma mark - gesture recognizer delegate functions

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return touch.view == self.view;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)viewDishDetails:(id)sender {
    
    MyTapGesture *g = (MyTapGesture *)sender;
    int indexrow = g.objTag;
    int sec = g.objSection;
    
    if ([type isEqualToString:@"2"]) {
        
        DishCategory *dCat = [_categoryList objectAtIndex:sec];
        NSString *key = [NSString stringWithFormat:@"%i", dCat.cat_id];
        dishes = [_cat_dishes objectForKey:key];
    }
    
    Dish *dish = [[Dish alloc] init];
    dish = [dishes objectAtIndex:indexrow];
    
    DishDetailsViewController *dishDetailsViewController = [[DishDetailsViewController alloc] initWithNibName:@"DishDetailsViewController" bundle:nil];
    
    dishDetailsViewController.delegate = self;
    dishDetailsViewController.dishId = dish.dishId;
    
    [self presentPopupViewController:dishDetailsViewController animated:YES completion:^{}];
}

//加入购物车 步骤1
- (void)addToShopCar:(DishItemCell *)cell{
    //得到产品信息
    //    UITableViewCell *cell = (UITableViewCell *)[bt superview];
    //    NSIndexPath *indexPath = [mainTable indexPathForCell:cell];
    //    NSDictionary *dic = [dataList objectAtIndex:indexPath.row];
    //    addPrice = [[dic valueForKey:@"price"]intValue];
    
    UIButton *shopCarBt = (UIButton*)[self.view viewWithTag:44];
    
    //加入购物车动画效果
    CALayer *transitionLayer = [[CALayer alloc] init];
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    transitionLayer.opacity = 1.0;
    transitionLayer.contents = (id)cell.dishNameLabel.layer.contents;
    transitionLayer.frame = [[UIApplication sharedApplication].keyWindow convertRect:cell.dishNameLabel.bounds fromView:cell.dishNameLabel];
    [[UIApplication sharedApplication].keyWindow.layer addSublayer:transitionLayer];
    [CATransaction commit];
    
    //路径曲线
    UIBezierPath *movePath = [UIBezierPath bezierPath];
    [movePath moveToPoint:transitionLayer.position];
//    CGPoint toPoint = CGPointMake(shopCarBt.center.x, shopCarBt.center.y + 60);
    CGPoint toPoint = CGPointMake(shopCarBt.center.x + 420, shopCarBt.center.y + 40);
    [movePath addQuadCurveToPoint:toPoint
                     controlPoint:CGPointMake(shopCarBt.center.x,transitionLayer.position.y-120)];
    //关键帧
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.path = movePath.CGPath;
    positionAnimation.removedOnCompletion = YES;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.beginTime = CACurrentMediaTime();
    group.duration = 0.7;
    group.animations = [NSArray arrayWithObjects:positionAnimation,nil];
    group.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    group.delegate = self;
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    group.autoreverses= NO;
    
    [transitionLayer addAnimation:group forKey:@"opacity"];
    [self performSelector:@selector(addShopFinished:) withObject:transitionLayer afterDelay:0.5f];
}
//加入购物车 步骤2
- (void)addShopFinished:(CALayer*)transitionLayer{
    
    [mainTable reloadData];
    transitionLayer.opacity = 0;
    UIButton *shopCarBt = (UIButton*)[self.view viewWithTag:755];
    if (shopCarBt.hidden) {
        NSString *str = [NSString stringWithFormat:@"￥%i",addPrice];
        [shopCarBt setTitle:str forState:UIControlStateNormal];
        [shopCarBt setHidden:NO];
    }
    else{
        allPrice = allPrice + addPrice;
        NSString *str = [NSString stringWithFormat:@"￥%i",allPrice];
        [shopCarBt setTitle:str forState:UIControlStateNormal];
        
        //加入购物车动画效果
        UILabel *addLabel = (UILabel*)[self.view viewWithTag:766];
        [addLabel setText:[NSString stringWithFormat:@"+%i",addPrice]];
        
        CALayer *transitionLayer1 = [[CALayer alloc] init];
        [CATransaction begin];
        [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
        transitionLayer1.opacity = 1.0;
        transitionLayer1.contents = (id)addLabel.layer.contents;
        transitionLayer1.frame = [[UIApplication sharedApplication].keyWindow convertRect:addLabel.bounds fromView:addLabel];
        [[UIApplication sharedApplication].keyWindow.layer addSublayer:transitionLayer1];
        [CATransaction commit];
        
        CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        positionAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(addLabel.frame.origin.x+30, addLabel.frame.origin.y+20)];
        positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(addLabel.frame.origin.x+30, addLabel.frame.origin.y)];
        
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.fromValue = [NSNumber numberWithFloat:1.0];
        opacityAnimation.toValue = [NSNumber numberWithFloat:0];
        
        CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
        rotateAnimation.fromValue = [NSNumber numberWithFloat:0 * M_PI];
        rotateAnimation.toValue = [NSNumber numberWithFloat:2 * M_PI];
        
        CAAnimationGroup *group = [CAAnimationGroup animation];
        group.beginTime = CACurrentMediaTime();
        group.duration = 0.3;
        group.animations = [NSArray arrayWithObjects:positionAnimation,opacityAnimation,nil];
        group.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        group.delegate = self;
        group.fillMode = kCAFillModeForwards;
        group.removedOnCompletion = NO;
        group.autoreverses= NO;
        [transitionLayer1 addAnimation:group forKey:@"opacity"];
    }
}

#pragma mark - ASIHTTPRequest
- (void)requestFinished:(ASIHTTPRequest *)request
{
    [restService saveDishesAndCatList:request];
    
    if ([type isEqualToString:@"0"]) {
        dishes = [restService getRecommendDishes];
    } else if ([type isEqualToString:@"1"]) {
        dishes = [restService getDishesByCount];
    } else if ([type isEqualToString:@"2"]) {
//        dishes = [restService getAllDishes];
        DishService *dService = [[DishService alloc] init];
        CategoryService *cService = [[CategoryService alloc] init];
        _cat_dishes = [dService getDishesByCat];
        _categoryList = [cService findAll];
        _catTitleList = [[NSMutableArray alloc] init];
        for (int i=0; i<_categoryList.count; i++) {
            DishCategory *dCat = [_categoryList objectAtIndex:i];
            [_catTitleList addObject:dCat.cat_name];
        }
    }
    
    [mainTable reloadData];
}

@end
