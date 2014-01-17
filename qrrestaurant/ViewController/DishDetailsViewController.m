//
//  DishDetailsViewController.m
//  qrrestaurant
//
//  Created by Jokinryou Tsui on 12/11/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import "DishDetailsViewController.h"
#import "UIView+LayerEffects.h"
#import "DishService.h"
#import <QuartzCore/QuartzCore.h>
#import "Dish.h"
#import "TempOrderService.h"
#import "UIImageView+OnlineImage.h"

@interface DishDetailsViewController ()

@end

@implementation DishDetailsViewController
{
    int allPrice;
    int addPrice;
    Dish *_dish;
}

@synthesize delegate, dishDetailsScrollView, dishId;

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
    
    DishService *dService = [[DishService alloc] init];
    _dish = [dService getById:dishId];
    
    self.dishDetailsScrollView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, 300, 200)];
    _dish.dishImagePath = [_dish.dishImagePath stringByAppendingString:@"?imageView/1/w/300/h/200"];
    
    [imageView setOnlineImage:_dish.dishImagePath];
    
    imageView.contentMode = UIViewContentModeCenter;
    
    UILabel *dishName = [[UILabel alloc] initWithFrame:CGRectMake(0, 300, 300, 50)];
    dishName.text = _dish.dishName;
    [dishName setFont:[UIFont systemFontOfSize:15]];
    dishName.textAlignment = NSTextAlignmentCenter;
    
    UILabel *dishDesc = [[UILabel alloc] initWithFrame:CGRectMake(0, 380, 300, 50)];
    dishDesc.text = _dish.dishDescription;
    [dishDesc setFont:[UIFont systemFontOfSize:14]];
    dishDesc.textAlignment = NSTextAlignmentCenter;
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelButton.frame = CGRectMake(0, 430, 120, 100);
    [cancelButton setTitle:@"返回" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(go:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    sureButton.frame = CGRectMake(150, 430, 120, 100);
    [sureButton setTitle:@"我要吃这个" forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(addToShopCar:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.dishDetailsScrollView addSubview:imageView];
    [self.dishDetailsScrollView addSubview:dishName];
    [self.dishDetailsScrollView addSubview:dishDesc];
    [self.dishDetailsScrollView addSubview:cancelButton];
    [self.dishDetailsScrollView addSubview:sureButton];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.dishDetailsScrollView.contentSize = CGSizeMake(300, 500);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)go:(id)sender {
    [self.delegate dismiss:self];
}

//加入购物车 步骤1
- (void)addToShopCar:(UIButton *)button{
    //得到产品信息
//    UITableViewCell *cell = (UITableViewCell *)[bt superview];
//    NSIndexPath *indexPath = [mainTable indexPathForCell:cell];
//    NSDictionary *dic = [dataList objectAtIndex:indexPath.row];
//    addPrice = [[dic valueForKey:@"price"]intValue];
    
    // 将菜品加入临时点菜单
    TempOrderService *tempOrderService = [[TempOrderService alloc] init];
    [tempOrderService insert:_dish];
    
    UIButton *shopCarBt = (UIButton*)[self.view viewWithTag:44];
    
    //加入购物车动画效果
    CALayer *transitionLayer = [[CALayer alloc] init];
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    transitionLayer.opacity = 1.0;
    transitionLayer.contents = (id)button.titleLabel.layer.contents;
    transitionLayer.frame = [[UIApplication sharedApplication].keyWindow convertRect:button.titleLabel.bounds fromView:button.titleLabel];
    [[UIApplication sharedApplication].keyWindow.layer addSublayer:transitionLayer];
    [CATransaction commit];
    
    //路径曲线
    UIBezierPath *movePath = [UIBezierPath bezierPath];
    [movePath moveToPoint:transitionLayer.position];
    CGPoint toPoint = CGPointMake(shopCarBt.center.x + 330, shopCarBt.center.y - 50);
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
    
//    [table reloadData];
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
