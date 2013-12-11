//
//  RootScrollView.m
//  SlideSwitchDemo
//
//  Created by liulian on 13-4-23.
//  Copyright (c) 2013年 liulian. All rights reserved.
//

#import "RootScrollView.h"
#import "Globle.h"
#import "TopScrollView.h"
#import "MostOrdered.h"
#import "CategoryList.h"
#import "FullDishesList.h"
#import "MostOrderedCell.h"
#import "CategoryCell.h"
#import "FullDishesCell.h"
#import "RecommendCell.h"
#import "RecommendDishes.h"
#import "MenuListViewController.h"
#import "DishDetailsView.h"

#define POSITIONID (int)scrollView.contentOffset.x/320

@implementation RootScrollView

@synthesize viewNameArray, mostOrderedArray, categoryArray, fullDishesArray;

+ (RootScrollView *)shareInstance {
    static RootScrollView *__singletion;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __singletion=[[self alloc] initWithFrame:CGRectMake(0, 44, 320, [Globle shareInstance].globleHeight-44)];
    });
    return __singletion;
}

- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        
        self.viewNameArray = [NSArray arrayWithObjects:@"推荐菜品", @"点菜排行", @"全部菜品", nil];
        self.contentSize = CGSizeMake(320*[viewNameArray count], [Globle shareInstance].globleHeight-44);
        self.pagingEnabled = YES;
        self.userInteractionEnabled = YES;
        self.bounces = NO;
        
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
        userContentOffsetX = 0;
        
        [self initWithViews];
    }
    return self;
}

