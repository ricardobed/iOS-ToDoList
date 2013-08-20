//
//  ToDoListCustomCell.m
//  ToDoList2
//
//  Created by Ricardo Bedoya on 8/18/13.
//  Copyright (c) 2013 Ricardo Bedoya. All rights reserved.
//

#import "ToDoListCustomCell.h"

@implementation ToDoListCustomCell

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
