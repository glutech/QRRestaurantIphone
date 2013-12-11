//
//  RootScrollView.h
//  SlideSwitchDemo
//
//  Created by liulian on 13-4-23.
//  Copyright (c) 2013年 liulian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootScrollView : UIScrollView <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>
{
    NSArray *viewNameArray;
    CGFloat userContentOffsetX;
    BOOL scrollVertical;
    BOOL isLeftScroll;
    BOOL isVerticalScroll;
}
@property (nonatomic, retain) NSArray *viewNameArray;

@property (nonatomic, retain) NSArray *recommendArray;
@property (nonatomic, retain) NSArray *mostOrderedArray;
@property (nonatomic, retain) NSArray *categoryArray;
@property (nonatomic, retain) NSArray *fullDishesArray;

+ (RootScrollView *)shareInstance;

@end