- (void)initWithViews
{
    NSArray *temp = [NSArray arrayWithObjects:@"番茄鸡蛋", @"爆炒猪肝", @"葱烧海参", nil];
    self.mostOrderedArray = temp;
    NSArray *temp1 = [NSArray arrayWithObjects:@"热菜", @"凉拌", @"主食", nil];
    self.categoryArray = temp1;
    self.fullDishesArray = temp;
    self.recommendArray = temp;
    
    for (int i = 0; i < [viewNameArray count]; i++) {
        if (i == 0) {
            RecommendDishes *recommendTableView = [[RecommendDishes alloc] initWithFrame:CGRectMake(320*i, 0, 320, [Globle shareInstance].globleAllHeight-44)];
            [recommendTableView setTag:0];
            [self addSubview:recommendTableView];
            recommendTableView.delegate = self;
            recommendTableView.dataSource = self;
        } else if (i == 1) {
            MostOrdered *mostOrderedTableView = [[MostOrdered alloc] initWithFrame:CGRectMake(320*i, 0, 320, [Globle shareInstance].globleHeight-44)];
            [mostOrderedTableView setTag:1];
            [self addSubview:mostOrderedTableView];
            mostOrderedTableView.delegate = self;
            mostOrderedTableView.dataSource = self;
        } else {
            CategoryList *categoryTableView = [[CategoryList alloc] initWithFrame:CGRectMake(320*i, 0, 80, [Globle shareInstance].globleHeight-44)];
            [categoryTableView setTag:2];
            [self addSubview:categoryTableView];
            categoryTableView.delegate = self;
            categoryTableView.dataSource = self;
            
            FullDishesList *fullDishesTableView = [[FullDishesList alloc] initWithFrame:CGRectMake(320*i+80, 0, 220, [Globle shareInstance].globleHeight-44)];
            [fullDishesTableView setTag:3];
            [self addSubview:fullDishesTableView];
            fullDishesTableView.delegate = self;
            fullDishesTableView.dataSource = self;
        }
        
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    userContentOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (userContentOffsetX < scrollView.contentOffset.x) {
        isLeftScroll = YES;
    }
    else {
        isLeftScroll = NO;
    }
    
    // 记录用户是不是垂直滚动，垂直滚动的话不需要改变topView
    isVerticalScroll = NO;
    if (scrollView.contentOffset.y != 0) {
        isVerticalScroll = YES;
        scrollVertical = isVerticalScroll;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //调整顶部滑条按钮状态
    if (!scrollVertical) {
        [self adjustTopScrollViewButton:scrollView];
    }
    scrollVertical = NO;
    
    if (isLeftScroll) {
        if (scrollView.contentOffset.x <= 320) {
            [[TopScrollView shareInstance] setContentOffset:CGPointMake(0, 0) animated:YES];
        }
        else {
            [[TopScrollView shareInstance] setContentOffset:CGPointMake((POSITIONID-2)*BUTTONWIDTH+45, 0) animated:YES];
        }
        
    }
    else {
        if (scrollView.contentOffset.x >= 320) {
            [[TopScrollView shareInstance] setContentOffset:CGPointMake(BUTTONWIDTH-45, 0) animated:YES];
        }
        else {
            [[TopScrollView shareInstance] setContentOffset:CGPointMake(POSITIONID*BUTTONWIDTH, 0) animated:YES];
        }
    }
}

- (void)adjustTopScrollViewButton:(UIScrollView *)scrollView
{
    [[TopScrollView shareInstance] setButtonUnSelect];
    [TopScrollView shareInstance].scrollViewSelectedChannelID = POSITIONID+100;
    [[TopScrollView shareInstance] setButtonSelect];
}

#pragma mark - UITableViewDelegte Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = 0;
    if (tableView.tag == 0) {
        count = [self.recommendArray count];
    } else if (tableView.tag == 1) {
        count = [self.mostOrderedArray count];
    } else if (tableView.tag == 2) {
        count = [self.categoryArray count];
    } else {
        count = [self.fullDishesArray count];
    }
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height = 0;
    
    if (tableView.tag == 0) {
        height = 80.0f;
    } else if (tableView.tag == 1) {
        height = 80.0f;
    } else if (tableView.tag == 2) {
        height = 30.0f;
    } else {
        height = 80.0f;
    }
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *recommendCell = @"recommendCell";
    static NSString *mostOrderedCell = @"mostOrderedCell";
    static NSString *categoryCell = @"categoryCell";
    static NSString *fullDishesCell = @"fullDishesCell";
    
    UITableViewCell *resultCell = [[UITableViewCell alloc] init];
    
    if (tableView.tag == 0) {
        [tableView registerNib:[UINib nibWithNibName:@"RecommendCell" bundle:nil] forCellReuseIdentifier:recommendCell];
        
        RecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:recommendCell];
        cell.dishNameLabel.text = [self.mostOrderedArray objectAtIndex:[indexPath row]];
        cell.priceLabel.text = @"10.0";
        cell.priceLabel.textColor = [UIColor redColor];
        cell.dishImage.image = [UIImage imageNamed:@"item3.png"];
        resultCell = cell;
    } else if (tableView.tag == 1) {
        [tableView registerNib:[UINib nibWithNibName:@"MostOrderedCell" bundle:nil] forCellReuseIdentifier:mostOrderedCell];
        
        MostOrderedCell *cell = [tableView dequeueReusableCellWithIdentifier:mostOrderedCell];
        cell.dishNameLabel.text = [self.mostOrderedArray objectAtIndex:[indexPath row]];
        cell.priceLabel.text = @"10.0";
        cell.priceLabel.textColor = [UIColor redColor];
        cell.dishImage.image = [UIImage imageNamed:@"item2.png"];
        resultCell = cell;
    } else if (tableView.tag == 2) {
        [tableView registerNib:[UINib nibWithNibName:@"CategoryCell" bundle:nil] forCellReuseIdentifier:categoryCell];
        
        CategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:categoryCell];
        cell.categoryNameLabel.text = [self.categoryArray objectAtIndex:[indexPath row]];
        resultCell = cell;
    } else {
        [tableView registerNib:[UINib nibWithNibName:@"FullDishesCell" bundle:nil] forCellReuseIdentifier:fullDishesCell];
        
        FullDishesCell *cell = [tableView dequeueReusableCellWithIdentifier:fullDishesCell];
        cell.dishNameLabel.text = [self.mostOrderedArray objectAtIndex:[indexPath row]];
        cell.priceLabel.text = @"10.0";
        cell.priceLabel.textColor = [UIColor redColor];
        cell.dishImage.image = [UIImage imageNamed:@"item1.png"];
        resultCell = cell;
    }
    
    return resultCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DishDetailsView *dishDetailsView = [[DishDetailsView alloc] initWithFrame:CGRectMake(0, 0, 320, 500)];
    
    [UIView transitionWithView:self.superview duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        [self.superview addSubview:dishDetailsView];
    }completion:nil];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
