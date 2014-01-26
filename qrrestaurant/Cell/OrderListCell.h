//
//  OrderListCell.h
//  qrrestaurant
//
//  Created by Jokinryou Tsui on 1/22/14.
//  Copyright (c) 2014 Boke Technology co., ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *restName;

@property (weak, nonatomic) IBOutlet UILabel *menuTime;

@property (weak, nonatomic) IBOutlet UILabel *menuPrice;

@end
