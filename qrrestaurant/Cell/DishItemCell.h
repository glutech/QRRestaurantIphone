//
//  DishItemCell.h
//  qrrestaurant
//
//  Created by Jokinryou Tsui on 12/11/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DishItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dishNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *dishPriceLabel;

//@property (weak, nonatomic) IBOutlet UIImageView *dishImage;
//@property (weak, nonatomic) IBOutlet UIButton *dishImage;

@property (weak, nonatomic) IBOutlet UIImageView *dishImage;


@end
