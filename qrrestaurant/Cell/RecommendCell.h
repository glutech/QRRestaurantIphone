//
//  RecommendCell.h
//  qrrestaurant
//
//  Created by Jokinryou Tsui on 11/28/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecommendCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dishNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *dishImage;

@end
