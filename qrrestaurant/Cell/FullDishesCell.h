//
//  FullDishesCell.h
//  qrrestaurant
//
//  Created by Jokinryou Tsui on 11/26/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FullDishesCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dishNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *dishImage;

@end
