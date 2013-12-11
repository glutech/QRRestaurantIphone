//
//  DishDetailsView.m
//  qrrestaurant
//
//  Created by Jokinryou Tsui on 11/29/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import "DishDetailsView.h"

@implementation DishDetailsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.delegate = self;
        self.contentSize = CGSizeMake(320, 800);
        self.pagingEnabled = YES;
        self.userInteractionEnabled = YES;
        self.bounces = NO;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)goBack:(id)sender {
    [UIView transitionWithView:self.superview duration:0.5 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
        [self removeFromSuperview];
    }completion:nil];
}
@end
