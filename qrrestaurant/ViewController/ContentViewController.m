//
//  ContentViewController.m
//  qrrestaurant
//
//  Created by Jokinryou Tsui on 12/11/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import "ContentViewController.h"
#import "DishItemCell.h"
#import "DishDetailsViewController.h"
#import "UIViewController+CWPopup.h"
#import "UIGlossyButton.h"
#import "UIView+LayerEffects.h"
#import <QuartzCore/QuartzCore.h>

@interface ContentViewController ()

@end

@implementation ContentViewController
{
    NSMutableArray *dishes;
    int addPrice;
    int allPrice;
}

@synthesize table, delegate;

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
	// Do any additional setup after loading the view.
    
    dishes = [NSMutableArray arrayWithCapacity:20];
    
    Dish *dish = [[Dish alloc] init];
    dish.dishId = 1;
    dish.dishName = @"番茄鸡蛋";
    dish.dishPrice = 10.0;
    dish.dishImagePath = @"item1";
    
    [dishes addObject:dish];
    
    dish = [[Dish alloc] init];
    dish.dishId = 2;
    dish.dishName = @"爆炒猪肝";
    dish.dishPrice = 15.0;
    dish.dishImagePath = @"item2";
    
    [dishes addObject:dish];
    
    dish = [[Dish alloc] init];
    dish.dishId = 3;
    dish.dishName = @"葱烧海参";
    dish.dishPrice = 20.0;
    dish.dishImagePath = @"item3";
    
    [dishes addObject:dish];
    
    self.useBlurForPopup = YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dishes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger section = [indexPath section];
    
    static NSString *GroupedTableIdentifier = @"cell";
    DishItemCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             GroupedTableIdentifier];
    if (cell == nil) {
        cell = [[DishItemCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:GroupedTableIdentifier];
    }
    
    Dish *d = [dishes objectAtIndex:indexPath.row];
    cell.dishNameLabel.text = d.dishName;
    NSNumber *number = [NSNumber numberWithDouble:d.dishPrice];
    cell.dishPriceLabel.text = [number stringValue];
    [cell.dishImage setImage:[UIImage imageNamed:d.dishImagePath] forState:UIControlStateNormal];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"";
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    [self.table reloadData];
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
    DishDetailsViewController *dishDetailsViewController = [[DishDetailsViewController alloc] initWithNibName:@"DishDetailsViewController" bundle:nil];
    
    dishDetailsViewController.delegate = self;
    
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
    
    [table reloadData];
    transitionLayer.opacity = 0;
    UIButton *shopCarBt = (UIButton*)[self.view viewWithTag:55];
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
        UILabel *addLabel = (UILabel*)[self.view viewWithTag:66];
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
@end
