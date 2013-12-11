//
//  CategoryCell.m
//  qrrestaurant
//
//  Created by Jokinryou Tsui on 11/26/13.
//  Copyright (c) 2013 Boke Technology co., ltd. All rights reserved.
//

#import "CategoryCell.h"

@implementation CategoryCell

@synthesize categoryNameLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
